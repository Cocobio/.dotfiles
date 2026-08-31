# Custom kitty tab bar — "pill" powerline tabs.
#
# Two things kitty's built-in powerline styles don't do:
#
#   1. The first tab has a flat left edge, because separators are only drawn on
#      the RIGHT of each tab.
#   2. A non-first active tab ends up with a *concave* left edge, because its
#      left boundary is the previous tab's separator bulging into it.
#
# This is an adaptation of kitty.tab_bar.draw_tab_with_powerline that draws an
# opening cap before tab 1, and — when the NEXT tab is the active one — emits the
# mirrored cap instead of the usual separator. That inverts the curve at that
# boundary, so the active tab bulges outward on both sides while still costing
# exactly one cell, as kitty's layout accounting expects.
#
# Requires `tab_bar_style custom` in kitty.conf. `tab_powerline_style` still
# selects the glyph pair.
#
# If a kitty upgrade changes this API, set `tab_bar_style powerline` in
# kitty.conf and this file is ignored.

from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    as_rgb,
    draw_title,
    powerline_symbols,
)

# Mirrors of kitty's own hard separators: round U+E0B4, slanted U+E0BC,
# angled U+E0B0.
LEFT_CAP = {
    'round': '\ue0b6',    # mirror of kitty's \ue0b4
    'slanted': '\ue0ba',  # mirror of \ue0bc
    'angled': '\ue0b2',   # mirror of \ue0b0
}


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    tab_bg = screen.cursor.bg
    tab_fg = screen.cursor.fg
    default_bg = as_rgb(int(draw_data.default_bg))

    if extra_data.next_tab:
        next_tab_bg = as_rgb(draw_data.tab_bg(extra_data.next_tab))
        needs_soft_separator = next_tab_bg == tab_bg
    else:
        next_tab_bg = default_bg
        needs_soft_separator = False

    separator_symbol, soft_separator_symbol = powerline_symbols.get(
        draw_data.powerline_style, ('', '')
    )
    left_cap = LEFT_CAP.get(draw_data.powerline_style, '')

    min_title_length = 1 + 2
    start_draw = 2

    # Opening cap for the leftmost tab: its colour over the bar background.
    if left_cap and index == 1:
        screen.cursor.fg = tab_bg
        screen.cursor.bg = default_bg
        screen.draw(left_cap)
        screen.cursor.fg = tab_fg
        start_draw = 1

    if screen.cursor.x == 0:
        screen.cursor.bg = tab_bg
        screen.draw(' ')
        start_draw = 1

    screen.cursor.bg = tab_bg
    if min_title_length >= max_tab_length:
        screen.draw('…')
    else:
        draw_title(draw_data, screen, tab, index, max_tab_length)
        extra = screen.cursor.x + start_draw - before - max_tab_length
        if extra > 0 and extra + 1 < screen.cursor.x:
            screen.cursor.x -= extra + 1
            screen.draw('…')

    next_is_active = bool(extra_data.next_tab and extra_data.next_tab.is_active)

    if next_is_active and left_cap:
        # Invert the boundary so the active tab curves outward rather than
        # having the previous tab curve into it.
        screen.draw(' ')
        screen.cursor.fg = next_tab_bg
        screen.cursor.bg = tab_bg
        screen.draw(left_cap)
        # The trailing pad kitty appends below is the ACTIVE tab's left padding,
        # so hand it that background. Left as tab_bg it renders as a dark cell
        # wedged between the cap and the active tab's text.
        screen.cursor.bg = next_tab_bg
    elif not needs_soft_separator:
        screen.draw(' ')
        screen.cursor.fg = tab_bg
        screen.cursor.bg = next_tab_bg
        screen.draw(separator_symbol)
    else:
        prev_fg = screen.cursor.fg
        if tab_bg == tab_fg:
            screen.cursor.fg = default_bg
        elif tab_bg != default_bg:
            c1 = draw_data.inactive_bg.contrast(draw_data.default_bg)
            c2 = draw_data.inactive_bg.contrast(draw_data.inactive_fg)
            if c1 < c2:
                screen.cursor.fg = default_bg
        screen.draw(f' {soft_separator_symbol}')
        screen.cursor.fg = prev_fg

    end = screen.cursor.x
    if end < screen.columns:
        screen.draw(' ')

    return end

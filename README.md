lister.vim
==========

lister.vim is a collection of commands for manipulating and moving between
lists. In contrast to the `:Cfilter` command from the [Cfilter plug-in](https://github.com/vim/vim/blob/master/runtime/pack/dist/opt/cfilter/plugin/cfilter.vim) 
built into Vim 8.2 that matches the file path and message content, it splits it into two commands
`:Qgrep` and `:Qfilter` that match only the message or file path. 

Quickfix list and Location list
-------------------------------

`:Qgrep {pattern}` will narrow down the quickfix list to results with a
message matching the given pattern. `:Qgrep! {pattern}` will narrow down the
results to those whose message *does not* match the given pattern.

Similarly, `:Qfilter {pattern}` will narrow the quickfix list to results with a
filename matching the given pattern (and `:Qfilter!` for the inverse).

For the location list, there are `:Lgrep` and `:Lfilter` commands.

The `{pattern}` argument is always a Vim-flavoured regex.

Argument list
-------------

`:Agrep [arguments]` runs `:grep [arguments]` on the files in the argument
list. If provided, `!` is passed directly to `:grep`. This causes the quickfix
list to be populated, but Vim does not move to the first item.

`:Afilter {pattern}` narrows the argument list to those with a filename
matching `{pattern}`. `:Afilter!` does the same, but where filenames do not
match a pattern.

Moving between types of lists
-----------------------------

`:Qargs` populates the argument list with a unique set of files from the
quickfix list. Similar for `:Largs`, but with the location list.

`:Sargs` will convert all of the windows in the current tab page into a local
argument list.

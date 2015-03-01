function! s:sargs(bang)
	let l:command = a:bang == '!' ? 'arglocal!' : 'args'
	execute l:command join(map(tabpagebuflist(), 'bufname(v:val)'), ' ')
	execute winnr() 'argument'
	only
endfunction

function! s:to_args(list, bang)
	let l:dict = {}
	for l:item in a:list
		let l:dict[bufname(l:item.bufnr)] = ''
	endfor
	let l:cmd = a:bang == '!' ? 'arglocal!' : 'args'
	echo l:cmd
	silent! execute l:cmd join(keys(l:dict))
endfunction

function! s:get_arg_list()
	return map(range(0, argc() - 1), 'argv(v:val)')
endfunction

function! s:arg_grep(command, query, bang)
	let l:args = join(s:get_arg_list())
	execute a:command.a:bang a:query l:args
endfunction

function! s:arg_filter(query, bang)
	let l:op = a:bang == '!' ? '!~#' : '=~#'
	let l:filter = 'v:val '.l:op.' "'.escape(a:query, '"\').'"'
	let l:args = join(filter(s:get_arg_list(), l:filter))
	execute 'args' l:args
endfunction

function! s:grep_list(list, pattern, v, lhs)
	let l:lhs_expressions = {'text': 'v:val.text', 'file': 'bufname(v:val.bufnr)'}
	let l:lhs = l:lhs_expressions[a:lhs]
	let l:op = a:v == '!' ? '!~#' : '=~#'
	let l:filter = l:lhs.' '.l:op.' "'.escape(a:pattern, '"\').'"'
	if a:list == 'q'
		let l:original_size = len(getqflist())
		call setqflist(filter(getqflist(), l:filter))
		let l:new_size = len(getqflist())
	else
		let l:original_size = len(getloclist(0))
		call setloclist(0, filter(getloclist(0), l:filter))
		let l:new_size = len(getloclist(0))
	endif
	echo l:original_size 'items trimmed to' l:new_size
endfunction

command! -bang Sargs call s:sargs(<q-bang>)
command! -bang Qargs call s:to_args(getqflist(), <q-bang>)
command! -bang Largs call s:to_args(getloclist(0), <q-bang>)
command! -nargs=* -bang Agrep call s:arg_grep('grep', <q-args>, <q-bang>)
command! -nargs=* -bang Avimgrep call s:arg_grep('vimgrep', <q-args>, <q-bang>)
command! -nargs=* -bang Algrep call s:arg_grep('lgrep', <q-args>, <q-bang>)
command! -nargs=* -bang Alvimgrep call s:arg_grep('lvimgrep', <q-args>, <q-bang>)
command! -nargs=* -bang Afilter call s:arg_filter(<q-args>, <q-bang>)
command! -bang -nargs=* Qgrep call s:grep_list('q', <q-args>, <q-bang>, 'text')
command! -bang -nargs=* Lgrep call s:grep_list('l', <q-args>, <q-bang>, 'text')
command! -bang -nargs=* Qfilter call s:grep_list('q', <q-args>, <q-bang>, 'file')
command! -bang -nargs=* Lfilter call s:grep_list('l', <q-args>, <q-bang>, 'file')

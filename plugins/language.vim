" let g:languagetool_server_jar="/usr/share/java/languagetool/languagetool-server.jar"
let g:languagetool_jar = "/usr/share/java/languagetool/languagetool-commandline.jar"
let g:grammarous#languagetool_cmd = 'languagetool'
let g:grammarous#use_vim_spelllang=1

let g:grammarous#enabled_rules = {
			\ '*' : ['PASSIVE_VOICE'],
			\ }
" let g:grammarous#enabled_categories = {'*' : ['PUNCTUATION']}
" not sure if this is everything
let g:grammarous#enabled_categories = {'*' : ['PUNCTUATION', 'TYPOGRAPHY', 'CASING', 'COLLOCATIONS', 'CONFUSED_WORDS', 'CREATIVE_WRITING', 'GRAMMAR', 'MISC', 'PLAIN_ENGLISH', 'TYPOS', 'REDUNDANCY', 'SEMANTICS', 'TEXT_ANALYSIS', 'STYLE', 'GENDER_NEUTRALITY']}
let g:grammarous#enabled_rules = {'*' : ['AND_ALSO', 'ARE_ABLE_TO', 'ARTICLE_MISSING', 'AS_FAR_AS_X_IS_CONCERNED', 'BEST_EVER', 'BLEND_TOGETHER', 'BRIEF_MOMENT', 'CAN_NOT', 'CANT_HELP_BUT', 'COMMA_WHICH', 'EG_NO_COMMA', 'ELLIPSIS', 'EXACT_SAME', 'HONEST_TRUTH', 'HOPEFULLY', 'IE_NO_COMMA', 'IN_ORDER_TO', 'I_VE_A', 'NEGATE_MEANING', 'PASSIVE_VOICE', 'PLAN_ENGLISH', 'REASON_WHY', 'SENT_START_NUM', 'SERIAL_COMMA_OFF', 'SERIAL_COMMA_ON', 'SMARTPHONE', 'THREE_NN', 'TIRED_INTENSIFIERS', 'ULESLESS_THAT', 'WIKIPEDIA', 'WORLD_AROUND_IT']}

" let g:grammarous#disabled_rules = {
" 			\ '*' : ['WHITESPACE_RULE', 'EN_QUOTES'],
" 			\ 'help' : ['WHITESPACE_RULE', 'EN_QUOTES', 'SENTENCE_WHITESPACE', 'UPPERCASE_SENTENCE_START'],
" 			\ }

" let g:grammarous#disabled_categories = {
" 			\ '*' : ['PUNCTUATION'],
" 			\ 'help' : ['PUNCTUATION', 'TYPOGRAPHY'],
" 			\ }

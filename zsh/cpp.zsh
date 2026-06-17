alias B='function _b() { python3 ./cp_templates/bundle.py "$1.cpp" && oj-bundle "z.cpp" | grep -v "^#line " | iconv -t utf16 | tail -c +3 | clip.exe && rm "z.cpp"; }; _b'

alias D='function _d() { g++ "$1.cpp" -g -std=c++2a -Wall -Wextra -Wshadow -Wfloat-equal -fsanitize=undefined,address -ftrapv -DLOCAL -o "$1" && ./"$1" > out && echo "-------" && cat out; }; _d'
alias DACL='function _d() { g++ "$1.cpp" -g -std=c++2a -Wall -Wextra -Wshadow -Wfloat-equal -fsanitize=undefined,address -ftrapv -DLOCAL -I ac-library -o "$1" && ./"$1" > out && echo "-------" && cat out; }; _d'

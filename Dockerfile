FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake
RUN git clone https://github.com/lieff/minimp4.git
WORKDIR /minimp4
RUN afl-gcc minimp4_test.c -o /mp4_fuzz
RUN mkdir /mp4-corpus
RUN wget http://techslides.com/demos/sample-videos/small.mp4

# Actualy the testcase below triggers a bug in this program, lets use a testcase that does not
# and see if that single testcase mutated, can cause the same behavior
#RUN wget https://chromium.googlesource.com/chromium/src/+/lkgr/media/test/data/bear-ac3-only-frag.mp4

RUN mv small.mp4 /mp4-corpus

# mp4_fuzz -d -s -f small.mp4 /dev/null
# /dev/null is output file
ENTRYPOINT ["afl-fuzz", "-i", "/mp4-corpus", "-o", "/out"]
CMD ["/mp4_fuzz", "-d", "-s", "-f", "@@", "/dev/null"]

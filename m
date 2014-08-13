Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbaHMXbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 19:31:36 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:65319 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752683AbaHMXbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 19:31:34 -0400
Date: Wed, 13 Aug 2014 19:31:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Static build of libtraceevent failing on ubuntu13 x86_64
Message-ID: <20140813193129.119de5b1@gandalf.local.home>
In-Reply-To: <20140813225438.GM2718@kernel.org>
References: <20140813225438.GM2718@kernel.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2014 19:54:38 -0300
Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> Hi guys,
> 
> 	Have you ever stumbled on this?
> 



> /home/acme/git/linux/tools/lib/traceevent/libtraceevent.a(event-plugin.o): In function `load_plugin':
> /home/acme/git/linux/tools/lib/traceevent/event-plugin.c:256: warning: Using 'dlopen' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /usr/lib/gcc/x86_64-linux-gnu/4.8/../../../x86_64-linux-gnu/libaudit.a(libaudit.o): In function `audit_rule_fieldpair_data':
> (.text+0x191b): warning: Using 'getgrnam' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /usr/lib/gcc/x86_64-linux-gnu/4.8/../../../x86_64-linux-gnu/libaudit.a(libaudit.o): In function `audit_rule_fieldpair_data':
> (.text+0x1978): warning: Using 'getpwnam' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> libperf.a(target.o): In function `target__parse_uid':
> /home/acme/git/linux/tools/perf/util/target.c:79: warning: Using 'getpwnam_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /home/acme/git/linux/tools/perf/util/target.c:91: warning: Using 'getpwuid_r' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /usr/lib/gcc/x86_64-linux-gnu/4.8/../../../../lib/libnuma.a(affinity.o): In function `affinity_ip':
> (.text+0x765): warning: Using 'getaddrinfo' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
> /usr/lib/gcc/x86_64-linux-gnu/4.8/../../../../lib/libbfd.a(compress.o): In function `bfd_compress_section_contents':
> /build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:100: undefined reference to `compressBound'
> /build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:106: undefined reference to `compress'
> /usr/lib/gcc/x86_64-linux-gnu/4.8/../../../../lib/libbfd.a(compress.o): In function `decompress_contents':
> /build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:49: undefined reference to `inflateInit_'
> /build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:56: undefined reference to `inflate'
> /build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:59: undefined reference to `inflateReset'
> /build/buildd/binutils-2.23.52.20130913/builddir-single/bfd/../../bfd/compress.c:61: undefined reference to `inflateEnd'
> collect2: error: ld returned 1 exit status
> make[3]: *** [perf] Error 1
> make[2]: *** [all] Error 2
>   test: test -x ./perf
> make[1]: *** [make_static] Error 1
> make: *** [build-test] Error 2
> make: Leaving directory `/home/acme/git/linux/tools/perf'
> 
> real	14m52.077s
> user	39m36.668s
> sys	6m27.970s
> acme@ubuntu13:~/git/linux$ 

Nope, that's all new to me.

-- Steve

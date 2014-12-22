Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbaLVO4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:56:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:52523 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763AbaLVO4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:56:19 -0500
Date: Mon, 22 Dec 2014 11:56:15 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools: perf: util: color.c:  Remove some unused functions
Message-ID: <20141222145615.GD7644@kernel.org>
References: <1419079865-354-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141222145013.GB7644@kernel.org>
 <20141222145358.GC7644@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141222145358.GC7644@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 22, 2014 at 11:53:58AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Dec 22, 2014 at 11:50:13AM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Sat, Dec 20, 2014 at 01:51:05PM +0100, Rickard Strandqvist escreveu:
> > > Removes some functions that are not used anywhere:
> > > color_parse_mem() color_parse()
> > > 
> > > This was partially found by using a static code analysis program called cppcheck.
> > 
> > Thanks, applied.
> 
> Take that back, can you please check this:
> 
> [acme@ssdandy linux]$ am /wb/1.patch 
> Applying: tools: perf: util: color.c: Remove some unused functions
> [perf/core b419f879f2a0] perf tools: Remove some unused functions from color.c
>  Author: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>  2 files changed, 92 deletions(-)
> [acme@ssdandy linux]$ time make -C tools/perf build-test
> make: Entering directory `/home/acme/git/linux/tools/perf'
> - make_pure: cd . && make -f Makefile DESTDIR=/tmp/tmp.4b0BVUu9ff 
> cd . && make -f Makefile DESTDIR=/tmp/tmp.4b0BVUu9ff
>   BUILD:   Doing 'make -j8' parallel build
> config/Makefile:390: No libunwind found. Please install libunwind-dev[el] >= 1.1 and/or set LIBUNWIND_DIR

Removed the now unused parse_{attr,color} static routines and I'm
running 'make -C tools/perf build-test' again to see if all goes well.

- Arnaldo

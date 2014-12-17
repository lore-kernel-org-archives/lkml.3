Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaLQNnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 08:43:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaLQNnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 08:43:04 -0500
Date: Wed, 17 Dec 2014 14:42:23 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 10/18] tools lib: Move asm-generic/bitops/find.h code to
 tools/include and tools/lib
Message-ID: <20141217134223.GE18257@krava.brq.redhat.com>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
 <1418749040-31807-11-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418749040-31807-11-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 01:57:12PM -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> To match the Linux kernel source code structure from where this code came from.

SNIP

> diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
> index 67d48e20f7e1..bfd7e22bafad 100644
> --- a/tools/perf/MANIFEST
> +++ b/tools/perf/MANIFEST
> @@ -4,8 +4,10 @@ tools/lib/traceevent
>  tools/lib/api
>  tools/lib/symbol/kallsyms.c
>  tools/lib/symbol/kallsyms.h
> +tools/lib/util/find_next_bit.c
>  tools/include/asm/bug.h
>  tools/include/asm-generic/bitops/atomic.h
> +tools/include/asm-generic/bitops/find.h
>  tools/include/asm-generic/bitops/__ffs.h
>  tools/include/linux/compiler.h
>  tools/include/linux/export.h
> @@ -18,6 +20,7 @@ include/linux/rbtree.h
>  include/linux/list.h
>  include/linux/hash.h
>  include/linux/stringify.h
> +lib/find_next_bit.c
>  lib/rbtree.c
>  include/linux/swab.h
>  arch/*/include/asm/unistd*.h
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index fc4082fdf6bf..2d799da4eacc 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -233,6 +233,7 @@ LIB_H += ../../include/linux/stringify.h
>  LIB_H += util/include/linux/bitmap.h
>  LIB_H += util/include/linux/bitops.h
>  LIB_H += ../include/asm-generic/bitops/atomic.h 
> +LIB_H += ../include/asm-generic/bitops/find.h 

whitespace at the EOLN ;-)

jirka

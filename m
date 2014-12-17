Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaLQN2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 08:28:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbaLQN2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 08:28:30 -0500
Date: Wed, 17 Dec 2014 14:27:44 +0100
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
Subject: Re: [PATCH 06/18] tools: Move __ffs implementation to
 tools/include/asm-generic/bitops/__ffs.h
Message-ID: <20141217132744.GC18257@krava.brq.redhat.com>
References: <1418749040-31807-1-git-send-email-acme@kernel.org>
 <1418749040-31807-7-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418749040-31807-7-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 01:57:08PM -0300, Arnaldo Carvalho de Melo wrote:

SNIP

> +	}
> +	if ((word & 0x1) == 0)
> +		num += 1;
> +	return num;
> +}
> +
> +#endif /* _TOOLS_LINUX_ASM_GENERIC_BITOPS___FFS_H_ */
> diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
> index 344c4d3d0a4a..39c08636357b 100644
> --- a/tools/perf/MANIFEST
> +++ b/tools/perf/MANIFEST
> @@ -5,6 +5,7 @@ tools/lib/api
>  tools/lib/symbol/kallsyms.c
>  tools/lib/symbol/kallsyms.h
>  tools/include/asm/bug.h
> +tools/include/asm-generic/bitops/__ffs.h
>  tools/include/linux/compiler.h
>  tools/include/linux/hash.h
>  tools/include/linux/export.h
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 763e68fb5767..bfd86a32254a 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -232,6 +232,7 @@ LIB_H += ../include/linux/hash.h
>  LIB_H += ../../include/linux/stringify.h
>  LIB_H += util/include/linux/bitmap.h
>  LIB_H += util/include/linux/bitops.h
> +LIB_H += ../include/asm-generic/bitops/__ffs.h 

whitespace at the EOLN ;-)

jirka

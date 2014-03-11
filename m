Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaCKNi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:38:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbaCKNiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:38:24 -0400
Date: Tue, 11 Mar 2014 14:37:41 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, eranian@google.com, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/8] perf, tools: Automatically look for event file name
 for cpu
Message-ID: <20140311133741.GB22678@krava.redhat.com>
References: <1394048978-15909-1-git-send-email-andi@firstfloor.org>
 <1394048978-15909-4-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394048978-15909-4-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 11:49:33AM -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 

SNIP

> 
> diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
> index 1641542..0efeb14 100644
> --- a/tools/perf/arch/x86/Makefile
> +++ b/tools/perf/arch/x86/Makefile
> @@ -14,4 +14,5 @@ LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/dwarf-unwind.o
>  endif
>  LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
>  LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/tsc.o
> +LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/cpustr.o
>  LIB_H += arch/$(ARCH)/util/tsc.h
> diff --git a/tools/perf/arch/x86/util/cpustr.c b/tools/perf/arch/x86/util/cpustr.c
> new file mode 100644
> index 0000000..0fb987a
> --- /dev/null
> +++ b/tools/perf/arch/x86/util/cpustr.c
> @@ -0,0 +1,35 @@
> +#define _GNU_SOURCE 1

_GNU_SOURCE is defined by default

jirka

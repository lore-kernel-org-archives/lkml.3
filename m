Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab3ILMUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:20:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44463 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab3ILMUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:20:04 -0400
Date: Thu, 12 Sep 2013 14:19:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 0/3] perf: parse the dwarf backtrace info from
 .debug_frame section
Message-ID: <20130912121953.GX31370@twins.programming.kicks-ass.net>
References: <1378720815-23964-1-git-send-email-jean.pihet@linaro.org>
 <CAFrcx1mQ-P7byYfqP-0bYabUzTDeSWyHFx2FJQ6wQLYEcV_Pxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1mQ-P7byYfqP-0bYabUzTDeSWyHFx2FJQ6wQLYEcV_Pxw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 02:07:23PM +0200, Jean Pihet wrote:
> Hi,
> 
> -- Adding more maintainers in the To: list --
> 
> Ping about the patch set, is this one acceptable for mainline?

The below looks to be mostly ARM bits and I would suspect Will to take
care of them.

> On 9 September 2013 12:00, Jean Pihet <jean.pihet@linaro.org> wrote:

> >  arch/arm/Kconfig                        |  2 +
> >  arch/arm/include/uapi/asm/Kbuild        |  1 +
> >  arch/arm/include/uapi/asm/perf_regs.h   | 23 +++++++++++
> >  arch/arm/kernel/Makefile                |  1 +
> >  arch/arm/kernel/perf_regs.c             | 30 ++++++++++++++
> >  tools/perf/arch/arm/Makefile            |  3 ++
> >  tools/perf/arch/arm/include/perf_regs.h | 54 +++++++++++++++++++++++++
> >  tools/perf/arch/arm/util/unwind.c       | 48 ++++++++++++++++++++++
> >  tools/perf/config/Makefile              |  9 +++--
> >  tools/perf/util/unwind.c                | 71 +++++++++++++++++++++++++--------

This one looks to be generic code, Acme who do we want to look at that?

> >  10 files changed, 223 insertions(+), 19 deletions(-)
> >  create mode 100644 arch/arm/include/uapi/asm/perf_regs.h
> >  create mode 100644 arch/arm/kernel/perf_regs.c
> >  create mode 100644 tools/perf/arch/arm/include/perf_regs.h
> >  create mode 100644 tools/perf/arch/arm/util/unwind.c
> >
> > --
> > 1.7.11.7
> >

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaD1JZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:25:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251AbaD1JZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:25:18 -0400
Date: Mon, 28 Apr 2014 11:24:15 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>,
        Patch Tracking <patches@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] perf: ARM64: wire up perf_regs and unwind support
Message-ID: <20140428092415.GA1109@krava.brq.redhat.com>
References: <1392311193-21214-1-git-send-email-jean.pihet@linaro.org>
 <CAFrcx1=ZBWt1mak_6+=KbCFZEsaD3T_xZ8up4WBLSr6_JTkP1A@mail.gmail.com>
 <20140312174520.GB17308@arm.com>
 <20140313101202.GB11365@mudshark.cambridge.arm.com>
 <20140313102203.GC30339@arm.com>
 <CAFrcx1mZg-kdBG2d4bwWdqJByYXLG2SJ5+GD7cSteqJj=A6Sxw@mail.gmail.com>
 <CAFrcx1mvSMFea999FZCEVxMZsmyFw+b_fugdGSEsAJkqwzkXQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1mvSMFea999FZCEVxMZsmyFw+b_fugdGSEsAJkqwzkXQw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 11:15:43AM +0200, Jean Pihet wrote:
> Arnaldo,
> 
> > This patch hooks in the perf_regs and libunwind code for ARM64.
> > The tools/perf/arch/arm64 is created; it contains the arch specific
> > code for DWARF unwinding.
> >
> > Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> > Acked-by: Will Deacon <will.deacon@arm.com>
> 
> Ping on this patch. Can you take this patch in your tree?
> Please let me know if you need a rebased version of this one.

I'll check this one

jirka

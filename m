Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbaD1JPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:15:46 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:33652 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723AbaD1JPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:15:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAFrcx1mZg-kdBG2d4bwWdqJByYXLG2SJ5+GD7cSteqJj=A6Sxw@mail.gmail.com>
References: <1392311193-21214-1-git-send-email-jean.pihet@linaro.org>
	<CAFrcx1=ZBWt1mak_6+=KbCFZEsaD3T_xZ8up4WBLSr6_JTkP1A@mail.gmail.com>
	<20140312174520.GB17308@arm.com>
	<20140313101202.GB11365@mudshark.cambridge.arm.com>
	<20140313102203.GC30339@arm.com>
	<CAFrcx1mZg-kdBG2d4bwWdqJByYXLG2SJ5+GD7cSteqJj=A6Sxw@mail.gmail.com>
Date: Mon, 28 Apr 2014 11:15:43 +0200
Message-ID: <CAFrcx1mvSMFea999FZCEVxMZsmyFw+b_fugdGSEsAJkqwzkXQw@mail.gmail.com>
Subject: Re: [PATCH] perf: ARM64: wire up perf_regs and unwind support
From: Jean Pihet <jean.pihet@linaro.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Patch Tracking <patches@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo,

> This patch hooks in the perf_regs and libunwind code for ARM64.
> The tools/perf/arch/arm64 is created; it contains the arch specific
> code for DWARF unwinding.
>
> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> Acked-by: Will Deacon <will.deacon@arm.com>

Ping on this patch. Can you take this patch in your tree?
Please let me know if you need a rebased version of this one.

Regards,
Jean

On 13 March 2014 13:01, Jean Pihet <jean.pihet@linaro.org> wrote:
> On 13 March 2014 11:22, Catalin Marinas <catalin.marinas@arm.com> wrote:
>> On Thu, Mar 13, 2014 at 10:12:02AM +0000, Will Deacon wrote:
>>> On Wed, Mar 12, 2014 at 05:45:20PM +0000, Catalin Marinas wrote:
>>> > On Wed, Mar 12, 2014 at 01:42:51PM +0100, Jean Pihet wrote:
>>> > > On 13 February 2014 18:06, Jean Pihet <jean.pihet@linaro.org> wrote:
>>> > > > This patch hooks in the perf_regs and libunwind code for ARM64.
>>> > > > The tools/perf/arch/arm64 is created; it contains the arch specific
>>> > > > code for DWARF unwinding.
>>> > > >
>>> > > > Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
>>> > > > Acked-by: Will Deacon <will.deacon@arm.com>
>>> > >
>>> > > Ping on this patch. Can this one go into the perf tree?
>>> >
>>> > I'm happy to take it as well if there are no objections from the perf
>>> > maintainers.
>>>
>>> I object :) Last time I took a patch for perf tools (via the arm tree) it
>>> ended in a conflict from hell and we vowed not to take tools patches via
>>> arch trees again.
>>
>> Works for me ;)
> Ok thanks!
>
> Arnaldo, can you take this patch in your tree?
>
> Jean
>
>>
>> --
>> Catalin

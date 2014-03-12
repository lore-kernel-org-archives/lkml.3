Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbaCLRpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:45:47 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:18380 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755446AbaCLRpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:45:46 -0400
Date: Wed, 12 Mar 2014 17:45:20 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnaldo <acme@ghostprotocols.net>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Patch Tracking <patches@linaro.org>
Subject: Re: [PATCH] perf: ARM64: wire up perf_regs and unwind support
Message-ID: <20140312174520.GB17308@arm.com>
References: <1392311193-21214-1-git-send-email-jean.pihet@linaro.org>
 <CAFrcx1=ZBWt1mak_6+=KbCFZEsaD3T_xZ8up4WBLSr6_JTkP1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1=ZBWt1mak_6+=KbCFZEsaD3T_xZ8up4WBLSr6_JTkP1A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 01:42:51PM +0100, Jean Pihet wrote:
> Hi,
> 
> On 13 February 2014 18:06, Jean Pihet <jean.pihet@linaro.org> wrote:
> > This patch hooks in the perf_regs and libunwind code for ARM64.
> > The tools/perf/arch/arm64 is created; it contains the arch specific
> > code for DWARF unwinding.
> >
> > Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> > Acked-by: Will Deacon <will.deacon@arm.com>
> 
> Ping on this patch. Can this one go into the perf tree?

I'm happy to take it as well if there are no objections from the perf
maintainers.

-- 
Catalin

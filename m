Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3KFQpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:45:44 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:30506 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754967Ab3KFQpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:45:32 -0500
Date: Wed, 6 Nov 2013 11:45:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Jiang Liu <liuj97@gmail.com>, Catalin Marinas <Catalin.Marinas@arm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Jiang Liu <jiang.liu@huawei.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 4/7] arm64: introduce
 aarch64_insn_gen_{nop|branch_imm}() helper functions
Message-ID: <20131106114530.76b63b05@gandalf.local.home>
In-Reply-To: <20131030004840.GC25346@mudshark.cambridge.arm.com>
References: <1382109602-27432-1-git-send-email-liuj97@gmail.com>
	<1382109602-27432-5-git-send-email-liuj97@gmail.com>
	<20131030004840.GC25346@mudshark.cambridge.arm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct 2013 00:48:40 +0000
Will Deacon <will.deacon@arm.com> wrote:


> > +}
> > +
> > +static __always_inline u32 aarch64_insn_gen_nop(void)
> > +{
> > +	return aarch64_insn_gen_hint(AARCH64_INSN_HINT_NOP);
> > +}
> 
> Either use plain old `inline' or write these as preprocessor macros.
> 

I'm curious to why you say that? Preprocessor macros are rather ugly,
and in x86 we use "__always_inline" quite liberally.

-- Steve

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbaHZORV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:17:21 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37140 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758250AbaHZORT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:17:19 -0400
Date: Tue, 26 Aug 2014 15:16:08 +0100
From: Will Deacon <will.deacon@arm.com>
To: Behan Webster <behanw@converseincode.com>
Cc: "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "k.khlebnikov@samsung.com" <k.khlebnikov@samsung.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "takahiro.akashi@linaro.org" <takahiro.akashi@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
Subject: Re: [PATCH 0/4] LLVMLinux: Patches to enable the kernel to be
 compiled with clang/LLVM
Message-ID: <20140826141608.GT23445@arm.com>
References: <1406764649-20326-1-git-send-email-behanw@converseincode.com>
 <20140731103323.GL26853@arm.com>
 <53DB138F.7070709@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53DB138F.7070709@converseincode.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Behan,

On Fri, Aug 01, 2014 at 05:11:59AM +0100, Behan Webster wrote:
> On 07/31/14 03:33, Will Deacon wrote:
> > On Thu, Jul 31, 2014 at 12:57:25AM +0100, behanw@converseincode.com wrote:
> >> From: Behan Webster <behanw@converseincode.com>
> >>
> >> This patch set moves from using locally defined named registers to access the
> >> stack pointer to using a globally defined named register. This allows the code
> >> to work both with gcc and clang.
> >>
> >> The LLVMLinux project aims to fully build the Linux kernel using both gcc and
> >> clang (the C front end for the LLVM compiler infrastructure project).
> >>
> >> Behan Webster (4):
> >>    arm64: LLVMLinux: Add current_stack_pointer() for arm64
> >>    arm64: LLVMLinux: Use current_stack_pointer in save_stack_trace_tsk
> >>    arm64: LLVMLinux: Calculate current_thread_info from
> >>      current_stack_pointer
> >>    arm64: LLVMLinux: Use current_stack_pointer in kernel/traps.c
> > Once Andreas's comments have been addressed:
> >
> >    Acked-by: Will Deacon <will.deacon@arm.com>
> >
> > Please can you send a new series after the merge window?
> Pity. I was hoping to get it in this merge window.
> 
> However, will resubmit for 3.18.

Any chance of a v2 for this series, please? If you address the comments
pending for v1, I think it's good to merge.

Will

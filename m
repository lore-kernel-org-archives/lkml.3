Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab3LQNPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:15:03 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53541 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3LQNPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:15:00 -0500
Date: Tue, 17 Dec 2013 14:14:56 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Alex Shi <alex.shi@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        H Peter Anvin <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/3] x86: mm: Change tlb_flushall_shift for IvyBridge
Message-ID: <20131217131456.GA28688@gmail.com>
References: <1386849309-22584-3-git-send-email-mgorman@suse.de>
 <20131212131309.GD5806@gmail.com>
 <52A9BC3A.7010602@linaro.org>
 <20131212141147.GB17059@gmail.com>
 <52AA5C92.7030207@linaro.org>
 <52AA6CB9.60302@linaro.org>
 <20131214141902.GA16438@laptop.programming.kicks-ass.net>
 <20131214142741.GB16438@laptop.programming.kicks-ass.net>
 <20131216135901.GA6171@gmail.com>
 <52B03C84.1000600@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B03C84.1000600@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alex Shi <alex.shi@linaro.org> wrote:

> > Building the kernel is obviously a prime workload - and given that 
> > the kernel is active only about 10% of the time for a typical 
> > kernel build, a 1-2% speedup means a 10-20% speedup in kernel 
> > performance (which sounds a bit too good at first glance).
> 
> Maybe a extra time tlb flush causes more tlb refill that cost much 
> user space time.

All these things are measurable, that way maybes can be converted into 
certainty.

Thanks,

	Ingo

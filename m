Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3LQL7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 06:59:13 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:55678 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab3LQL7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 06:59:11 -0500
Message-ID: <52B03C84.1000600@linaro.org>
Date: Tue, 17 Dec 2013 19:59:00 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
CC: Mel Gorman <mgorman@suse.de>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/3] x86: mm: Change tlb_flushall_shift for IvyBridge
References: <1386849309-22584-1-git-send-email-mgorman@suse.de> <1386849309-22584-3-git-send-email-mgorman@suse.de> <20131212131309.GD5806@gmail.com> <52A9BC3A.7010602@linaro.org> <20131212141147.GB17059@gmail.com> <52AA5C92.7030207@linaro.org> <52AA6CB9.60302@linaro.org> <20131214141902.GA16438@laptop.programming.kicks-ass.net> <20131214142741.GB16438@laptop.programming.kicks-ass.net> <20131216135901.GA6171@gmail.com>
In-Reply-To: <20131216135901.GA6171@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2013 09:59 PM, Ingo Molnar wrote:
> So if the kbuild speedup of 1-2% is true and reproducable then that 
> might be worth doing.

I have a Intel desktop and need it for daily works. Wonder if Intel guys
like to have a try? I assume the patch is already in Fengguang's testing
system.
> 
> Building the kernel is obviously a prime workload - and given that the 
> kernel is active only about 10% of the time for a typical kernel 
> build, a 1-2% speedup means a 10-20% speedup in kernel performance 
> (which sounds a bit too good at first glance).

Maybe a extra time tlb flush causes more tlb refill that cost much user
space time.
-- 
Thanks
    Alex

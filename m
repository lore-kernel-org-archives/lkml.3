Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab3BVF5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 00:57:54 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:33904 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab3BVF5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 00:57:51 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mats Liljegren <mats.liljegren@enea.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC/PATCH 2/5] kernel_cpustat: convert to atomic 64-bit accessors
References: <1361389302-11968-1-git-send-email-khilman@linaro.org>
	<1361389302-11968-3-git-send-email-khilman@linaro.org>
	<87y5ehmp8d.fsf@linaro.org>
	<CAFTL4hw1=mKtUadL0WDrydtspOehKuW7jhhzr65vXR2P2zdTWw@mail.gmail.com>
	<CAFTL4hzHbp-JYgAbMRc4tefJZh9ZVdqGMp3ZTQAe-kmaX1fC3w@mail.gmail.com>
Date: Thu, 21 Feb 2013 21:57:46 -0800
In-Reply-To: <CAFTL4hzHbp-JYgAbMRc4tefJZh9ZVdqGMp3ZTQAe-kmaX1fC3w@mail.gmail.com>
	(Frederic Weisbecker's message of "Thu, 21 Feb 2013 22:54:43 +0100")
Message-ID: <8738woriud.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> 2013/2/21 Frederic Weisbecker <fweisbec@gmail.com>:
>> 2013/2/21 Kevin Hilman <khilman@linaro.org>:
>>> Subject: [PATCH 2/5] kernel_cpustat: convert to atomic 64-bit accessors
>>>
>>> Use the atomic64_* accessors for all the kernel_cpustat fields to
>>> ensure atomic access on non-64 bit platforms.
>>>
>>> Thanks to Mats Liljegren for CGROUP_CPUACCT related fixes.
>>>
>>> Cc: Mats Liljegren <mats.liljegren@enea.com>
>>> Signed-off-by: Kevin Hilman <khilman@linaro.org>
>>
>> Funny stuff, I thought struct kernel_cpustat was made of cputime_t
>> field. Actually it's u64. So the issue is independant from the new
>> full dynticks cputime accounting. It was already broken before.
>>
>> But yeah that's not the point, we still want to fix this anyway. But
>> let's just treat this patch as independant.

OK, I just sent an updated series based on your proposal.

Thanks for the review,

Kevin

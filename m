Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaBXPMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:12:12 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:51856 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaBXPMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:12:08 -0500
Message-ID: <530B6147.6010301@linaro.org>
Date: Mon, 24 Feb 2014 16:12:07 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, tglx@linutronix.de, rjw@rjwysocki.net,
        nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/5] idle/cpuidle: Split cpuidle_idle_call main function
 into smaller functions
References: <1393250151-6982-1-git-send-email-daniel.lezcano@linaro.org> <20140224150004.GX27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140224150004.GX27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 04:00 PM, Peter Zijlstra wrote:
>
>
> None of this actually applies :/ I'm having major conflicts in
> driveres/cpuidle/cpuidle.c.

Ok, except if I am missing something, the patchset is based on top of 
tip/sched/core (commit 6990566).



-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


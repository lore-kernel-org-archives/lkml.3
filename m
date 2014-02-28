Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbaB1Pbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:31:47 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:34827 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaB1Pbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:31:46 -0500
Message-ID: <5310ABE5.50209@linaro.org>
Date: Fri, 28 Feb 2014 16:31:49 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, tglx@linutronix.de, rjw@rjwysocki.net,
        nicolas.pitre@linaro.org, preeti@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/5] idle/cpuidle: Split cpuidle_idle_call main function
 into smaller functions
References: <1393315733-32321-1-git-send-email-daniel.lezcano@linaro.org> <20140228125604.GN27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140228125604.GN27965@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 01:56 PM, Peter Zijlstra wrote:
>
>
> Daniel; can you rebase these patches on top of tip/master.

Yes, sure. No problem.

> Ingo is going to create tip/sched/idle := tip/sched/core +
> tip/timer/core and then we can stick these patches in there.

Perfect !

Thanks
   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


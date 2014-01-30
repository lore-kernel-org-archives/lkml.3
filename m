Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaA3Pj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:39:59 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:37475 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbaA3Pj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:39:58 -0500
Message-ID: <52EA724E.8080107@linaro.org>
Date: Thu, 30 Jan 2014 16:39:58 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: nicolas.pitre@linaro.org, mingo@redhat.com, tglx@linutronix.de,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC PATCH 1/3] cpuidle: split cpuidle_idle_call main function
 into functions
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org> <1391090962-15032-2-git-send-email-daniel.lezcano@linaro.org> <20140130152721.GC5002@laptop.programming.kicks-ass.net>
In-Reply-To: <20140130152721.GC5002@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2014 04:27 PM, Peter Zijlstra wrote:
> On Thu, Jan 30, 2014 at 03:09:20PM +0100, Daniel Lezcano wrote:
>> +EXPORT_SYMBOL(cpuidle_select);
>> +EXPORT_SYMBOL(cpuidle_enter);
>> +EXPORT_SYMBOL(cpuidle_reflect);
>
> $ grep EXPORT_SYMBOL drivers/cpuidle/cpuidle.c
> EXPORT_SYMBOL_GPL(cpuidle_pause_and_lock);
> EXPORT_SYMBOL_GPL(cpuidle_resume_and_unlock);
> EXPORT_SYMBOL_GPL(cpuidle_enable_device);
> EXPORT_SYMBOL_GPL(cpuidle_disable_device);
> EXPORT_SYMBOL_GPL(cpuidle_register_device);
> EXPORT_SYMBOL_GPL(cpuidle_unregister_device);
> EXPORT_SYMBOL_GPL(cpuidle_unregister);
> EXPORT_SYMBOL_GPL(cpuidle_register);

Ah, right.

Thanks!


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3LJM7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:59:23 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:48306 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3LJM7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:59:21 -0500
Message-ID: <52A71027.4000902@linaro.org>
Date: Tue, 10 Dec 2013 13:59:19 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Axel Lin <axel.lin@ingics.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] clocksource/clockevents fixes for 3.13
References: <52A0AC37.5010006@linaro.org> <20131210122051.GD30001@gmail.com>
In-Reply-To: <20131210122051.GD30001@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 01:20 PM, Ingo Molnar wrote:
>
> * Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>
>>
>> Hi Thomas,
>>
>> here are the fixes for 3.13 based on timers/urgent
>
> Please generally also post the patches to make it easier to review
> them.

Hi Ingo,

what do you mean by "also post the patches" ? The patches were posted in 
the mailing lists and I picked them up after people reviewed them.

Or shall I give a combined diff when sending the PR ?

>>   * Axel Lin removed the bcm_timer_ids which are no longer used due
>> to the conversion to clksrc-of and added a missing dependency on
>> CLKSRC_MMIO in the Kconfig for the time-efm32.
>
> Is the ID removal a necessary regression fix? If not then it has no
> place in the urgent queue.

No, you are right. It is not a regression fix. I assumed it was an 
acceptable patch for urgent but apparently not. Thanks for clarifying 
this. Let me resend a new PR without this patch.

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


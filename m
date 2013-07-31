Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab3GaXQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 19:16:36 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:52380 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab3GaXQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 19:16:35 -0400
Message-ID: <51F99AD4.1070009@linaro.org>
Date: Thu, 01 Aug 2013 01:16:36 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 0/5] Memory mapped architected timers
References: <1374191972-18015-1-git-send-email-sboyd@codeaurora.org> <20130722170817.GB4833@e106331-lin.cambridge.arm.com> <20130724203253.GE27761@codeaurora.org> <20130731223833.GJ8868@codeaurora.org>
In-Reply-To: <20130731223833.GJ8868@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 12:38 AM, Stephen Boyd wrote:
> On 07/24, Stephen Boyd wrote:
>> On 07/22, Mark Rutland wrote:
>>> Hi Stephen,
>>>
>>> On Fri, Jul 19, 2013 at 12:59:27AM +0100, Stephen Boyd wrote:
>>>> This patchset adds support for memory mapped architected timers. We
>>>> don't have any other global broadcast timer in our system, so we use the
>>>> mmio timer during low power modes. The first patch changes the register
>>>> accessor to an enum per Thomas' request. The second patch is the binding.
>>>> The next two patches lay some groundwork so that the last patch is simpler.
>>>> The final patch adds support for mmio timers.
>>>>
>>>> Patches are based on v3.11-rc1.
>>>
>>> Be aware that as of v3.11-rc2 this doesn't cleanly apply, as the
>>> __cpuinit removal broke the final patch's context in a couple of places.
>>> It would be nice to get rid of the new cpuinit additions too...
>>>
>>> With that cleaned up locally, I've gave this a spin on tc2 and a
>>> Foundation model to test the cp15/system timers, hotplugging CPUs and
>>> running a basic test (`time sleep 5`). That all seems to work.
>>>
>>> Unfortunately I have no way of testing the memory-mapped timer support,
>>> but I trust you've tested that locally.
>>>
>>> For the series:
>>>
>>> Acked-by: Mark Rutland <mark.rutland@arm.com>
>>>
>>
>> Thanks Mark.
>>
>> Daniel, can you pick up these patches please?
>>
> 
> Ping Daniel?

Applied to my tree as 3.12 material

Thanks
  -- Daniel


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


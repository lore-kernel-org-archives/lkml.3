Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaB1G6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 01:58:13 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:64944 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaB1G6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 01:58:10 -0500
Message-ID: <53103383.8090604@linaro.org>
Date: Fri, 28 Feb 2014 07:58:11 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 0/4] ARM: zynq: cpufreq support
References: <1392851684-29950-1-git-send-email-soren.brinkmann@xilinx.com> <3402bb7c-3dec-403a-9356-65af803e1b0a@AM1EHSMHS017.ehs.local>
In-Reply-To: <3402bb7c-3dec-403a-9356-65af803e1b0a@AM1EHSMHS017.ehs.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 06:52 PM, Sören Brinkmann wrote:
> Hi Daniel, Michal,
>
> On Wed, 2014-02-19 at 03:14PM -0800, Soren Brinkmann wrote:
>> Hi,
>>
>> another iteration of this series. The patches are the same as in v3, but
>> the series shrank a bit. I rebased this series on tip/timers/core, hence
>> the two patches for the clockevent core fell out, since Thomas already
>> applied those.
>> Additionally I removed the patch 'clocksource/cadence_ttc: Use only one
>> counter'. Thomas brought up some questions regarding that patch which
>> need to be investigated. Since it is not required for the rest of this
>> series, I just dropped it for now.
>>
>> 	Thanks,
>> 	Sören
>>
>> Soren Brinkmann (4):
>>    clocksource/cadence_ttc: Call clockevents_update_freq() with IRQs
>>      enabled
>>    clocksource/cadence_ttc: Overhaul clocksource frequency adjustment
>>    arm: zynq: Don't use arm_global_timer with cpufreq
>>    arm: zynq: Add support for cpufreq
>
> Any comments? I think most of these should be pretty straight forward
> and it would be nice to get some ACKs - or tell me what's wrong. :)
> 'clocksource/cadence_ttc: Overhaul clocksource frequency adjustment'
> might deserve a more thorough review.

Hi Soren,

I will be at Linaro Connect. Give me a couple of days, I will review 
them again.

Thanks
   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


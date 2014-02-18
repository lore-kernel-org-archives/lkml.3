Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbaBRKrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:47:01 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41344 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbaBRKqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:46:53 -0500
Message-ID: <53033A1A.5050404@linaro.org>
Date: Tue, 18 Feb 2014 11:46:50 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, santosh.shilimkar@ti.com,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        galak@codeaurora.org, mark.rutland@arm.com, devicetree@vger.kernel.org,
        grygorii.strashko@ti.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, joshc@codeaurora.org,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        robh+dt@kernel.org, tglx@linutronix.de,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v6 1/3] clocksource: timer-keystone: introduce clocksource
 driver for Keystone
References: <1392027058-11680-1-git-send-email-ivan.khoronzhuk@ti.com>	<1392027058-11680-2-git-send-email-ivan.khoronzhuk@ti.com>	<52FA1E59.1000307@linaro.org> <CABuKBeJNwe5VXi2SvPX6Cne-iMHP7bbZarJDNAzuCMbg0E-bCQ@mail.gmail.com>
In-Reply-To: <CABuKBeJNwe5VXi2SvPX6Cne-iMHP7bbZarJDNAzuCMbg0E-bCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 11:40 AM, Matthias Brugger wrote:
> 2014-02-11 13:58 GMT+01:00 Daniel Lezcano <daniel.lezcano@linaro.org>:
>> On 02/10/2014 11:10 AM, Ivan Khoronzhuk wrote:
>>>
>>> Add broadcast clock-event device for the Keystone arch.
>>>
>>> The timer can be configured as a general-purpose 64-bit timer,
>>> dual general-purpose 32-bit timers. When configured as dual 32-bit
>>> timers, each half can operate in conjunction (chain mode) or
>>> independently (unchained mode) of each other.
>>>
>>> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
>>> Acked-by: Santosh shilimkar <santosh.shilimkar@ti.com>
>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>>> ---
>>
>>
>> Applied to my tree for 3.15
>
> I wanted to send a trivial follow-up patch, but I can't find the tree
> to which you have applied this patch.
> Would you mind to indicate me where I can find it.

Sure.

git://git.linaro.org/people/daniel.lezcano/linux.git #clockevents/3.15

Regards
   -- Daniel

>
> Cheers,
> Matthias
>
>>
>> --
>>   <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
>>
>> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
>> <http://twitter.com/#!/linaroorg> Twitter |
>> <http://www.linaro.org/linaro-blog/> Blog
>>
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


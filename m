Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaKZMx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 07:53:28 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:54956 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaKZMx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 07:53:27 -0500
Message-ID: <5475CD41.8090903@linaro.org>
Date: Wed, 26 Nov 2014 13:53:21 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>
CC: Doug Anderson <dianders@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Olof Johansson <olof@lixom.net>, Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Nathan Lynch <Nathan_Lynch@mentor.com>,
        Rob Herring <robh+dt@kernel.org>, Sonny Rao <sonnyrao@chromium.org>
Subject: Re: [PATCH v4] clocksource: arch_timer: Allow the device tree to
 specify uninitialized timer registers
References: <1412753627-28287-1-git-send-email-sonnyrao@chromium.org> <11522840.iniX5CHHHk@diego> <5475CC75.5030300@linaro.org> <19683112.9S9LAQsUEX@diego>
In-Reply-To: <19683112.9S9LAQsUEX@diego>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 01:55 PM, Heiko Stübner wrote:
> Am Mittwoch, 26. November 2014, 13:49:57 schrieb Daniel Lezcano:
>> On 11/26/2014 01:48 PM, Heiko Stübner wrote:
>>> Am Mittwoch, 26. November 2014, 13:30:58 schrieb Daniel Lezcano:
>>>> On 11/26/2014 01:06 PM, Heiko Stübner wrote:
>>>>> Hi Daniel,
>>>>>
>>>>> Am Mittwoch, 26. November 2014, 12:51:08 schrieb Daniel Lezcano:
>>>>>> Hi Doug, Olof,
>>>>>>
>>>>>> IIUC, it sounds like this patch is needed from some other patches in
>>>>>> arm-soc. Olof was proposing to take this patch through its tree to
>>>>>> facilitate the integration.
>>>>>>
>>>>>> Olof, is it this patch you were worried about ?
>>>>>
>>>>> I think this is one of two patches in question.
>>>>>
>>>>> "clocksource: arch_timer: Fix code to use physical timers when
>>>>> requested"
>>>>> [0] would be the second one.
>>>>>
>>>>> And the patch for arm-soc that Olof means would be "ARM: dts: rk3288:
>>>>> add
>>>>> arm,cpu-registers-not-fw-configured" [1].
>>>>
>>>> Ok, so IIUC, "clocksource: arch_timer: Fix code to use physical timers
>>>> when requested" should go via arm's tree, right ?
>>>
>>> If I'm reading Olof's irc-comments from yesterday correctly, that is right
>>> and the 3 patches should go in together:
>>>
>>> - "clocksource: arch_timer: Fix code to use physical timers
>>>
>>>     when requested" fixes the use of physical timers in general
>>>
>>> - "clocksource: arch_timer: Allow the device tree to specify uninitialized
>>>
>>>     timer registers" allows this to be set from dt
>>>
>>> - "ARM: dts: rk3288: add arm,cpu-registers-not-fw-configured" enables this
>>> on>
>>>     rk3288
>>
>> Ok, then I drop them from my tree and will let Olof to handle them.
>
> But maybe you could give them an Ack :-)

Already done :)

   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog


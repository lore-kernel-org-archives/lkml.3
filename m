Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab3JWIlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 04:41:44 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45364 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab3JWIlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 04:41:40 -0400
Message-ID: <52678BBD.4080505@baylibre.com>
Date: Wed, 23 Oct 2013 10:41:33 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, Bryan Wu <cooloney@gmail.com>
CC: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>, Milo Kim <milo.kim@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/2] leds: lp55xx: handle enable pin in driver
References: <1382446896-28436-1-git-send-email-sre@debian.org> <1382446896-28436-2-git-send-email-sre@debian.org> <20131022170604.GP15154@atomide.com> <CAK5ve-KWdJFuJsvQ+JS2y7bpa9j4hGdU=ceb4nAz8BKQ1M9_XA@mail.gmail.com> <20131022173742.GQ15154@atomide.com> <CAK5ve-JhehHHAU_2tN-RVb8+u2AbUS_Yx=k+i0Ponnm9Wir+OQ@mail.gmail.com> <20131023081957.GB16686@atomide.com>
In-Reply-To: <20131023081957.GB16686@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/10/2013 10:19, Tony Lindgren wrote:
> * Bryan Wu <cooloney@gmail.com> [131022 10:47]:
>> On Tue, Oct 22, 2013 at 10:37 AM, Tony Lindgren <tony@atomide.com> wrote:
>>> * Bryan Wu <cooloney@gmail.com> [131022 10:23]:
>>>> On Tue, Oct 22, 2013 at 10:06 AM, Tony Lindgren <tony@atomide.com> wrote:
>>>>> * Sebastian Reichel <sre@debian.org> [131022 06:02]:
>>>>>> This patch moves the handling of the chip's enable pin from the board
>>>>>> code into the driver. It also updates all board-code files using the
>>>>>> driver to incorporate this change.
>>>>>>
>>>>>> This is needed for device tree support of the enable pin.
>>>>>
>>>>> This seems safe to merge along with the other LED patches, the
>>>>> changes to arch/arm/mach-omap2 should not conflict with anything.
>>>>>
>>>>> So for the arch/arm/mach-omap2 changes:
>>>>>
>>>>> Acked-by: Tony Lindgren <tony@atomide.com>
>>>>
>>>> I'm OK for LED parts, will this patch go through omap tree? If so,
>>>> please add my ack.
>>>>
>>>> Acked-by: Bryan Wu <cooloney@gmail.com>
>>>
>>> It's probably best that you take it via with the LED patches.
>>>
>>
>> OK, I will do it. what about PATCH 2 of this patch set? Will you take
>> care of it?
>
> Benoit should take that one, otherwise there's a good chance of
> pointless merge conflicts with the .dts files.

I've just merged it.

Regards,
Benoit

-- 
Benoît Cousson
BayLibre
Embedded Linux Technology Lab
www.baylibre.com

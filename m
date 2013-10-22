Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab3JVRrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:47:07 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46144 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3JVRrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:47:03 -0400
MIME-Version: 1.0
In-Reply-To: <20131022173742.GQ15154@atomide.com>
References: <1382446896-28436-1-git-send-email-sre@debian.org>
 <1382446896-28436-2-git-send-email-sre@debian.org> <20131022170604.GP15154@atomide.com>
 <CAK5ve-KWdJFuJsvQ+JS2y7bpa9j4hGdU=ceb4nAz8BKQ1M9_XA@mail.gmail.com> <20131022173742.GQ15154@atomide.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 22 Oct 2013 10:46:41 -0700
Message-ID: <CAK5ve-JhehHHAU_2tN-RVb8+u2AbUS_Yx=k+i0Ponnm9Wir+OQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] leds: lp55xx: handle enable pin in driver
To: Tony Lindgren <tony@atomide.com>
Cc: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 10:37 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Bryan Wu <cooloney@gmail.com> [131022 10:23]:
>> On Tue, Oct 22, 2013 at 10:06 AM, Tony Lindgren <tony@atomide.com> wrote:
>> > * Sebastian Reichel <sre@debian.org> [131022 06:02]:
>> >> This patch moves the handling of the chip's enable pin from the board
>> >> code into the driver. It also updates all board-code files using the
>> >> driver to incorporate this change.
>> >>
>> >> This is needed for device tree support of the enable pin.
>> >
>> > This seems safe to merge along with the other LED patches, the
>> > changes to arch/arm/mach-omap2 should not conflict with anything.
>> >
>> > So for the arch/arm/mach-omap2 changes:
>> >
>> > Acked-by: Tony Lindgren <tony@atomide.com>
>>
>> I'm OK for LED parts, will this patch go through omap tree? If so,
>> please add my ack.
>>
>> Acked-by: Bryan Wu <cooloney@gmail.com>
>
> It's probably best that you take it via with the LED patches.
>

OK, I will do it. what about PATCH 2 of this patch set? Will you take
care of it?

Thanks,
-Bryan

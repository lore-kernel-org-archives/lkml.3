Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab3JVRX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:23:27 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:50897 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab3JVRXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:23:24 -0400
MIME-Version: 1.0
In-Reply-To: <20131022170604.GP15154@atomide.com>
References: <1382446896-28436-1-git-send-email-sre@debian.org>
 <1382446896-28436-2-git-send-email-sre@debian.org> <20131022170604.GP15154@atomide.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 22 Oct 2013 10:22:59 -0700
Message-ID: <CAK5ve-KWdJFuJsvQ+JS2y7bpa9j4hGdU=ceb4nAz8BKQ1M9_XA@mail.gmail.com>
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

On Tue, Oct 22, 2013 at 10:06 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Sebastian Reichel <sre@debian.org> [131022 06:02]:
>> This patch moves the handling of the chip's enable pin from the board
>> code into the driver. It also updates all board-code files using the
>> driver to incorporate this change.
>>
>> This is needed for device tree support of the enable pin.
>
> This seems safe to merge along with the other LED patches, the
> changes to arch/arm/mach-omap2 should not conflict with anything.
>
> So for the arch/arm/mach-omap2 changes:
>
> Acked-by: Tony Lindgren <tony@atomide.com>

I'm OK for LED parts, will this patch go through omap tree? If so,
please add my ack.

Acked-by: Bryan Wu <cooloney@gmail.com>

Thanks,
-Bryan

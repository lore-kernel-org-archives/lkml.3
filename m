Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab3C0Pq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:46:59 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:37333 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3C0Pq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:46:58 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZO4gF9Zfj0Y2WJL-bZRUpQVxMGG99W5+TWzu--wG8sag@mail.gmail.com>
References: <20130326002301.10878.32801.sendpatchset@w520>
	<CACRpkdZO4gF9Zfj0Y2WJL-bZRUpQVxMGG99W5+TWzu--wG8sag@mail.gmail.com>
Date: Thu, 28 Mar 2013 00:46:56 +0900
Message-ID: <CANqRtoQWKSQYRJDryhMi793jRuODp5gSXY3d3O2CyuRG13eY6A@mail.gmail.com>
Subject: Re: [PATCH] gpio: Renesas R-Car GPIO driver V3
From: Magnus Damm <magnus.damm@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        grant.likely@secretlab.ca, horms@verge.net.au,
        laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 12:16 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Tue, Mar 26, 2013 at 1:23 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
>
>> From: Magnus Damm <damm@opensource.se>
>>
>> This patch is V3 of a GPIO driver for the R-Car series of
>> SoCs from Renesas. This driver is designed to be reusable
>> between multiple SoCs that share the same basic building block,
>> but so far it has only been used on R-Car H1 (r8a7779).
>>
>> Each driver instance handles 32 GPIOs with individually
>> maskable IRQs. The driver operates on a single I/O memory
>> range and the 32 GPIOs are hooked up a single interrupt.
>>
>> In the case of R-Car H1 either external IRQ pins or GPIOs
>> with interrupts can be used for on-board interupts. For
>> external IRQs 4 pins are supported, and in the case of GPIO
>> there are 202 GPIOS as 202 interrupts hooked up via 6 driver
>> instances and to the GIC and the Cortex-A9 Quad.
>>
>> At this point this driver is interfacing as a regular
>> platform device driver. In the future DT support will be
>> submitted as an incremental feature patch.
>>
>> Signed-off-by: Magnus Damm <damm@opensource.se>
>
> Gorgeous driver.
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Thanks! This particular GPIO hardware block hasn't been around for so
long so it's still not spoiled by special cases like the PFC or INTC
stuff.

Cheers,

/ magnus

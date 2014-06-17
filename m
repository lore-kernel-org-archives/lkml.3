Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaFQASj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 20:18:39 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:64406 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaFQASi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 20:18:38 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZ3xfOXrMZK-Z7TteOsdnVP8uOY4+DLe7pv_9ydBCRRWQ@mail.gmail.com>
References: <1401995603-25997-1-git-send-email-andrew.ruder@elecsyscorp.com>
	<CACRpkdZ3xfOXrMZK-Z7TteOsdnVP8uOY4+DLe7pv_9ydBCRRWQ@mail.gmail.com>
Date: Tue, 17 Jun 2014 08:18:36 +0800
Message-ID: <CAN1soZz__VrLj57yLVTgqLnEUnS2wqaAv71kwnbZ5oRCVVoCNw@mail.gmail.com>
Subject: Re: [PATCH] gpio-pxa: gpio0 and gpio1 support on dt
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Andrew Ruder <andrew.ruder@elecsyscorp.com>,
        =?UTF-8?B?TWFyZWsgVmHFoXV0?= <marek.vasut@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 4:43 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Jun 5, 2014 at 9:13 PM, Andrew Ruder
> <andrew.ruder@elecsyscorp.com> wrote:
>
>> pxa_gpio_probe() has some issues supporting the gpio0 and gpio1
>> interrupts under device-tree - it never actually sets up the chain
>> handler to get interrupts on edge detect for GPIO0 and GPIO1.
>>
>> Signed-off-by: Andrew Ruder <andrew.ruder@elecsyscorp.com>
>
> Makes perfect sense. Can I have an ACK from some PXA
> maintainer on this?
>
> The PXA GPIO driver with it's messy irqchip registration looks
> like a good candidate for switching to the gpiolib irqchip helpers
> and rid some code. Just saying.
>
> Yours,
> Linus Walleij

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>

Yes, it's worth to rid some irqchip code.

Regards
Haojian

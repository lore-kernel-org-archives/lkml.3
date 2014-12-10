Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575AbaLJPz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:55:27 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:46463 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932224AbaLJPzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:55:22 -0500
MIME-Version: 1.0
In-Reply-To: <8a16af8e063b4250ba5e78f2409efef4@BN1AFFO11FD024.protection.gbl>
References: <1418225100-2949-1-git-send-email-ricardo.ribalda@gmail.com>
 <1418225100-2949-3-git-send-email-ricardo.ribalda@gmail.com> <8a16af8e063b4250ba5e78f2409efef4@BN1AFFO11FD024.protection.gbl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 10 Dec 2014 16:54:59 +0100
Message-ID: <CAPybu_0Vx_=AVg4kWfux1aiEKEq6yfK2yiZ3cnHXahZebOG8jg@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] gpio/xilinx: Convert the driver to platform device interface
To: Michal Simek <michal.simek@xilinx.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Still not correct.
Not my day.

> Here should be module_exit if you want to use as module.
> I expect that you haven't tested it.


No, I only tried the original patchset, I assumed this was just
cosmetic changes ;)

Right now I have tested it  :P

 to attach helpers instead.
[  199.175954] XGpio: /axi1/gpio_0: registered, base is 509
[  242.362202] gpio-xilinx 80040000.gpio_0: REMOVING GPIOCHIP WITH
GPIOS STILL REQUESTED
[  242.362218] gpio-xilinx 80040000.gpio_0: REMOVING GPIOCHIP WITH
GPIOS STILL REQUESTED
[  242.362222] gpio-xilinx 80040000.gpio_0: REMOVING GPIOCHIP WITH
GPIOS STILL REQUESTED


I am resending only this patch to avoid spamming the list


>
> Thanks,

Thank you!


> Michal
>
>



-- 
Ricardo Ribalda

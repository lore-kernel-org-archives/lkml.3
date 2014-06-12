Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbaFLInR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 04:43:17 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:65029 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932680AbaFLInM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 04:43:12 -0400
MIME-Version: 1.0
In-Reply-To: <1401995603-25997-1-git-send-email-andrew.ruder@elecsyscorp.com>
References: <1401995603-25997-1-git-send-email-andrew.ruder@elecsyscorp.com>
Date: Thu, 12 Jun 2014 10:43:11 +0200
Message-ID: <CACRpkdZ3xfOXrMZK-Z7TteOsdnVP8uOY4+DLe7pv_9ydBCRRWQ@mail.gmail.com>
Subject: Re: [PATCH] gpio-pxa: gpio0 and gpio1 support on dt
From: Linus Walleij <linus.walleij@linaro.org>
To: Andrew Ruder <andrew.ruder@elecsyscorp.com>,
        =?UTF-8?B?TWFyZWsgVmHFoXV0?= <marek.vasut@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 9:13 PM, Andrew Ruder
<andrew.ruder@elecsyscorp.com> wrote:

> pxa_gpio_probe() has some issues supporting the gpio0 and gpio1
> interrupts under device-tree - it never actually sets up the chain
> handler to get interrupts on edge detect for GPIO0 and GPIO1.
>
> Signed-off-by: Andrew Ruder <andrew.ruder@elecsyscorp.com>

Makes perfect sense. Can I have an ACK from some PXA
maintainer on this?

The PXA GPIO driver with it's messy irqchip registration looks
like a good candidate for switching to the gpiolib irqchip helpers
and rid some code. Just saying.

Yours,
Linus Walleij

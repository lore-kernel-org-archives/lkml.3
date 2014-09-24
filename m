Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbaIXJTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:19:24 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:54019 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaIXJTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:19:21 -0400
MIME-Version: 1.0
In-Reply-To: <704b6bb97147b3d0ee1557b43d85ab9376c28666.1411404079.git.stefan@agner.ch>
References: <cover.1411404079.git.stefan@agner.ch>
	<704b6bb97147b3d0ee1557b43d85ab9376c28666.1411404079.git.stefan@agner.ch>
Date: Wed, 24 Sep 2014 11:19:20 +0200
Message-ID: <CACRpkdYCiKzyVpg9u-YXn-QMd7PSKR72siXQQWALe0OqTNr-rw@mail.gmail.com>
Subject: Re: [PATCH 5/9] gpio: vf610: Extend with wakeup support
From: Linus Walleij <linus.walleij@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        Alexandre Courbot <gnurou@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        jingchang.lu@freescale.com,
        Huang Yongcai-B20788 <b20788@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 7:09 PM, Stefan Agner <stefan@agner.ch> wrote:

> Support Vybrid GPIO's as wakeup source by requesting the parent
> IRQ as wakeup IRQ.
>
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  drivers/gpio/gpio-vf610.c | 16 ++++++++++++++++

This driver is not yet upstream. Make wakeup support part
of the initial driver submission instead, it doesn't hurt.

Yours,
Linus Walleij

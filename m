Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaB0NnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:43:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:65294 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaB0NnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:43:10 -0500
From: Fabian Vogt <fabian@ritter-vogt.de>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH V6] gpio: New driver for LSI ZEVIO SoCs
Date: Thu, 27 Feb 2014 15:43:21 +0100
Message-ID: <1584880.3T2YsxZdKp@fabians-laptop.fritz.box>
User-Agent: KMail/4.10.5 (Linux/3.7.10-1.16-desktop; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CACRpkdZqAMMvHiGwVDNnZ7Lg9RUVtjFGdfnZF3+QrX0KRPVJGA@mail.gmail.com>
References: <1393271698-15829-1-git-send-email-fabian@ritter-vogt.de> <CACRpkdZqAMMvHiGwVDNnZ7Lg9RUVtjFGdfnZF3+QrX0KRPVJGA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
X-Provags-ID: V02:K0:QvmTn0eW5PN3pm84LZho9YouBhPECumOjTBp8N0gZUw
 F0a79EZ5eFLDZCpSIW0kYcASOudkXzHTiRng0IxIn5zXqwW0tX
 /Rp0SZyKSEqMjw/dMQo9PlzxgmJ65v3L3K6q0LAZgHXnOiuaFp
 nWRG747xfkN+yeD32LoahlSZzQ7MTzjZW68fTIfs2M2pUsb8ZR
 0er6QW5K5Oghapm+v8wZNkRnqYd0siVp4o/MRTFjskji2Gbev3
 iB8RF/mK1Lu2IWpdEC8KgkELweogE4tm1gzJ2djR31Za4LENyx
 HvnmMwfpu2dzEz5UXdDxnBJij2RMxtj/+x2pVvxO7gnBmVcHaM
 r6GWQ0IlU+cWCDs+xDi6ZjVhQPra/+biqIZbE6yT6ndbu0+D88
 JuupJODjGa+/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2014 at 10:31:59, Linux Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Feb 24, 2014 at 8:54 PM, Fabian Vogt <fabian@ritter-vogt.de> wrote:
> 
> > This driver supports the GPIO controller found in LSI ZEVIO SoCs.
> > It has been successfully tested on a TI nspire CX calculator.
> >
> > Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>
> 
> I like this version. Patch applied.
> 
> Q:
> 
> > +config GPIO_ZEVIO
> > +       bool "LSI ZEVIO SoC memory mapped GPIOs"
> > +       depends on OF
> 
> So OF_GPIO is not needed for the systems using this driver?
> DT just used for probing the driver?
> 
I'm using of_mm_gpiochip_add to register the gpiochip.
In the platform's Kconfig only ARCH_WANT_OPTIONAL_GPIOLIB is needed, OF_GPIO seems to be selected automatically.
If I disable it in the .config and start "make menuconfig", it's selected again.
OF_GPIO seems to have the same state as GPIOLIB in menuconfig.

Bye,
Fabian

> Yours,
> Linus Walleij

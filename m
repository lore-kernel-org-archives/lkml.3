Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaIDQ4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:56:51 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:33983 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaIDQ4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:56:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140831152456.GA25207@udknight>
References: <20140831152456.GA25207@udknight>
Date: Thu, 4 Sep 2014 18:56:49 +0200
Message-ID: <CACRpkdZ35WTug2ZUN3-hqg9-BB59eHO+vzOsUE+C-yb+AEp2Zg@mail.gmail.com>
Subject: Re: [PATCH v8] usb:serial:pl2303: add GPIOs interface on PL2303
From: Linus Walleij <linus.walleij@linaro.org>
To: Wang YanQing <udknight@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Johan Hovold <jhovold@gmail.com>, andi@lisas.de, dforsi@gmail.com,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 31, 2014 at 5:24 PM, Wang YanQing <udknight@gmail.com> wrote:

> PL2303 USB Serial devices may has GPIOs, this patch add
> basic PL2303 gpio support.
>
> Known issue:
> If gpios are in use(export to userspace through sysfs interface, etc),
> then call pl2303_release(unplug usb-serial convertor, modprobe -r, etc),
> will cause trouble, so we need to make sure there is no gpio user before
> call pl2303_release.
>
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  Note: I sniffed office HXD gpio test program to get
>        gpios control protocol with PL2303 RA, so I only
>        test it with PL2303 RA and HXA, I don't have HXD,
>        but because it is *office* HXD gpio test program,
>        so if it doesn't work with HXD, I will feel surprise.
>
>  Changes
>  v7-v8:
>  1: add support for four dedicated gpios on HXD and RA
>  2: fix problem reported by Johan Hovold in v7
>  3: fix checkpatch.pl's warning

This has been looking nice from the GPIO side of things
for a while so:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

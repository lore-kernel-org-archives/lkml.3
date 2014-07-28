Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbaG1KQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 06:16:17 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:36272 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaG1KQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 06:16:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140724170356.GA1783@udknight>
References: <20140724170356.GA1783@udknight>
Date: Mon, 28 Jul 2014 12:16:14 +0200
Message-ID: <CACRpkdaQwZQeshacMLnWSEL0X=rOQtDkoxcE-6+688EBp4ANLQ@mail.gmail.com>
Subject: Re: [PATCH v4] usb:serial:pl2303: add GPIOs interface on PL2303
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

On Thu, Jul 24, 2014 at 7:03 PM, Wang YanQing <udknight@gmail.com> wrote:

> PL2303HX has two GPIOs, this patch add interface for it.
>
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  Changes v3-v4:
>  1: fix missing static for gpio_dir_mask and gpio_value_mask
>  2: reduce unneeded compile macro defined suggested by gnomes@lxorguk.ukuu.org.uk
>  3: use true instead of 1 corrected by Linus Walleij
>  4: ignore return value of gpiochip_remove suggested by Linus Walleij
>  5: fix multi gpio_chips registered by pl2303 can't be distinguished in kernel space.

This is OK with me now,
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab3DYNDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:03:00 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:47158 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388Ab3DYNC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:02:57 -0400
MIME-Version: 1.0
In-Reply-To: <1366729394-11406-3-git-send-email-lee.jones@linaro.org>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
	<1366729394-11406-3-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 15:02:56 +0200
Message-ID: <CACRpkdZbHy9CX+b1zUAyuFWw4+9VffG2KVx4CgqdHtHpP4w40A@mail.gmail.com>
Subject: Re: [PATCH 02/10] usb: musb: ux500: move the MUSB HDRC configuration
 into the driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 5:03 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The MUSB HDRC configuration never changes between each of the ux500
> supported platforms, so there's little point passing it though platform
> data. If we set it in the driver instead, we can make good use of it
> when booting with either ATAGs or Device Tree.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

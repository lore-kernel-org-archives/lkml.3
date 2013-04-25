Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab3DYNEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:04:04 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:61110 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064Ab3DYNEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:04:02 -0400
MIME-Version: 1.0
In-Reply-To: <1366729394-11406-4-git-send-email-lee.jones@linaro.org>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
	<1366729394-11406-4-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 15:04:01 +0200
Message-ID: <CACRpkdZv8b7F6XotTUriP1hOgtabBpCUPyU6D9nYSZQU8x431w@mail.gmail.com>
Subject: Re: [PATCH 03/10] usb: musb: ux500: take the dma_mask from coherent_dma_mask
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
        Fabio Baltieri <fabio.baltieri@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 5:03 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The dma_mask will always be the same as the coherent_dma_mask, so let's
> cut down on the platform_data burden and set it as such in the driver.
> This also saves us from supporting it separately when we come to enable
> this driver for Device Tree.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

And makes it way more readable too!

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij

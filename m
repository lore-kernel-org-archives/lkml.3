Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967939Ab3E3Ich (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 04:32:37 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:60011 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967878Ab3E3Ica (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 04:32:30 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-23-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-23-git-send-email-lee.jones@linaro.org>
Date: Thu, 30 May 2013 10:32:29 +0200
Message-ID: <CACRpkdZo_ymcubrvm1k9+VKJq6ED-xOSv7V_Sry8ffhFB3RqyA@mail.gmail.com>
Subject: Re: [PATCH 22/39] usb: musb: ux500: take the dma_mask from coherent_dma_mask
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> The dma_mask will always be the same as the coherent_dma_mask, so let's
> cut down on the platform_data burden and set it as such in the driver.
> This also saves us from supporting it separately when we come to enable
> this driver for Device Tree.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Tentatively applied with Felipe's ACK.

Yours,
Linus Walleij

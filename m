Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967927Ab3E3IbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 04:31:05 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:45151 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967878Ab3E3Iaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 04:30:55 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-22-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-22-git-send-email-lee.jones@linaro.org>
Date: Thu, 30 May 2013 10:30:55 +0200
Message-ID: <CACRpkdYOxOz_hGpijHhVeDJFg66j31CuDqA-cTmaJoJSJMoDqQ@mail.gmail.com>
Subject: Re: [PATCH 21/39] usb: musb: ux500: move the MUSB HDRC configuration
 into the driver
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

> The MUSB HDRC configuration never changes between each of the ux500
> supported platforms, so there's little point passing it though platform
> data. If we set it in the driver instead, we can make good use of it
> when booting with either ATAGs or Device Tree.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Tentatively applied with Felipe's ACK.

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967998Ab3E3Ipz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 04:45:55 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:51372 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967974Ab3E3Ipv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 04:45:51 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-29-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-29-git-send-email-lee.jones@linaro.org>
Date: Thu, 30 May 2013 10:45:51 +0200
Message-ID: <CACRpkdZLjRv3RZk_+gpOJb-4UQcThxPshKeH1Cw-n96FY3250w@mail.gmail.com>
Subject: Re: [PATCH 28/39] ARM: ux500: Remove empty function u8500_of_init_devices()
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

> As promised, now all devices which resided in u8500_of_init_devices()
> have been enabled for Device Tree, we can completely remove it.
>
> Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied on my ux500-dma40 branch.

And this is looking real good now!

Thanks!
Linus Walleij

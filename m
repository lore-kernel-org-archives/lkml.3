Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab3EOQ5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:57:05 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:38546 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588Ab3EOQ5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:57:03 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-7-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-7-git-send-email-lee.jones@linaro.org>
Date: Wed, 15 May 2013 18:51:38 +0200
Message-ID: <CACRpkdZ=NJR3VRNJE2pSTJ8t1VCMq+wjH_s0NOi4AHko3no_KA@mail.gmail.com>
Subject: Re: [PATCH 06/39] ARM: ux500: Move SDI (MMC) and UART devices under
 more descriptive heading
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

> Now DMA DT bindings exist and are in use by he MMC and UART drivers, it
> should be possible to remove them from the auxdata structure. However,
> after doing so the drivers fail. Common clk is still reliant on the
> dev_name() call to do device name matching, which will fail due to the
> fact that Device Tree naming differs somewhat do the more traditional
> conventions.
>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Cannot be applied due to dependency on 5/39.

Yours,
Linus Walleij

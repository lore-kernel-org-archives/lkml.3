Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030262Ab3E3JGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:06:15 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36245 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030243Ab3E3JGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:06:08 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-37-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-37-git-send-email-lee.jones@linaro.org>
Date: Thu, 30 May 2013 11:06:07 +0200
Message-ID: <CACRpkda1LOfPyzQRAwChSH9WtcCFnLNfFa5kp=8JWX0x7ioj+g@mail.gmail.com>
Subject: Re: [PATCH 36/39] dmaengine: ste_dma40: Allow memcpy channels to be
 configured from DT
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
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> At this moment in time the memcpy channels which can be used by the D40
> are fixed, as each supported platform in Mainline uses the same ones.
> However, platforms do exist which don't follow this convention, so
> these will need to be tailored. Fortunately, these platforms will be DT
> only, so this change has very little impact on platform data.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied with Vinod's ACK.

Yours,
Linus Walleij

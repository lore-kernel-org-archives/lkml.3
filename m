Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab3ETMGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 08:06:55 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:45606 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3ETMGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 08:06:53 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-14-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-14-git-send-email-lee.jones@linaro.org>
Date: Mon, 20 May 2013 14:06:52 +0200
Message-ID: <CACRpkdZBoB_2dBtvNFSfz9FxfaekR9TDQmt1FQbtd3oaFJjg=g@mail.gmail.com>
Subject: Re: [PATCH 13/39] crypto: ux500/hash - Set DMA configuration though dma_slave_config()
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
        Andreas Westin <andreas.westin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:

> The DMA controller currently takes configuration information from
> information passed though dma_channel_request(), but it shouldn't.
> Using the API, the DMA channel should only be configured during
> a dma_slave_config() call.
>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Andreas Westin <andreas.westin@stericsson.com>
> Cc: linux-crypto@vger.kernel.org
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied to my dma40 branch with Herbert's ACK.

Yours,
Linus Walleij

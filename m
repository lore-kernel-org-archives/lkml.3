Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968022Ab3E3JBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:01:40 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:48708 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967955Ab3E3JB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:01:28 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-35-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-35-git-send-email-lee.jones@linaro.org>
Date: Thu, 30 May 2013 11:01:27 +0200
Message-ID: <CACRpkdZ6bijvD1S+YL2W+8R_DVGrmPshiMVigg7iK4zen8r57g@mail.gmail.com>
Subject: Re: [PATCH 34/39] dmaengine: ste_dma40: Convert data_width from
 register bit format to value
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

> When a DMA client requests and configures a DMA channel, it requests
> data_width in Bytes. The DMA40 driver then swiftly converts it over to
> the necessary register bit value. Unfortunately, for any subsequent
> calculations we have to shift '1' by the bit pattern (1 << data_width)
> times to make any sense of it.
>
> This patch flips the semantics on its head and only converts the value
> to its respective register bit pattern when writing to registers. This
> way we can use the true data_width (in Bytes) value.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied with what I interpret as Vinod's ACK
("okay..." statement on last reply.)

Yours,
Linus Walleij

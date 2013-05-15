Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759759Ab3EORNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:13:09 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:52934 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759471Ab3EORNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:13:07 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-12-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-12-git-send-email-lee.jones@linaro.org>
Date: Wed, 15 May 2013 19:05:44 +0200
Message-ID: <CACRpkdYLwywT0R7zyd2d=1bH+FajV=yopHrvTMpYRYF+4zkQDQ@mail.gmail.com>
Subject: Re: [PATCH 11/39] ARM: ux500: Remove unnecessary attributes from DMA
 channel request pdata
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

> DMA data width and packet size information is only required at channel
> configuration time. Any information passed from platform data is passed
> directly to the DMA40 driver to use during channel allocation, but these
> pieces of information are subsequently ignored by the driver, so we may
> as well remove them.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied.

Yours,
Linus Walleij

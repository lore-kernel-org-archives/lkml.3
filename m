Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab3ETMJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 08:09:14 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:55966 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441Ab3ETMJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 08:09:12 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-15-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-15-git-send-email-lee.jones@linaro.org>
Date: Mon, 20 May 2013 14:09:11 +0200
Message-ID: <CACRpkdZWtm_6WD=ifYLH5QogzrCyHHuhJ4xHzAjiTWX_fYAKcQ@mail.gmail.com>
Subject: Re: [PATCH 14/39] ARM: ux500: Stop passing Hash DMA channel config
 information though pdata
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

> DMA channel configuration information should be setup in the driver.
> The Ux500 Hash driver now does this, so there's no need to send it
> though here too.
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied now that the deps are in!

Yours,
Linus Walleij

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030286Ab3E3JMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 05:12:14 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:53201 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030209Ab3E3JMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 05:12:08 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-38-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-38-git-send-email-lee.jones@linaro.org>
Date: Thu, 30 May 2013 11:12:07 +0200
Message-ID: <CACRpkdZ2-fBrjU-iofjq1DAJ96X2SqbjACsjEWYRxThnSm0yxQ@mail.gmail.com>
Subject: Re: [PATCH 37/39] ARM: ux500: Stop passing DMA platform data though AUXDATA
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

On Wed, May 15, 2013 at 11:52 AM, Lee Jones <lee.jones@linaro.org> wrote:

> The DMA platform data is now empty due to some recent refactoring,
> so there is no longer a requirement to pass it though.
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to dma40 branch, hm now I may get a conflict with all
the AUXDATA changes in the devicetree branch. Oh well, I'll
figure it out...

Yours,
Linus Walleij

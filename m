Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967772Ab3E3Ho4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:44:56 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:60284 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966777Ab3E3Hot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:44:49 -0400
MIME-Version: 1.0
In-Reply-To: <1368611522-9984-21-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
	<1368611522-9984-21-git-send-email-lee.jones@linaro.org>
Date: Thu, 30 May 2013 09:44:49 +0200
Message-ID: <CACRpkda+C7qzKSssXStkcM4eOQaHUcWEUd6txfV-pAWdTT=YEw@mail.gmail.com>
Subject: Re: [PATCH 20/39] usb: musb: ux500: move channel number knowledge
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

> For all ux500 based platforms the maximum number of end-points are used.
> Move this knowledge into the driver so we can relinquish the burden from
> platform data. This also removes quite a bit of complexity from the driver
> and will aid us when we come to enable the driver for Device Tree.
>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied to my dma40 branch with Felipe's ACK.

Thanks!
Linus Walleij

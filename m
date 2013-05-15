Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab3EOUPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 16:15:05 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:51434 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108Ab3EOUOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 16:14:55 -0400
Date: Wed, 15 May 2013 22:14:39 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
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
Subject: Re: [PATCH 20/39] usb: musb: ux500: move channel number knowledge
 into the driver
Message-ID: <20130515201439.GA10141@balto.lan>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-21-git-send-email-lee.jones@linaro.org>
 <CACRpkdYjjDp+7hzGtAchyy3+5Vxc8jK5THGCETkAO_V9Hj9Ssw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYjjDp+7hzGtAchyy3+5Vxc8jK5THGCETkAO_V9Hj9Ssw@mail.gmail.com>
X-Operating-System: Linux balto 3.9.0-10518-gd7ab730 x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

On Wed, May 15, 2013 at 07:18:01PM +0200, Linus Walleij wrote:
> On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > For all ux500 based platforms the maximum number of end-points are used.
> > Move this knowledge into the driver so we can relinquish the burden from
> > platform data. This also removes quite a bit of complexity from the driver
> > and will aid us when we come to enable the driver for Device Tree.
> >
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: linux-usb@vger.kernel.org
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> I guess this stuff is dependent on the stuff Fabio has recently sent to
> Felipe for the ux500 musb DMA so these musb patches should
> primarily go through his tree.

Not really, I only sent some coding style fix for the dma driver, as
almost all of my work was in the usb phy files.  I also checked my
latest series against Lee's tree and the two seems to merge without any
conflict, so as far as I'm concerned it's really up to you and Felipe.

Fabio

> It seems like the later changes to the platform code
> (arch/arm/mach-ux500) may be sufficiently orthogonal
> so it can be done out-of-order?
> 
> I can't merge any of this without Felipes ACKs in any
> case.
> 
> Yours,
> Linus Walleij
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Fabio Baltieri

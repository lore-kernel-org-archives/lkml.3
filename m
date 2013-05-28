Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934857Ab3E1QsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 12:48:13 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:58879 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934692Ab3E1QsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 12:48:09 -0400
Date: Tue, 28 May 2013 17:48:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH 20/39] usb: musb: ux500: move channel number knowledge
 into the driver
Message-ID: <20130528164803.GA3012@gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-21-git-send-email-lee.jones@linaro.org>
 <CACRpkdYjjDp+7hzGtAchyy3+5Vxc8jK5THGCETkAO_V9Hj9Ssw@mail.gmail.com>
 <20130528162715.GB28253@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130528162715.GB28253@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe

> > > For all ux500 based platforms the maximum number of end-points are used.
> > > Move this knowledge into the driver so we can relinquish the burden from
> > > platform data. This also removes quite a bit of complexity from the driver
> > > and will aid us when we come to enable the driver for Device Tree.
> > >
> > > Cc: Felipe Balbi <balbi@ti.com>
> > > Cc: linux-usb@vger.kernel.org
> > > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > > Acked-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > I guess this stuff is dependent on the stuff Fabio has recently sent to
> > Felipe for the ux500 musb DMA so these musb patches should
> > primarily go through his tree.
> > 
> > It seems like the later changes to the platform code
> > (arch/arm/mach-ux500) may be sufficiently orthogonal
> > so it can be done out-of-order?
> > 
> > I can't merge any of this without Felipes ACKs in any
> > case.
> 
> Do you want to take this yourself ? I haven't fully read the series yet,
> but seems like this depends on the rest of the series. If you want to
> take it, let me know I can ack the patches as soon as I'm done
> reviewing.

Yes that would be ideal, if you wouldn't mind.

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

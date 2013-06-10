Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab3FJJPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:15:12 -0400
Received: from mail-ea0-f171.google.com ([209.85.215.171]:37933 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab3FJJPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:15:09 -0400
Date: Mon, 10 Jun 2013 10:15:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Vinod Koul <vinod.koul@intel.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH 05/39] ARM: ux500: Stop passing MMC's platform data for
 Device Tree boots
Message-ID: <20130610091503.GF20297@gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-6-git-send-email-lee.jones@linaro.org>
 <CACRpkdbOxzhgR=ugXLrSBJ_Y1rw=0mcrvtuRi=-c5v039xsPWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbOxzhgR=ugXLrSBJ_Y1rw=0mcrvtuRi=-c5v039xsPWA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 May 2013, Linus Walleij wrote:

> On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > It was required to pass DMA channel configuration information to the
> > MMC driver before the new DMA API was in place. Now that it is, and
> > is fully compatible with Device Tree we can stop doing that.
> >
> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> So since the use of dma_request_slave_channel() is not upstream,
> I guess this will break DMA use (i.e slow down transfers!) on all
> device tree boots?
> 
> I'd be happy to apply it once the MMCI patch is in linux-next
> indicating there may just be a window in the merge period
> where it falls back to IRQ mode, but I don't want to disable
> DMA on DT boots for an entire kernel cycle just like that.
> 
> Not applied as of yet.

I believe it's now okay to apply this.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

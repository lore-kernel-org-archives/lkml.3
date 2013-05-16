Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3EPH0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:26:42 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:40846 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3EPH0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:26:40 -0400
Date: Thu, 16 May 2013 08:26:34 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Rabin Vincent <rabin@rab.in>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Per Forlin <per.forlin@stericsson.com>, Dan Williams <djbw@fb.com>
Subject: Re: [PATCH 01/39] dmaengine: ste_dma40: Separate Logical Global
 Interrupt Mask (GIM) unmasking
Message-ID: <20130516072634.GE3269@gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-2-git-send-email-lee.jones@linaro.org>
 <CACRpkdZJp-WRGNgzwqERVBtb_WxQGybmMjnnLTAoX66qECNh7g@mail.gmail.com>
 <20130516063513.GC14863@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130516063513.GC14863@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 May 2013, Vinod Koul wrote:

> On Wed, May 15, 2013 at 06:29:51PM +0200, Linus Walleij wrote:
> > On Wed, May 15, 2013 at 11:51 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > 
> > > During the initial setup of a logical channel, it is necessary to unmask
> > > the GIM in order to receive generated terminal count and error interrupts.
> > > We're separating out this required code so it will be possible to move
> > > the remaining code in d40_phy_cfg(), which is mostly runtime configuration
> > > into the runtime_config() routine.
> > >
> > > Cc: Vinod Koul <vinod.koul@intel.com>
> > > Cc: Dan Williams <djbw@fb.com>
> > > Cc: Per Forlin <per.forlin@stericsson.com>
> > > Cc: Rabin Vincent <rabin@rab.in>
> > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > Tentatively applied to my ux500-dma40 branch.
> > 
> > This lacks an ACK from Vinod...
> Acked-by: Vinod Koul <vinod.koul@intel.com>
> > 
> > I cannot get any of this stack of patches up to ARM SoC
> > before I have Vinod's ACK on all hitting drivers/dma/*
> Wip ... :)

Nice! :)

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

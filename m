Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab3FRIx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:53:27 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46856 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab3FRIxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:53:21 -0400
Date: Tue, 18 Jun 2013 10:53:16 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: ux500: set coherent_dma_mask for dma40
Message-ID: <20130618085316.GA7239@balto.lan>
References: <1371131763-6288-1-git-send-email-fabio.baltieri@linaro.org>
 <CACRpkdYOP0xTJo3sLbRz5D=b4Vb1484a1qfE3aVAKRTM4+Y7QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYOP0xTJo3sLbRz5D=b4Vb1484a1qfE3aVAKRTM4+Y7QQ@mail.gmail.com>
X-Operating-System: Linux balto 3.10.0-rc6-00001-g8177a9d x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 05:42:48PM +0200, Linus Walleij wrote:
> On Thu, Jun 13, 2013 at 3:56 PM, Fabio Baltieri
> <fabio.baltieri@linaro.org> wrote:
> 
> > Set coherent_dma_mask to DMA_BIT_MASK(32) for dma40 platform_device, as
> > without this DMA allocations were failing with the error:
> >
> > dma40 dma40.0: coherent DMA mask is unset
> >
> > when booting without device-tree.
> >
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > ---
> >
> > Hi Linus, Lee,
> >
> > I found this while removing the last hack I was keeping in my ASoC tree.
> > I originally thought that I had to set this on the driver's pdata, but
> > it turns out it's needed on the DMA controller one instead.
> >
> > When booting with device-tree enabled the mask seems to be set
> > automatically.
> >
> > Would you consider applying this with the other dma40 patches?
> 
> Those are now upstream in the ARM SoC tree, you'd have to send it
> to arm@kernel.org and ask Olof/Arnd to apply it directly to
> the next/drivers branch (I think).

Ok I can resend it but I'd like to have Lee's Ack before doing that.

Lee: have you had a chance to look at this patch?

> I have also queued it on ux500-fixes so it won't be lost.

That's nice!

Thanks,
Fabio

-- 
Fabio Baltieri

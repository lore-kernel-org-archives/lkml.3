Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab3EPHTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:19:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:36776 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302Ab3EPHTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:19:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="338151645"
Date: Thu, 16 May 2013 12:13:42 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au, arnd@arndb.de,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH 31/39] dmaengine: ste_dma40: Replace ST-E's home-brew
 DMA direction defs with generic ones
Message-ID: <20130516064342.GI14863@intel.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-32-git-send-email-lee.jones@linaro.org>
 <20130516051701.GG27639@intel.com>
 <20130516070638.GC3269@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130516070638.GC3269@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 08:06:38AM +0100, Lee Jones wrote:
> On Thu, 16 May 2013, Vinod Koul wrote:
> 
> > On Wed, May 15, 2013 at 10:51:54AM +0100, Lee Jones wrote:
> > > STEDMA40_*_TO_* direction definitions are identical in all but name to
> > > the pre-defined generic DMA_*_TO_* ones. Let's make things easy by not
> > > duplicating such things.
> > > 
> > > Cc: Vinod Koul <vinod.koul@intel.com>
> > > Cc: Dan Williams <djbw@fb.com>
> > > Cc: Per Forlin <per.forlin@stericsson.com>
> > > Cc: Rabin Vincent <rabin@rab.in>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > Nice :)
> 
> :)
> 
> > 1) I dont see the STE macro getting removed, why do we need it
> 
> They are removed later in the set, once their use has been removed
> from platform code and all the other drivers.
> 
> > 2) last i checked the direction values had a bit idfference b/w what you are
> > using and what dmaengine defines, so hopefully that is taken care of..
> 
> Yes, no problem.
> 
> <place Ack here> ;)
Acked-by: Vinod Koul <vinod.koul@intel.com>

--
~Vinod
> 
> -- 
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog

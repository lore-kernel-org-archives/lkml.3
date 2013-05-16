Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab3EPLAI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:00:08 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:48388 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3EPLAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:00:05 -0400
Date: Thu, 16 May 2013 11:59:59 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au, arnd@arndb.de,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH 02/39] dmaengine: ste_dma40: Remove unnecessary call to
 d40_phy_cfg()
Message-ID: <20130516105959.GI3269@gmail.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-3-git-send-email-lee.jones@linaro.org>
 <20130516063546.GD14863@intel.com>
 <20130516072557.GD3269@gmail.com>
 <20130516094014.GJ14863@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130516094014.GJ14863@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 May 2013, Vinod Koul wrote:

> On Thu, May 16, 2013 at 08:25:57AM +0100, Lee Jones wrote:
> > On Thu, 16 May 2013, Vinod Koul wrote:
> > 
> > > On Wed, May 15, 2013 at 10:51:25AM +0100, Lee Jones wrote:
> > > > All configuration left in d40_phy_cfg() is runtime configurable and
> > > > there is already a call into it from d40_runtime_config(), so let's
> > > > rely on that.
> > > > 
> > > > Acked-by: Vinod Koul <vnod.koul@intel.com>
> > > That needs up update!
> > 
> > Ah, where did I get that from that?
> > 
> > Was that my mistake, or was this in the MAINTAINERS file?
> Certainly not in MAINTAINERS file :)

My bad then, sorry.

Linus,

Would you be kind enough to fix it please, as it's in your tree now.
-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

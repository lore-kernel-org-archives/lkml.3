Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717Ab3EPKPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 06:15:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:38742 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab3EPKPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 06:15:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,683,1363158000"; 
   d="scan'208";a="242387031"
Date: Thu, 16 May 2013 15:10:14 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au, arnd@arndb.de,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH 02/39] dmaengine: ste_dma40: Remove unnecessary call to
 d40_phy_cfg()
Message-ID: <20130516094014.GJ14863@intel.com>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
 <1368611522-9984-3-git-send-email-lee.jones@linaro.org>
 <20130516063546.GD14863@intel.com>
 <20130516072557.GD3269@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516072557.GD3269@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 08:25:57AM +0100, Lee Jones wrote:
> On Thu, 16 May 2013, Vinod Koul wrote:
> 
> > On Wed, May 15, 2013 at 10:51:25AM +0100, Lee Jones wrote:
> > > All configuration left in d40_phy_cfg() is runtime configurable and
> > > there is already a call into it from d40_runtime_config(), so let's
> > > rely on that.
> > > 
> > > Acked-by: Vinod Koul <vnod.koul@intel.com>
> > That needs up update!
> 
> Ah, where did I get that from that?
> 
> Was that my mistake, or was this in the MAINTAINERS file?
Certainly not in MAINTAINERS file :)

--
~Vinod

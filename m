Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaBKRgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:36:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:36929 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbaBKRgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:36:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,826,1384329600"; 
   d="scan'208";a="453646758"
Date: Tue, 11 Feb 2014 23:04:18 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Paul Bolle <pebolle@tiscali.nl>, Richard Weinberger <richard@nod.at>
Cc: Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: Remove dependency on MACH_BCM2708
Message-ID: <20140211173418.GQ10628@intel.com>
References: <1391956765.25424.9.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391956765.25424.9.camel@x220>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 03:39:25PM +0100, Paul Bolle wrote:
> Commit 96286b576690 ("dmaengine: Add support for BCM2835") added an
> optional dependency on MACH_BCM2708. But there's no Kconfig symbol
> MACH_BCM2708.
> 
> (There was an entry for MACH_BCM2708 in arch/arm/tools/mach-types from
> v2.6.37 until v3.2. But it seems that entry was never used in the tree.)
> 
> This optional dependency can safely be removed.
Applied this one as this was first in my queue

-- 
~Vinod

> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
>  drivers/dma/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 9bed1a2..e4382ec 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -308,7 +308,7 @@ config DMA_OMAP
>  
>  config DMA_BCM2835
>  	tristate "BCM2835 DMA engine support"
> -	depends on (ARCH_BCM2835 || MACH_BCM2708)
> +	depends on ARCH_BCM2835
>  	select DMA_ENGINE
>  	select DMA_VIRTUAL_CHANNELS
>  
> -- 
> 1.8.5.
> 

-- 

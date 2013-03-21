Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab3CUMHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:07:22 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:37043 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab3CUMHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:07:21 -0400
Date: Thu, 21 Mar 2013 13:07:16 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] dw_dmac: fix typo in Kconfig
Message-ID: <20130321120716.GA29108@osiris>
References: <1363865935-2102-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363865935-2102-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032112-0542-0000-0000-000004B9F52E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 01:38:55PM +0200, Andy Shevchenko wrote:
> The commit c30f46bc (drivers/Kconfig: add several missing GENERIC_HARDIRQS
> dependencies) introduced a warning on make defconfig stage.  This patch fixes a
> typo.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index f641f57..23606b4 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -83,7 +83,7 @@ config INTEL_IOP_ADMA
> 
>  config DW_DMAC
>  	tristate "Synopsys DesignWare AHB DMA support"
> -	depends on GENERIQ_HARDIRQS
> +	depends on GENERIC_HARDIRQS
>  	select DMA_ENGINE
>  	default y if CPU_AT32AP7000
>  	help

Oh, sorry. Will fix this up in the original patch. Thank you!


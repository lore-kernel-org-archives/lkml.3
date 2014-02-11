Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaBKSGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:06:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:57702 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbaBKSGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:06:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,826,1384329600"; 
   d="scan'208";a="481708270"
Date: Tue, 11 Feb 2014 23:34:54 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] dma: dw: add a PCI ID for Intel Haswell SoC
Message-ID: <20140211180454.GT10628@intel.com>
References: <1391686015-7719-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391686015-7719-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 01:26:55PM +0200, Andy Shevchenko wrote:
> In case of PCI mode the DMA controller has a specific ID. Put this ID to the
> list of supported.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied, thanks

-- 
~Vinod

> ---
>  drivers/dma/dw/pci.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/dma/dw/pci.c b/drivers/dma/dw/pci.c
> index e89fc24..755cc6b 100644
> --- a/drivers/dma/dw/pci.c
> +++ b/drivers/dma/dw/pci.c
> @@ -83,6 +83,9 @@ static DEFINE_PCI_DEVICE_TABLE(dw_pci_id_table) = {
>  	/* BayTrail */
>  	{ PCI_VDEVICE(INTEL, 0x0f06), (kernel_ulong_t)&dw_pci_pdata },
>  	{ PCI_VDEVICE(INTEL, 0x0f40), (kernel_ulong_t)&dw_pci_pdata },
> +
> +	/* Haswell */
> +	{ PCI_VDEVICE(INTEL, 0x9c60), (kernel_ulong_t)&dw_pci_pdata },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(pci, dw_pci_id_table);
> -- 
> 1.9.rc1
> 

-- 

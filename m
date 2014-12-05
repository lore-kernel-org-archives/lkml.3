Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaLER7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 12:59:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:36723 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbaLER7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 12:59:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,523,1413270000"; 
   d="scan'208";a="643116703"
Date: Fri, 5 Dec 2014 23:28:56 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Michele Curti <michele.curti@gmail.com>
Cc: dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/dma/pch_dma: declare pch_dma_id_table as static
Message-ID: <20141205175856.GW3411@intel.com>
References: <20141202170756.GA30256@powerline.azcom-win.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141202170756.GA30256@powerline.azcom-win.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 06:07:56PM +0100, Michele Curti wrote:
> pch_dma_id_table is used in pch_dma.c only, so declare
> it as static
Applied, thanks

-- 
~Vinod

> 
> Signed-off-by: Michele Curti <michele.curti@gmail.com>
> ---
>  drivers/dma/pch_dma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/pch_dma.c b/drivers/dma/pch_dma.c
> index 9f9ca9f..6e0e47d 100644
> --- a/drivers/dma/pch_dma.c
> +++ b/drivers/dma/pch_dma.c
> @@ -997,7 +997,7 @@ static void pch_dma_remove(struct pci_dev *pdev)
>  #define PCI_DEVICE_ID_ML7831_DMA1_8CH	0x8810
>  #define PCI_DEVICE_ID_ML7831_DMA2_4CH	0x8815
>  
> -const struct pci_device_id pch_dma_id_table[] = {
> +static const struct pci_device_id pch_dma_id_table[] = {
>  	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_8CH), 8 },
>  	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_EG20T_PCH_DMA_4CH), 4 },
>  	{ PCI_VDEVICE(ROHM, PCI_DEVICE_ID_ML7213_DMA1_8CH), 8}, /* UART Video */
> -- 
> 2.1.3
> 

-- 

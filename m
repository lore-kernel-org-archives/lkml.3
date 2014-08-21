Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbaHULWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:22:51 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:38687 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbaHULWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:22:50 -0400
Date: Thu, 21 Aug 2014 12:22:39 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Peter Tyser <ptyser@xes-inc.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH v2] mfd: lpc_ich: Add PCI ID for Intel Braswell
Message-ID: <20140821112239.GY4266@lee--X1>
References: <1408614385-15333-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408614385-15333-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2014, Mika Westerberg wrote:

> From: Alan Cox <alan@linux.intel.com>
> 
> This is the same as used in Baytrail so add the new PCI ID to the driver's
> list of supported IDs.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
> Changed the PCI ID to be in lower case letters.
> 
>  drivers/mfd/lpc_ich.c | 6 ++++++
>  1 file changed, 6 insertions(+)

Applied, thanks.

> diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
> index 7d8482ff5868..8b8114e19c39 100644
> --- a/drivers/mfd/lpc_ich.c
> +++ b/drivers/mfd/lpc_ich.c
> @@ -216,6 +216,7 @@ enum lpc_chipsets {
>  	LPC_BAYTRAIL,   /* Bay Trail SoC */
>  	LPC_COLETO,	/* Coleto Creek */
>  	LPC_WPT_LP,	/* Wildcat Point-LP */
> +	LPC_BRASWELL,	/* Braswell SoC */
>  };
>  
>  static struct lpc_ich_info lpc_chipset_info[] = {
> @@ -519,6 +520,10 @@ static struct lpc_ich_info lpc_chipset_info[] = {
>  		.name = "Wildcat Point_LP",
>  		.iTCO_version = 2,
>  	},
> +	[LPC_BRASWELL] = {
> +		.name = "Braswell SoC",
> +		.iTCO_version = 3,
> +	},
>  };
>  
>  /*
> @@ -745,6 +750,7 @@ static const struct pci_device_id lpc_ich_ids[] = {
>  	{ PCI_VDEVICE(INTEL, 0x9cc6), LPC_WPT_LP},
>  	{ PCI_VDEVICE(INTEL, 0x9cc7), LPC_WPT_LP},
>  	{ PCI_VDEVICE(INTEL, 0x9cc9), LPC_WPT_LP},
> +	{ PCI_VDEVICE(INTEL, 0x229c), LPC_BRASWELL},
>  	{ 0, },			/* End of list */
>  };
>  MODULE_DEVICE_TABLE(pci, lpc_ich_ids);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

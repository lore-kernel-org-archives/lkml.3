Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936274AbaH1HXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 03:23:13 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:42994 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523AbaH1HXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 03:23:12 -0400
Date: Thu, 28 Aug 2014 08:23:06 +0100
From: Lee Jones <lee.jones@linaro.org>
To: James Ralston <james.d.ralston@intel.com>
Cc: Peter Tyser <ptyser@xes-inc.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] lpc_ich: Add Device IDs for Intel 9 Series PCH
Message-ID: <20140828072306.GG24579@lee--X1>
References: <1409175265-4838-1-git-send-email-james.d.ralston@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409175265-4838-1-git-send-email-james.d.ralston@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, James Ralston wrote:

> This patch adds the LPC Device IDs for the Intel 9 Series PCH.
> 
> Signed-off-by: James Ralston <james.d.ralston@intel.com>
> ---
>  drivers/mfd/lpc_ich.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Applied, thanks.

> diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
> index 7d8482f..cb41f4f 100644
> --- a/drivers/mfd/lpc_ich.c
> +++ b/drivers/mfd/lpc_ich.c
> @@ -54,6 +54,7 @@
>   *	document number TBD : Avoton SoC
>   *	document number TBD : Coleto Creek
>   *	document number TBD : Wildcat Point-LP
> + *	document number TBD : 9 Series
>   */
>  
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> @@ -216,6 +217,7 @@ enum lpc_chipsets {
>  	LPC_BAYTRAIL,   /* Bay Trail SoC */
>  	LPC_COLETO,	/* Coleto Creek */
>  	LPC_WPT_LP,	/* Wildcat Point-LP */
> +	LPC_9S,		/* 9 Series */
>  };
>  
>  static struct lpc_ich_info lpc_chipset_info[] = {
> @@ -519,6 +521,10 @@ static struct lpc_ich_info lpc_chipset_info[] = {
>  		.name = "Wildcat Point_LP",
>  		.iTCO_version = 2,
>  	},
> +	[LPC_9S] = {
> +		.name = "9 Series",
> +		.iTCO_version = 2,
> +	},
>  };
>  
>  /*
> @@ -745,6 +751,11 @@ static const struct pci_device_id lpc_ich_ids[] = {
>  	{ PCI_VDEVICE(INTEL, 0x9cc6), LPC_WPT_LP},
>  	{ PCI_VDEVICE(INTEL, 0x9cc7), LPC_WPT_LP},
>  	{ PCI_VDEVICE(INTEL, 0x9cc9), LPC_WPT_LP},
> +	{ PCI_VDEVICE(INTEL, 0x8cc1), LPC_9S},
> +	{ PCI_VDEVICE(INTEL, 0x8cc2), LPC_9S},
> +	{ PCI_VDEVICE(INTEL, 0x8cc3), LPC_9S},
> +	{ PCI_VDEVICE(INTEL, 0x8cc4), LPC_9S},
> +	{ PCI_VDEVICE(INTEL, 0x8cc6), LPC_9S},
>  	{ 0, },			/* End of list */
>  };
>  MODULE_DEVICE_TABLE(pci, lpc_ich_ids);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

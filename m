Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbaDPQfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 12:35:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57123 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaDPQfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 12:35:46 -0400
Message-ID: <534EB160.4040707@infradead.org>
Date: Wed, 16 Apr 2014 09:35:44 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Prabhakar Kushwaha <prabhakar@freescale.com>, linux-kernel@vger.kernel.org
CC: scottwood@freescale.com
Subject: Re: [PATCH] driver/memory:Add Kconfig help description for IFC
References: <1397627228-5976-1-git-send-email-prabhakar@freescale.com>
In-Reply-To: <1397627228-5976-1-git-send-email-prabhakar@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 10:47 PM, Prabhakar Kushwaha wrote:
> Freescale's Integrated Flash controller(IFC) module is used to handle
> devices such as NOR, NAND, FPGA and ASIC.
> 
> Update same in Help section of Kconfig for IFC.
> 
> Signed-off-by: Prabhakar Kushwaha <prabhakar@freescale.com>
> ---
>  drivers/memory/Kconfig |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
> index c59e9c9..9a59581 100644
> --- a/drivers/memory/Kconfig
> +++ b/drivers/memory/Kconfig
> @@ -64,5 +64,9 @@ config TEGRA30_MC
>  config FSL_IFC
>  	bool
>  	depends on FSL_SOC
> +	help
> +	  This driver is for the Integrated Flash Controller(IFC) module
> +	  available in Freescale SoCs. This controller allows to handle

	                               This controller handles

> +	  devices such as NOR, NAND, FPGA and ASIC etc.

	                             FPGA, ASIC, etc.

>  
>  endif
> 


-- 
~Randy

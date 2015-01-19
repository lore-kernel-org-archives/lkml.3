Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbbASLm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 06:42:27 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36896 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbbASLm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 06:42:26 -0500
Date: Mon, 19 Jan 2015 11:42:19 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Ong Boon Leong <boon.leong.ong@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: lpc_sch: enable WDT for Intel Quark X1000
Message-ID: <20150119114219.GQ21886@x1>
References: <1421223621-22385-1-git-send-email-boon.leong.ong@intel.com>
 <1421223621-22385-2-git-send-email-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421223621-22385-2-git-send-email-boon.leong.ong@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015, Ong Boon Leong wrote:

> Quark X1000 uses ie6xx_wdt driver for WDT. To enable WDT, we declare WDT IO
> resource size for Quark X1000.
> 
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
> ---
>  drivers/mfd/lpc_sch.c |    1
>  1 file changed, 1 insertion(+)

Applied, thanks.

> diff --git a/drivers/mfd/lpc_sch.c b/drivers/mfd/lpc_sch.c
> index 5c38df3..a56e4ba 100644
> --- a/drivers/mfd/lpc_sch.c
> +++ b/drivers/mfd/lpc_sch.c
> @@ -75,6 +75,7 @@ static struct lpc_sch_info sch_chipset_info[] = {
>  	[LPC_QUARK_X1000] = {
>  		.io_size_gpio = GPIO_IO_SIZE,
>  		.irq_gpio = GPIO_IRQ_QUARK_X1000,
> +		.io_size_wdt = WDT_IO_SIZE,
>  	},
>  };
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

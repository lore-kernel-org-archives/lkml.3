Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbaG1Gy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:54:26 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:32878 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaG1GyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:54:22 -0400
Date: Mon, 28 Jul 2014 07:54:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@samsung.com>
Cc: linux-kernel@vger.kernel.org, spk.linux@gmail.com,
        Cory Maccarrone <darkstar6262@gmail.com>
Subject: Re: [PATCH 1/2 Resend] mfd: htc-i2cpld: Remove unused code
Message-ID: <20140728065416.GB5273@lee--X1>
References: <1405684817-20171-1-git-send-email-sachin.kamat@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405684817-20171-1-git-send-email-sachin.kamat@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2014, Sachin Kamat wrote:

> Removed code unused in this function.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
> Cc: Cory Maccarrone <darkstar6262@gmail.com>
> ---
> Compile tested.
> ---
>  drivers/mfd/htc-i2cpld.c |    5 -----
>  1 file changed, 5 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/htc-i2cpld.c b/drivers/mfd/htc-i2cpld.c
> index d7b2a75aca3e..b44f0203983b 100644
> --- a/drivers/mfd/htc-i2cpld.c
> +++ b/drivers/mfd/htc-i2cpld.c
> @@ -332,18 +332,13 @@ static int htcpld_setup_chip_irq(
>  		int chip_index)
>  {
>  	struct htcpld_data *htcpld;
> -	struct device *dev = &pdev->dev;
> -	struct htcpld_core_platform_data *pdata;
>  	struct htcpld_chip *chip;
> -	struct htcpld_chip_platform_data *plat_chip_data;
>  	unsigned int irq, irq_end;
>  	int ret = 0;
>  
>  	/* Get the platform and driver data */
> -	pdata = dev_get_platdata(dev);
>  	htcpld = platform_get_drvdata(pdev);
>  	chip = &htcpld->chip[chip_index];
> -	plat_chip_data = &pdata->chip[chip_index];
>  
>  	/* Setup irq handlers */
>  	irq_end = chip->irq_start + chip->nirqs;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab3KFMnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 07:43:20 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:46315 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437Ab3KFMnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 07:43:18 -0500
Date: Wed, 6 Nov 2013 12:43:11 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, mturquette@linaro.org, dwmw2@infradead.org,
        anton@enomsg.org, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        rob.herring@calxeda.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 1/5] mfd: as3722: add clock driver as mfd-sub device
Message-ID: <20131106124311.GJ30901@lee--X1>
References: <1383740303-10956-1-git-send-email-ldewangan@nvidia.com>
 <1383740303-10956-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1383740303-10956-2-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Nov 2013, Laxman Dewangan wrote:

> Device ams AS3722 supports the one 32KHz clock output. The clock
> control support is provided through clock driver.
> 
> Add clock driver as mfd sub device to probe the clock driver.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> - Move the DT doc change to separate change.
> 
>  drivers/mfd/as3722.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mfd/as3722.c b/drivers/mfd/as3722.c
> index f161f2e..1d3415c 100644
> --- a/drivers/mfd/as3722.c
> +++ b/drivers/mfd/as3722.c
> @@ -72,6 +72,9 @@ static struct mfd_cell as3722_devs[] = {
>  		.resources = as3722_adc_resource,
>  	},
>  	{
> +		.name = "as3722-clk",
> +	},
> +	{
>  		.name = "as3722-power-off",
>  	},
>  };

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaKRIWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 03:22:18 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:52636 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbaKRIWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 03:22:14 -0500
Date: Tue, 18 Nov 2014 08:22:07 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: broonie@kernel.org, mturquette@linaro.org, a.zummo@towertech.it,
        lgirdwood@gmail.com, sbkim73@samsung.com, sameo@linux.intel.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/5] mfd: sec-core: Add support for S2MPS13 device
Message-ID: <20141118082207.GU24004@x1>
References: <1416184980-532-1-git-send-email-cw00.choi@samsung.com>
 <1416184980-532-2-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416184980-532-2-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014, Chanwoo Choi wrote:

> This patch adds the support for Samsung S2MPS13 PMIC device to the sec-core MFD
> driver. The S2MPS13 is very similar with existing S2MPS14 and includes PMIC/
> RTC/CLOCK devices.
> 
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/mfd/sec-core.c           | 18 ++++++++++++++++++
>  drivers/mfd/sec-irq.c            | 23 +++++++++++++++++------
>  include/linux/mfd/samsung/core.h |  1 +
>  3 files changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> index 5993608..48c0d4a 100644
> --- a/drivers/mfd/sec-core.c
> +++ b/drivers/mfd/sec-core.c
> @@ -73,6 +73,17 @@ static const struct mfd_cell s2mps11_devs[] = {
>  	}
>  };
>  
> +static const struct mfd_cell s2mps13_devs[] = {
> +	{
> +		.name = "s2mps13-pmic",
> +	}, {
> +		.name = "s2mps13-rtc",
> +	}, {
> +		.name = "s2mps13-clk",
> +		.of_compatible = "samsung,s2mps13-clk",
> +	}
> +};

If you have to resubmit this for any reason, I'd like the one liners
on one single line (curly braces and all).

But for now, for my reference:

Acked-by: Lee Jones <lee.jones@linaro.org>

[...]

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

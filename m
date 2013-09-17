Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab3IQHYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 03:24:32 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:65002 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3IQHYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 03:24:31 -0400
Date: Tue, 17 Sep 2013 08:24:25 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: arizona: Update volatile registers for WM5110 DSP
Message-ID: <20130917072425.GP16984@lee--X1>
References: <1379345514-2998-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1379345514-2998-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013, Charles Keepax wrote:

Any chance of a little more information in the commit message?

What are scratch registers and why are they required now where they
weren't before? Why are the control and clocking regulators no longer
needed?

> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5110-tables.c |   18 ++++++++++++++++--
>  1 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
> index 2a79723..92c6ea6 100644
> --- a/drivers/mfd/wm5110-tables.c
> +++ b/drivers/mfd/wm5110-tables.c
> @@ -2334,20 +2334,34 @@ static bool wm5110_volatile_register(struct device *dev, unsigned int reg)
>  	case ARIZONA_AOD_IRQ2:
>  	case ARIZONA_ASRC_STATUS:
>  	case ARIZONA_DSP_STATUS:
> -	case ARIZONA_DSP1_CONTROL_1:
> -	case ARIZONA_DSP1_CLOCKING_1:
>  	case ARIZONA_DSP1_STATUS_1:
>  	case ARIZONA_DSP1_STATUS_2:
>  	case ARIZONA_DSP1_STATUS_3:
> +	case ARIZONA_DSP1_SCRATCH_0:
> +	case ARIZONA_DSP1_SCRATCH_1:
> +	case ARIZONA_DSP1_SCRATCH_2:
> +	case ARIZONA_DSP1_SCRATCH_3:
>  	case ARIZONA_DSP2_STATUS_1:
>  	case ARIZONA_DSP2_STATUS_2:
>  	case ARIZONA_DSP2_STATUS_3:
> +	case ARIZONA_DSP2_SCRATCH_0:
> +	case ARIZONA_DSP2_SCRATCH_1:
> +	case ARIZONA_DSP2_SCRATCH_2:
> +	case ARIZONA_DSP2_SCRATCH_3:
>  	case ARIZONA_DSP3_STATUS_1:
>  	case ARIZONA_DSP3_STATUS_2:
>  	case ARIZONA_DSP3_STATUS_3:
> +	case ARIZONA_DSP3_SCRATCH_0:
> +	case ARIZONA_DSP3_SCRATCH_1:
> +	case ARIZONA_DSP3_SCRATCH_2:
> +	case ARIZONA_DSP3_SCRATCH_3:
>  	case ARIZONA_DSP4_STATUS_1:
>  	case ARIZONA_DSP4_STATUS_2:
>  	case ARIZONA_DSP4_STATUS_3:
> +	case ARIZONA_DSP4_SCRATCH_0:
> +	case ARIZONA_DSP4_SCRATCH_1:
> +	case ARIZONA_DSP4_SCRATCH_2:
> +	case ARIZONA_DSP4_SCRATCH_3:
>  		return true;
>  	default:
>  		return false;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

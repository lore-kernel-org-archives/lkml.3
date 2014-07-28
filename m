Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbaG1HBo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 03:01:44 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:42544 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaG1HBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 03:01:43 -0400
Date: Mon, 28 Jul 2014 08:01:38 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, broonie@kernel.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 RESEND] mfd: wm5110: Remove non-existant interrupts
Message-ID: <20140728070138.GE5273@lee--X1>
References: <1405419710-14789-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1405419710-14789-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405419710-14789-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014, Charles Keepax wrote:

> The DCS_DAC_DONE and DCS_HP_DONE interrupts do not exist on the wm5110
> version of the IP. This patch removes them from the regmap IRQ
> structure.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5110-tables.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
> index 41a7f6f..b26be6e 100644
> --- a/drivers/mfd/wm5110-tables.c
> +++ b/drivers/mfd/wm5110-tables.c
> @@ -420,12 +420,6 @@ static const struct regmap_irq wm5110_irqs[ARIZONA_NUM_IRQ] = {
>  	[ARIZONA_IRQ_BOOT_DONE] = {
>  		.reg_offset = 4, .mask = ARIZONA_BOOT_DONE_EINT1
>  	},
> -	[ARIZONA_IRQ_DCS_DAC_DONE] = {
> -		.reg_offset = 4, .mask = ARIZONA_DCS_DAC_DONE_EINT1
> -	},
> -	[ARIZONA_IRQ_DCS_HP_DONE] = {
> -		.reg_offset = 4, .mask = ARIZONA_DCS_HP_DONE_EINT1
> -	},
>  	[ARIZONA_IRQ_FLL2_CLOCK_OK] = {
>  		.reg_offset = 4, .mask = ARIZONA_FLL2_CLOCK_OK_EINT1
>  	},

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

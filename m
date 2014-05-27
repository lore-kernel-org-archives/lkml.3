Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaE0JXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:23:37 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:41361 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbaE0JXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:23:34 -0400
Date: Tue, 27 May 2014 10:23:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Keerthy <j-keerthy@ti.com>
Subject: Re: [PATCH] mfd: tps65218: Terminate of match table
Message-ID: <20140527092329.GG5875@lee--X1>
References: <1400890613-5704-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400890613-5704-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2014, Stephen Boyd wrote:

> Failure to terminate this match table can lead to boot failures
> depending on where the compiler places the match table.
> 
> Cc: Keerthy <j-keerthy@ti.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/mfd/tps65218.c | 1 +
>  1 file changed, 1 insertion(+)

Applied, thanks.

> diff --git a/drivers/mfd/tps65218.c b/drivers/mfd/tps65218.c
> index a74bfb59f18f..0d256cb002eb 100644
> --- a/drivers/mfd/tps65218.c
> +++ b/drivers/mfd/tps65218.c
> @@ -197,6 +197,7 @@ static struct regmap_irq_chip tps65218_irq_chip = {
>  
>  static const struct of_device_id of_tps65218_match_table[] = {
>  	{ .compatible = "ti,tps65218", },
> +	{}
>  };
>  
>  static int tps65218_probe(struct i2c_client *client,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

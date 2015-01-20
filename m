Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbbATL4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:56:18 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:34236 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbbATL4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:56:15 -0500
Date: Tue, 20 Jan 2015 11:56:10 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/14] mfd: hi6421-pmic: Constify struct regmap_config
Message-ID: <20150120115610.GM13701@x1>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
 <1420448493-9355-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420448493-9355-2-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2015, Krzysztof Kozlowski wrote:

> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/hi6421-pmic-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

> diff --git a/drivers/mfd/hi6421-pmic-core.c b/drivers/mfd/hi6421-pmic-core.c
> index 321a2656fd00..7210ae28bf81 100644
> --- a/drivers/mfd/hi6421-pmic-core.c
> +++ b/drivers/mfd/hi6421-pmic-core.c
> @@ -35,7 +35,7 @@ static const struct mfd_cell hi6421_devs[] = {
>  	{ .name = "hi6421-regulator", },
>  };
>  
> -static struct regmap_config hi6421_regmap_config = {
> +static const struct regmap_config hi6421_regmap_config = {
>  	.reg_bits = 32,
>  	.reg_stride = 4,
>  	.val_bits = 8,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

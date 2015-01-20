Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbbATLzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:55:06 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:52030 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbbATLy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:54:58 -0500
Date: Tue, 20 Jan 2015 11:54:53 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] mfd: 88pm860x-core: Constify struct regmap_config
Message-ID: <20150120115453.GL13701@x1>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
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
>  drivers/mfd/88pm860x-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

> diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
> index 3a2604580164..d2a85cde68da 100644
> --- a/drivers/mfd/88pm860x-core.c
> +++ b/drivers/mfd/88pm860x-core.c
> @@ -1111,7 +1111,7 @@ static int verify_addr(struct i2c_client *i2c)
>  	return 0;
>  }
>  
> -static struct regmap_config pm860x_regmap_config = {
> +static const struct regmap_config pm860x_regmap_config = {
>  	.reg_bits = 8,
>  	.val_bits = 8,
>  };

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

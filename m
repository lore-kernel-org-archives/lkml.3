Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbbATPSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:18:17 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:60602 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414AbbATPSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:18:16 -0500
Date: Tue, 20 Jan 2015 15:18:09 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 2/2] mfd: max77693: Remove unused structures
Message-ID: <20150120151809.GX13701@x1>
References: <1418981359-16457-1-git-send-email-k.kozlowski@samsung.com>
 <1418981359-16457-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1418981359-16457-3-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2014, Krzysztof Kozlowski wrote:

> The max77693 regulator driver no longer supports board files. Remove the
> left-overs. Additionally fix name of device in comment.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  include/linux/mfd/max77693.h | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)

For my own reference:

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
> index f0b6585cd874..09a4dedaeea8 100644
> --- a/include/linux/mfd/max77693.h
> +++ b/include/linux/mfd/max77693.h
> @@ -30,7 +30,7 @@
>  #ifndef __LINUX_MFD_MAX77693_H
>  #define __LINUX_MFD_MAX77693_H
>  
> -/* MAX77686 regulator IDs */
> +/* MAX77693 regulator IDs */
>  enum max77693_regulators {
>  	MAX77693_ESAFEOUT1 = 0,
>  	MAX77693_ESAFEOUT2,
> @@ -38,12 +38,6 @@ enum max77693_regulators {
>  	MAX77693_REG_MAX,
>  };
>  
> -struct max77693_regulator_data {
> -	int id;
> -	struct regulator_init_data *initdata;
> -	struct device_node *of_node;
> -};
> -
>  struct max77693_reg_data {
>  	u8 addr;
>  	u8 data;
> @@ -103,10 +97,6 @@ struct max77693_led_platform_data {
>  /* MAX77693 */
>  
>  struct max77693_platform_data {
> -	/* regulator data */
> -	struct max77693_regulator_data *regulators;
> -	int num_regulators;
> -
>  	/* muic data */
>  	struct max77693_muic_platform_data *muic_data;
>  	struct max77693_led_platform_data *led_data;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaHUQCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:02:41 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:63777 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaHUQCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:02:39 -0400
Date: Thu, 21 Aug 2014 17:02:32 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        SangYoung Son <hello.son@smasung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH/RFC v5 1/3] mfd: max77693: Fix register enum name
Message-ID: <20140821160232.GR4266@lee--X1>
References: <1408542221-375-1-git-send-email-j.anaszewski@samsung.com>
 <1408542221-375-2-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408542221-375-2-git-send-email-j.anaszewski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2014, Jacek Anaszewski wrote:
> According to the MAX77693 documentation the name of
> the register is FLASH_STATUS.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: SangYoung Son <hello.son@smasung.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  include/linux/mfd/max77693-private.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

> diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
> index c466ff3..615f121 100644
> --- a/include/linux/mfd/max77693-private.h
> +++ b/include/linux/mfd/max77693-private.h
> @@ -46,7 +46,7 @@ enum max77693_pmic_reg {
>  	MAX77693_LED_REG_VOUT_FLASH2			= 0x0C,
>  	MAX77693_LED_REG_FLASH_INT			= 0x0E,
>  	MAX77693_LED_REG_FLASH_INT_MASK			= 0x0F,
> -	MAX77693_LED_REG_FLASH_INT_STATUS		= 0x10,
> +	MAX77693_LED_REG_FLASH_STATUS			= 0x10,
>  
>  	MAX77693_PMIC_REG_PMIC_ID1			= 0x20,
>  	MAX77693_PMIC_REG_PMIC_ID2			= 0x21,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

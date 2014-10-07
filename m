Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbaJGJLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:11:02 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:45828 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbaJGJKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:10:55 -0400
Date: Tue, 7 Oct 2014 10:10:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: stmpe: fix STMPE24xx GPMR LSB
Message-ID: <20141007091049.GJ25331@lee--X1>
References: <1412431347-27230-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1412431347-27230-1-git-send-email-linus.walleij@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Oct 2014, Linus Walleij wrote:

> The least significat byte of the GPIO value read register
> on the STMPE24xx series is on addres 0xA4 not 0xA5. Correct
> against datasheet and tested on the STMPE2401 hardware.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Hi Lee, Sam: this should go in for fixes I think.
> ---
>  drivers/mfd/stmpe.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to fixes.

> diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
> index 2d045f26f193..bee0abf82040 100644
> --- a/drivers/mfd/stmpe.h
> +++ b/drivers/mfd/stmpe.h
> @@ -269,7 +269,7 @@ int stmpe_remove(struct stmpe *stmpe);
>  #define STMPE24XX_REG_CHIP_ID		0x80
>  #define STMPE24XX_REG_IEGPIOR_LSB	0x18
>  #define STMPE24XX_REG_ISGPIOR_MSB	0x19
> -#define STMPE24XX_REG_GPMR_LSB		0xA5
> +#define STMPE24XX_REG_GPMR_LSB		0xA4
>  #define STMPE24XX_REG_GPSR_LSB		0x85
>  #define STMPE24XX_REG_GPCR_LSB		0x88
>  #define STMPE24XX_REG_GPDR_LSB		0x8B

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

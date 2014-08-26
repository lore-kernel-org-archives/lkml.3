Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaHZQgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:36:19 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:57056 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaHZQgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:36:17 -0400
Date: Tue, 26 Aug 2014 17:36:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Bryan Wu'" <cooloney@gmail.com>
Subject: Re: [PATCH 05/18] backlight: corgi_lcd: add blank line after
 declarations
Message-ID: <20140826163611.GS26707@lee--X1>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
 <00af01cfc12d$72f80660$58e81320$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00af01cfc12d$72f80660$58e81320$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Jingoo Han wrote:

> Fixed the following checkpatch warning.
> 
>   WARNING: Missing a blank line after declarations
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/video/backlight/corgi_lcd.c | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
> index 51d18d637e2b..d7c37a8ccd1f 100644
> --- a/drivers/video/backlight/corgi_lcd.c
> +++ b/drivers/video/backlight/corgi_lcd.c
> @@ -143,6 +143,7 @@ static void lcdtg_i2c_send_byte(struct corgi_lcd *lcd,
>  				uint8_t base, uint8_t data)
>  {
>  	int i;
> +
>  	for (i = 0; i < 8; i++) {
>  		if (data & 0x80)
>  			lcdtg_i2c_send_bit(lcd, base | POWER0_COM_DOUT);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

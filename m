Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaHZQai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:30:38 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:42715 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbaHZQaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:30:35 -0400
Date: Tue, 26 Aug 2014 17:30:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Bryan Wu'" <cooloney@gmail.com>
Subject: Re: [PATCH 14/18] backlight: tdo24m: add blank line after
 declarations
Message-ID: <20140826163029.GH26707@lee--X1>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
 <00b801cfc12d$da62a260$8f27e720$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00b801cfc12d$da62a260$8f27e720$%han@samsung.com>
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
>  drivers/video/backlight/tdo24m.c | 2 ++
>  1 file changed, 2 insertions(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/video/backlight/tdo24m.c b/drivers/video/backlight/tdo24m.c
> index 908016fc5829..30afce33ef2a 100644
> --- a/drivers/video/backlight/tdo24m.c
> +++ b/drivers/video/backlight/tdo24m.c
> @@ -300,12 +300,14 @@ static int tdo24m_power(struct tdo24m *lcd, int power)
>  static int tdo24m_set_power(struct lcd_device *ld, int power)
>  {
>  	struct tdo24m *lcd = lcd_get_data(ld);
> +
>  	return tdo24m_power(lcd, power);
>  }
>  
>  static int tdo24m_get_power(struct lcd_device *ld)
>  {
>  	struct tdo24m *lcd = lcd_get_data(ld);
> +
>  	return lcd->power;
>  }
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

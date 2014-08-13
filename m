Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaHMNMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 09:12:41 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:35178 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbaHMNMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 09:12:39 -0400
Date: Wed, 13 Aug 2014 14:12:32 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jg1.han@samsung.com, cooloney@gmail.com, plagnioj@jcrosoft.com,
        tomi.valkeinen@ti.com, thierry.reding@gmail.com, patches@linaro.org,
        linux-fbdev@vger.kernel.org, linux-pwm@vger.kernel.org
Subject: Re: [PATCH] backlight: remove .owner field for drivers using
 module_platform_driver
Message-ID: <20140813131232.GA8258@lee--X1>
References: <1407933518-7214-1-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1407933518-7214-1-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2014, Peter Griffin wrote:

> This patch removes the superflous .owner field for drivers which
> use the module_platform_driver or platform_driver_register api,
> as this is overriden in __platform_driver_register.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  drivers/video/backlight/88pm860x_bl.c    | 1 -
>  drivers/video/backlight/aat2870_bl.c     | 1 -
>  drivers/video/backlight/adp5520_bl.c     | 1 -
>  drivers/video/backlight/as3711_bl.c      | 1 -
>  drivers/video/backlight/da903x_bl.c      | 1 -
>  drivers/video/backlight/da9052_bl.c      | 1 -
>  drivers/video/backlight/ep93xx_bl.c      | 1 -
>  drivers/video/backlight/gpio_backlight.c | 1 -
>  drivers/video/backlight/lm3533_bl.c      | 1 -
>  drivers/video/backlight/lp8788_bl.c      | 1 -
>  drivers/video/backlight/max8925_bl.c     | 1 -
>  drivers/video/backlight/ot200_bl.c       | 1 -
>  drivers/video/backlight/pandora_bl.c     | 1 -
>  drivers/video/backlight/platform_lcd.c   | 1 -
>  drivers/video/backlight/pwm_bl.c         | 1 -
>  drivers/video/backlight/tps65217_bl.c    | 1 -
>  drivers/video/backlight/wm831x_bl.c      | 1 -
>  17 files changed, 17 deletions(-)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

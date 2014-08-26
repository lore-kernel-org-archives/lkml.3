Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaHZQfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:35:52 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:41966 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaHZQfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:35:51 -0400
Date: Tue, 26 Aug 2014 17:35:45 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Bryan Wu'" <cooloney@gmail.com>
Subject: Re: [PATCH 06/18] backlight: cr_bllcd: add blank line after
 declarations
Message-ID: <20140826163545.GR26707@lee--X1>
References: <009301cfc12d$2847ffd0$78d7ff70$%han@samsung.com>
 <00b001cfc12d$7e7ddaa0$7b798fe0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <00b001cfc12d$7e7ddaa0$7b798fe0$%han@samsung.com>
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
>  drivers/video/backlight/cr_bllcd.c | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/video/backlight/cr_bllcd.c b/drivers/video/backlight/cr_bllcd.c
> index f3fed9ef745f..3e3880fc8c8e 100644
> --- a/drivers/video/backlight/cr_bllcd.c
> +++ b/drivers/video/backlight/cr_bllcd.c
> @@ -235,6 +235,7 @@ static int cr_backlight_probe(struct platform_device *pdev)
>  static int cr_backlight_remove(struct platform_device *pdev)
>  {
>  	struct cr_panel *crp = platform_get_drvdata(pdev);
> +
>  	crp->cr_backlight_device->props.power = FB_BLANK_POWERDOWN;
>  	crp->cr_backlight_device->props.brightness = 0;
>  	crp->cr_backlight_device->props.max_brightness = 0;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

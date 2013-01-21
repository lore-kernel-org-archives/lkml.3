Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab3AUTUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 14:20:49 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:37087 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279Ab3AUTUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 14:20:47 -0500
Date: Mon, 21 Jan 2013 11:17:10 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 10/24] ab8500-chargalg: Only root should have write
 permission on sysfs file
Message-ID: <20130121191710.GB15037@lizard.mcd01528.sjc.wayport.net>
References: <1358769840-4763-1-git-send-email-lee.jones@linaro.org>
 <1358769840-4763-11-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1358769840-4763-11-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 12:03:46PM +0000, Lee Jones wrote:
> Only root should have write permission on sysfs file ab8500_chargalg/chargalg.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I guess it is a candidate for -stable?

> ---
>  drivers/power/abx500_chargalg.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
> index 2463fa0..f59bc02 100644
> --- a/drivers/power/abx500_chargalg.c
> +++ b/drivers/power/abx500_chargalg.c
> @@ -1711,7 +1711,7 @@ static ssize_t abx500_chargalg_sysfs_charger(struct kobject *kobj,
>  static struct attribute abx500_chargalg_en_charger = \
>  {
>  	.name = "chargalg",
> -	.mode = S_IWUGO,
> +	.mode = S_IWUSR,
>  };
>  
>  static struct attribute *abx500_chargalg_chg[] = {
> -- 
> 1.7.9.5
> 

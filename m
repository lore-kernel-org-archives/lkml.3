Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaKOUM0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 15:12:26 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:47592 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410AbaKOUMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 15:12:24 -0500
Date: Sat, 15 Nov 2014 21:12:18 +0100
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: Christian Resell <christian.resell@gmail.com>
Cc: m.chehab@samsung.com, devel@driverdev.osuosl.org, askb23@gmail.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        yongjun_wei@trendmicro.com.cn, hans.verkuil@cisco.com, pavel@ucw.cz,
        pali.rohar@gmail.com, fengguang.wu@intel.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: media: bcm2048: fix coding style error
Message-ID: <20141115201218.GC8088@t400>
References: <20141115194337.GF15904@Kosekroken.jensen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141115194337.GF15904@Kosekroken.jensen.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15, Christian Resell wrote:
> Simple style fix (checkpatch.pl: "space prohibited before that ','").
> For the eudyptula challenge (http://eudyptula-challenge.org/).

Nice, however we do not need the information about the 'eudyptula
challenge' in the commit message.

If you want to include extra information please do it after the '---'
line (just below the signed-off). You will find more details in the
SubmittingPatches (chapter 15) of the kernel documentation.

Thanks,
Konrad
 
> Signed-off-by: Christian F. Resell <christian.resell@gmail.com>
> ---
> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> index 2bba370..bdc6854 100644
> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> @@ -2707,7 +2707,7 @@ static int __exit bcm2048_i2c_driver_remove(struct i2c_client *client)
>   *	bcm2048_i2c_driver - i2c driver interface
>   */
>  static const struct i2c_device_id bcm2048_id[] = {
> -	{ "bcm2048" , 0 },
> +	{ "bcm2048", 0 },
>  	{ },
>  };
>  MODULE_DEVICE_TABLE(i2c, bcm2048_id);
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

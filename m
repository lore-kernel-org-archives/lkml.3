Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbaEGJPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:15:19 -0400
Received: from gloria.sntech.de ([95.129.55.99]:39829 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213AbaEGJPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:15:16 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH 2/5] rtc: rtc-hym8563: Make of_device_id array const
Date: Wed, 07 May 2014 11:15:50 +0200
Message-ID: <1450231.VoSW87CxnX@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <021301cf69cf$316ff000$944fd000$%han@samsung.com>
References: <020f01cf69ce$bf617b50$3e2471f0$%han@samsung.com> <021301cf69cf$316ff000$944fd000$%han@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 7. Mai 2014, 17:34:42 schrieb Jingoo Han:
> Make of_device_id array const, because all OF functions
> handle it as const.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Heiko Stuebner <heiko@sntech.de>

> ---
>  drivers/rtc/rtc-hym8563.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/rtc/rtc-hym8563.c b/drivers/rtc/rtc-hym8563.c
> index bd628a6..5620c24 100644
> --- a/drivers/rtc/rtc-hym8563.c
> +++ b/drivers/rtc/rtc-hym8563.c
> @@ -582,7 +582,7 @@ static const struct i2c_device_id hym8563_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, hym8563_id);
> 
> -static struct of_device_id hym8563_dt_idtable[] = {
> +static const struct of_device_id hym8563_dt_idtable[] = {
>  	{ .compatible = "haoyu,hym8563" },
>  	{},
>  };


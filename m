Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaFFHdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:33:00 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:42410 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbaFFHc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:32:58 -0400
MIME-Version: 1.0
In-Reply-To: <002101cf7f24$40f3e670$c2dbb350$%han@samsung.com>
References: <002101cf7f24$40f3e670$c2dbb350$%han@samsung.com>
Date: Fri, 6 Jun 2014 15:32:56 +0800
Message-ID: <CAD6h2NQJynOn6TngA+vT3jfO9miXWDe1d+kCpkaXsoiebKTJ6g@mail.gmail.com>
Subject: Re: [PATCH 1/2] rtc: rtc-sa1100: Make of_device_id array const
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 June 2014 20:06, Jingoo Han <jg1.han@samsung.com> wrote:
> Make of_device_id array const, because all OF functions handle
> it as const.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/rtc/rtc-sa1100.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
> index 0f7adeb..b6e1ca0 100644
> --- a/drivers/rtc/rtc-sa1100.c
> +++ b/drivers/rtc/rtc-sa1100.c
> @@ -338,7 +338,7 @@ static SIMPLE_DEV_PM_OPS(sa1100_rtc_pm_ops, sa1100_rtc_suspend,
>                         sa1100_rtc_resume);
>
>  #ifdef CONFIG_OF
> -static struct of_device_id sa1100_rtc_dt_ids[] = {
> +static const struct of_device_id sa1100_rtc_dt_ids[] = {
>         { .compatible = "mrvl,sa1100-rtc", },
>         { .compatible = "mrvl,mmp-rtc", },
>         {}
> --
> 1.7.10.4
>
>

Acked-by: Haojian Zhuang <haojian.zhuang@linaro.org>

Regards
Haojian

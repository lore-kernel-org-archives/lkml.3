Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325Ab3HMVBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:01:14 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:50644 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759161Ab3HMVBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:01:12 -0400
MIME-Version: 1.0
In-Reply-To: <1375948794-6286-11-git-send-email-milo.kim@ti.com>
References: <1375948794-6286-1-git-send-email-milo.kim@ti.com> <1375948794-6286-11-git-send-email-milo.kim@ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 13 Aug 2013 14:00:49 -0700
Message-ID: <CAK5ve-JGPW9-AsF+=ix6Yvt10W5SbP9ctuFfN+UFdDZTmVQ5UA@mail.gmail.com>
Subject: Re: [PATCH 10/10] leds: lp5562: use LP55xx common macros for device attributes
To: Milo Kim <woogyom.kim@gmail.com>
Cc: =?ISO-8859-1?Q?Pali_Roh=E1r?= <pali.rohar@gmail.com>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Milo Kim <milo.kim@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 12:59 AM, Milo Kim <woogyom.kim@gmail.com> wrote:
>

Good for merge.

-Bryan

> Signed-off-by: Milo Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lp5562.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/leds/leds-lp5562.c b/drivers/leds/leds-lp5562.c
> index a2c7398..2585cfd 100644
> --- a/drivers/leds/leds-lp5562.c
> +++ b/drivers/leds/leds-lp5562.c
> @@ -477,8 +477,8 @@ static ssize_t lp5562_store_engine_mux(struct device *dev,
>         return len;
>  }
>
> -static DEVICE_ATTR(led_pattern, S_IWUSR, NULL, lp5562_store_pattern);
> -static DEVICE_ATTR(engine_mux, S_IWUSR, NULL, lp5562_store_engine_mux);
> +static LP55XX_DEV_ATTR_WO(led_pattern, lp5562_store_pattern);
> +static LP55XX_DEV_ATTR_WO(engine_mux, lp5562_store_engine_mux);
>
>  static struct attribute *lp5562_attributes[] = {
>         &dev_attr_led_pattern.attr,
> --
> 1.7.9.5
>

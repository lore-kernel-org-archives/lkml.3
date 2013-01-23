Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab3AWRxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:53:31 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:38659 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab3AWRx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:53:29 -0500
MIME-Version: 1.0
In-Reply-To: <1358930104-6681-1-git-send-email-peter.ujfalusi@ti.com>
References: <1358930104-6681-1-git-send-email-peter.ujfalusi@ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 23 Jan 2013 09:53:07 -0800
Message-ID: <CAK5ve-KWUQ6Tba-SAD4nc_+L=QWiLa8hB5N-czJY3Ls8cJKOEg@mail.gmail.com>
Subject: Re: [PATCH] leds: leds-pwm: make it depend on PWM and not HAVE_PWM
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 12:35 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:
> The correct dependency for the leds-pwm is PWM and not HAVE_PWM
> since PWM drivers now have their own subsystem.
>

Thanks, merged.

-Bryan

> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>  drivers/leds/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
> index 4469b44..c32d934 100644
> --- a/drivers/leds/Kconfig
> +++ b/drivers/leds/Kconfig
> @@ -310,7 +310,7 @@ config LEDS_DAC124S085
>  config LEDS_PWM
>         tristate "PWM driven LED Support"
>         depends on LEDS_CLASS
> -       depends on HAVE_PWM
> +       depends on PWM
>         help
>           This option enables support for pwm driven LEDs
>
> --
> 1.8.1.1
>

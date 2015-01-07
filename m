Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbbAGSk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:40:59 -0500
Received: from mail-yk0-f174.google.com ([209.85.160.174]:64205 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbbAGSk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:40:58 -0500
MIME-Version: 1.0
In-Reply-To: <1420394427-19509-1-git-send-email-me@mortis.eu>
References: <1420394427-19509-1-git-send-email-me@mortis.eu>
Date: Wed, 7 Jan 2015 20:40:57 +0200
Message-ID: <CAHp75Vetc+fgv=YrqPuW9YChez82h7N7VeX_5bW5tpXm2j=h7g@mail.gmail.com>
Subject: Re: [PATCH 1/2] Align member-assigns in a structure-copy block
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Giel van Schijndel <me@mortis.eu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, Eliad Peller <eliad@wizery.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Arik Nemtsov <arik@wizery.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 4, 2015 at 8:00 PM, Giel van Schijndel <me@mortis.eu> wrote:
> This highlights the differences (errors).

Seems like patch for the patch. Just fix an error like it's done here:
http://www.spinics.net/lists/linux-wireless/msg131667.html


> ---
>  drivers/net/wireless/ti/wlcore/acx.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
> index b924cea..beb354c 100644
> --- a/drivers/net/wireless/ti/wlcore/acx.c
> +++ b/drivers/net/wireless/ti/wlcore/acx.c
> @@ -1715,17 +1715,17 @@ int wl12xx_acx_config_hangover(struct wl1271 *wl)
>                 goto out;
>         }
>
> -       acx->recover_time = cpu_to_le32(conf->recover_time);
> -       acx->hangover_period = conf->hangover_period;
> -       acx->dynamic_mode = conf->dynamic_mode;
> -       acx->early_termination_mode = conf->early_termination_mode;
> -       acx->max_period = conf->max_period;
> -       acx->min_period = conf->min_period;
> -       acx->increase_delta = conf->increase_delta;
> -       acx->decrease_delta = conf->decrease_delta;
> -       acx->quiet_time = conf->quiet_time;
> -       acx->increase_time = conf->increase_time;
> -       acx->window_size = acx->window_size;
> +       acx->recover_time               = cpu_to_le32(conf->recover_time);
> +       acx->hangover_period            = conf->hangover_period;
> +       acx->dynamic_mode               = conf->dynamic_mode;
> +       acx->early_termination_mode     = conf->early_termination_mode;
> +       acx->max_period                 = conf->max_period;
> +       acx->min_period                 = conf->min_period;
> +       acx->increase_delta             = conf->increase_delta;
> +       acx->decrease_delta             = conf->decrease_delta;
> +       acx->quiet_time                 = conf->quiet_time;
> +       acx->increase_time              = conf->increase_time;
> +       acx->window_size                = acx->window_size;
>
>         ret = wl1271_cmd_configure(wl, ACX_CONFIG_HANGOVER, acx,
>                                    sizeof(*acx));
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With Best Regards,
Andy Shevchenko

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbbAIRDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:03:53 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:60290 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbbAIRDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:03:51 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Giel van Schijndel <me@mortis.eu>
Cc: linux-kernel@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Arik Nemtsov <arik@wizery.com>,
        linux-wireless@vger.kernel.org (open list:TI WILINK WIRELES...),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: Re: [PATCH RESEND 2/2] wlcore: align member-assigns in a structure-copy block
References: <1420394427-19509-1-git-send-email-me@mortis.eu>
	<1420659525-22975-1-git-send-email-me@mortis.eu>
	<1420659525-22975-2-git-send-email-me@mortis.eu>
Date: Fri, 09 Jan 2015 19:03:45 +0200
In-Reply-To: <1420659525-22975-2-git-send-email-me@mortis.eu> (Giel van
	Schijndel's message of "Wed, 7 Jan 2015 20:38:38 +0100")
Message-ID: <87vbkfga32.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giel van Schijndel <me@mortis.eu> writes:

> This highlights the differences (e.g. the bug fixed in the previous
> commit).
>
> Signed-off-by: Giel van Schijndel <me@mortis.eu>
> ---
>  drivers/net/wireless/ti/wlcore/acx.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/ti/wlcore/acx.c b/drivers/net/wireless/ti/wlcore/acx.c
> index f28fa3b..93a2fa8 100644
> --- a/drivers/net/wireless/ti/wlcore/acx.c
> +++ b/drivers/net/wireless/ti/wlcore/acx.c
> @@ -1715,17 +1715,17 @@ int wl12xx_acx_config_hangover(struct wl1271 *wl)
>  		goto out;
>  	}
>  
> -	acx->recover_time = cpu_to_le32(conf->recover_time);
> -	acx->hangover_period = conf->hangover_period;
> -	acx->dynamic_mode = conf->dynamic_mode;
> -	acx->early_termination_mode = conf->early_termination_mode;
> -	acx->max_period = conf->max_period;
> -	acx->min_period = conf->min_period;
> -	acx->increase_delta = conf->increase_delta;
> -	acx->decrease_delta = conf->decrease_delta;
> -	acx->quiet_time = conf->quiet_time;
> -	acx->increase_time = conf->increase_time;
> -	acx->window_size = conf->window_size;
> +	acx->recover_time               = cpu_to_le32(conf->recover_time);
> +	acx->hangover_period            = conf->hangover_period;
> +	acx->dynamic_mode               = conf->dynamic_mode;
> +	acx->early_termination_mode     = conf->early_termination_mode;
> +	acx->max_period                 = conf->max_period;
> +	acx->min_period                 = conf->min_period;
> +	acx->increase_delta             = conf->increase_delta;
> +	acx->decrease_delta             = conf->decrease_delta;
> +	acx->quiet_time                 = conf->quiet_time;
> +	acx->increase_time              = conf->increase_time;
> +	acx->window_size                = conf->window_size;

I would like to get an ACK from one of the wlcore developers if I should
apply this (or not).

-- 
Kalle Valo

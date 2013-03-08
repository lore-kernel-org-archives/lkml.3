Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257Ab3CHPRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 10:17:38 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35779 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256Ab3CHPRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 10:17:35 -0500
Message-ID: <513A0109.9060801@linaro.org>
Date: Fri, 08 Mar 2013 16:17:29 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: john.stultz@linaro.org, tglx@linutronix.de, linus.walleij@stericsson.com
CC: viresh.kumar@linaro.org, jacob.jun.pan@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        rickard.andersson@stericsson.com, vincent.guittot@linaro.org
Subject: [PATCH 3/4][V2] ARM: nomadik: add dynamic irq flag to the timer
References: <1362219013-18173-1-git-send-email-daniel.lezcano@linaro.org>
In-Reply-To: <1362219013-18173-1-git-send-email-daniel.lezcano@linaro.org>
Content-Type: multipart/mixed;
 boundary="------------000300080406010204060003"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000300080406010204060003
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

> Add the dynamic irq affinity feature to the timer clock device.
> 
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
> Acked-by: Rickard Andersson <rickard.andersson@stericsson.com>
> ---

Hi Linus,

AFAIU, you are ok with this patch, Rickard acked it and Vincent reviewed it.

Thomas agreed to merge it into its tree as I requested because we will
need to wait for your tree to gain visibility to this new flag before
submitting this patch, which can take awhile.

Could you please ack it if it is ok for you ?

Thanks
  -- Daniel

> 
> 
>  drivers/clocksource/nomadik-mtu.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clocksource/nomadik-mtu.c b/drivers/clocksource/nomadik-mtu.c
> index 7cbcaa0..73dc540 100644
> --- a/drivers/clocksource/nomadik-mtu.c
> +++ b/drivers/clocksource/nomadik-mtu.c
> @@ -136,7 +136,8 @@ static void nmdk_clkevt_mode(enum clock_event_mode mode,
>   static struct clock_event_device nmdk_clkevt = {
>  	.name		= "mtu_1",
> -	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC,
> +	.features	= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_PERIODIC |
> +	                  CLOCK_EVT_FEAT_DYNIRQ,
>  	.rating		= 200,
>  	.set_mode	= nmdk_clkevt_mode,
>  	.set_next_event	= nmdk_clkevt_next,
> -- 
> 1.7.9.5


--------------000300080406010204060003
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Attached Message Part"


--------------000300080406010204060003--

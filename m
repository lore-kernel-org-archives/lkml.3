Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965214Ab3BMXNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 18:13:44 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:34945 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752043Ab3BMXNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 18:13:43 -0500
Date: Thu, 14 Feb 2013 00:13:32 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, fabio.porcedda@gmail.com, JM.Lin@atmel.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/8] watchdog/at91sam9_wdt: Remove the __initdata of at91wdt_wdd
Message-ID: <20130213231332.GG7867@spo001.leaseweb.com>
References: <1359702386-21284-1-git-send-email-wenyou.yang@atmel.com> <1359702386-21284-7-git-send-email-wenyou.yang@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359702386-21284-7-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wenyou,

> For this variable will be used in the timer handler.
> 
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> Cc: wim@iguana.be
> Cc: linux-watchdog@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/watchdog/at91sam9_wdt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
> index e60a718..3fc90ba 100644
> --- a/drivers/watchdog/at91sam9_wdt.c
> +++ b/drivers/watchdog/at91sam9_wdt.c
> @@ -199,7 +199,7 @@ static struct watchdog_ops at91wdt_ops = {
>  	.ping = at91wdt_ping,
>  };
>  
> -static struct watchdog_device at91wdt_wdd __initdata = {
> +static struct watchdog_device at91wdt_wdd = {
>  	.timeout = WDT_HEARTBEAT,
>  	.min_timeout = MIN_HEARTBEAT,
>  	.max_timeout = MAX_HEARTBEAT,

should imho also have been part of your previous patches.
Anyway, it's also like this in the patch I just sent you.

Kind regards,
Wim.


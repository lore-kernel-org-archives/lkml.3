Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761212Ab3BMXLM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 18:11:12 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:34934 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751859Ab3BMXLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 18:11:10 -0500
Date: Thu, 14 Feb 2013 00:11:02 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, fabio.porcedda@gmail.com, JM.Lin@atmel.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 5/8] watchdog/at91sam9_wdt: Add nowayout helpers to Watchdog Timer Driver Kernel API
Message-ID: <20130213231102.GF7867@spo001.leaseweb.com>
References: <1359702386-21284-1-git-send-email-wenyou.yang@atmel.com> <1359702386-21284-6-git-send-email-wenyou.yang@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359702386-21284-6-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wenyou

> diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
> index c6d9f1f..e60a718 100644
> --- a/drivers/watchdog/at91sam9_wdt.c
> +++ b/drivers/watchdog/at91sam9_wdt.c
> @@ -238,6 +238,8 @@ static int __init at91wdt_probe(struct platform_device *pdev)
>  		return ret;
>  	}
>  
> +	watchdog_set_nowayout(&at91wdt_wdd, nowayout);
> +
>  	watchdog_init_timeout(&at91wdt_wdd, heartbeat, pdev->dev.of_node);
>  
>  	ret = at91wdt_enable(&at91wdt_wdd, ms_to_ticks(WDT_HW_TIMEOUT * 1000));

allready part of the patch I just sent you.

Kind regards,
Wim.


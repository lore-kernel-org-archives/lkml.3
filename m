Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab3IRW1A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 18:27:00 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:21861 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab3IRW0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 18:26:48 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19m23JFj2XK0lbcmc7L8yri
Date: Wed, 18 Sep 2013 15:26:43 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RX-51: Add missing max_current to
 rx51_lp5523_led_config
Message-ID: <20130918222642.GK9994@atomide.com>
References: <1379541145-25934-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1379541145-25934-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130918 15:02]:
> Without max_current data in board file lp5523 driver does not change current.

Hmm is this a regression or are there other reasons to merge
this during the -rc cycle?

Regards,

Tony
 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  arch/arm/mach-omap2/board-rx51-peripherals.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
> index 9326890..d0f857c 100644
> --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> @@ -180,38 +180,47 @@ static struct lp55xx_led_config rx51_lp5523_led_config[] = {
>  		.name		= "lp5523:kb1",
>  		.chan_nr	= 0,
>  		.led_current	= 50,
> +		.max_current	= 255,
>  	}, {
>  		.name		= "lp5523:kb2",
>  		.chan_nr	= 1,
>  		.led_current	= 50,
> +		.max_current	= 255,
>  	}, {
>  		.name		= "lp5523:kb3",
>  		.chan_nr	= 2,
>  		.led_current	= 50,
> +		.max_current	= 255,
>  	}, {
>  		.name		= "lp5523:kb4",
>  		.chan_nr	= 3,
>  		.led_current	= 50,
> +		.max_current	= 255,
>  	}, {
>  		.name		= "lp5523:b",
>  		.chan_nr	= 4,
>  		.led_current	= 50,
> +		.max_current	= 255,
>  	}, {
>  		.name		= "lp5523:g",
>  		.chan_nr	= 5,
>  		.led_current	= 50,
> +		.max_current	= 255,
>  	}, {
>  		.name		= "lp5523:r",
>  		.chan_nr	= 6,
>  		.led_current	= 50,
> +		.max_current	= 255,
>  	}, {
>  		.name		= "lp5523:kb5",
>  		.chan_nr	= 7,
>  		.led_current	= 50,
> +		.max_current	= 255,
>  	}, {
>  		.name		= "lp5523:kb6",
>  		.chan_nr	= 8,
>  		.led_current	= 50,
> +		.max_current	= 255,
>  	}
>  };
>  
> -- 
> 1.7.10.4
> 

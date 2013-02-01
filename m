Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab3BASqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 13:46:21 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:47228 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757313Ab3BASqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 13:46:16 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18/Se8Zz54PUcF5dvW2Ow1A
Date: Fri, 1 Feb 2013 10:46:11 -0800
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RX-51: Add leds lp5523 names from Maemo 5 2.6.28 kernel
Message-ID: <20130201184610.GO22517@atomide.com>
References: <1358650244-29722-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1358650244-29722-1-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130119 18:54]:
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
>  arch/arm/mach-omap2/board-rx51-peripherals.c |    9 +++++++++
>  1 file changed, 9 insertions(+)

Thanks applying into omap-for-v3.9/board with the subject
also pasted to the description.

Tony
 
> diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
> index 7611958..9a0dbb7 100644
> --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> @@ -168,30 +168,39 @@ static struct tsl2563_platform_data rx51_tsl2563_platform_data = {
>  #if defined(CONFIG_LEDS_LP5523) || defined(CONFIG_LEDS_LP5523_MODULE)
>  static struct lp5523_led_config rx51_lp5523_led_config[] = {
>  	{
> +		.name		= "lp5523:kb1",
>  		.chan_nr	= 0,
>  		.led_current	= 50,
>  	}, {
> +		.name		= "lp5523:kb2",
>  		.chan_nr	= 1,
>  		.led_current	= 50,
>  	}, {
> +		.name		= "lp5523:kb3",
>  		.chan_nr	= 2,
>  		.led_current	= 50,
>  	}, {
> +		.name		= "lp5523:kb4",
>  		.chan_nr	= 3,
>  		.led_current	= 50,
>  	}, {
> +		.name		= "lp5523:b",
>  		.chan_nr	= 4,
>  		.led_current	= 50,
>  	}, {
> +		.name		= "lp5523:g",
>  		.chan_nr	= 5,
>  		.led_current	= 50,
>  	}, {
> +		.name		= "lp5523:r",
>  		.chan_nr	= 6,
>  		.led_current	= 50,
>  	}, {
> +		.name		= "lp5523:kb5",
>  		.chan_nr	= 7,
>  		.led_current	= 50,
>  	}, {
> +		.name		= "lp5523:kb6",
>  		.chan_nr	= 8,
>  		.led_current	= 50,
>  	}
> -- 
> 1.7.10.4
> 

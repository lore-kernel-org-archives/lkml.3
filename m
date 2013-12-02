Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab3LBQE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:04:59 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:46534 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab3LBQE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:04:56 -0500
Date: Mon, 2 Dec 2013 08:04:54 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Wim Van Sebroeck <wim@iguana.be>, scottwood@freescale.com,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] watchdog: mpc8xxx_wdt: MPC8xx is HW enabled
Message-ID: <20131202160453.GA32723@roeck-us.net>
References: <20131130154540.E83D743E15@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131130154540.E83D743E15@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 04:45:40PM +0100, Christophe Leroy wrote:
> MPC8xx watchdog is enabled at startup by HW.
> If the bootloader disables it, it cannot be reenabled.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> diff -ur a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
> --- a/drivers/watchdog/mpc8xxx_wdt.c	2013-05-11 22:57:46.000000000 +0200
> +++ b/drivers/watchdog/mpc8xxx_wdt.c	2013-08-08 02:12:15.000000000 +0200
> @@ -273,6 +310,7 @@
>  		.compatible = "fsl,mpc823-wdt",
>  		.data = &(struct mpc8xxx_wdt_type) {
>  			.prescaler = 0x800,
> +			.hw_enabled = true,
>  		},
>  	},
>  	{},
> 
> ---
> Ce courrier électronique ne contient aucun virus ou logiciel malveillant parce que la protection avast! Antivirus est active.
> http://www.avast.com
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

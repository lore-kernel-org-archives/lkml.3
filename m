Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab3A3V4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 16:56:18 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:33221 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757040Ab3A3V4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:56:16 -0500
Date: Wed, 30 Jan 2013 22:56:15 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] orion_wdt: Add platform alias
Message-ID: <20130130215615.GA21145@spo001.leaseweb.com>
References: <1357308388-19566-1-git-send-email-lkundrak@v3.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357308388-19566-1-git-send-email-lkundrak@v3.sk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lubomir,

> ...so that it's automatically picked up on relevant platforms.
> Tested on Kirkwood-based GuruPlug.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> ---
>  drivers/watchdog/orion_wdt.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/watchdog/orion_wdt.c b/drivers/watchdog/orion_wdt.c
> index c20f96b..c9dd66f 100644
> --- a/drivers/watchdog/orion_wdt.c
> +++ b/drivers/watchdog/orion_wdt.c
> @@ -223,4 +223,5 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
>  				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
>  
>  MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:orion_wdt");
>  MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> -- 
> 1.7.1
> 

Added to linux-watchdog-next.

Kind regards,
Wim.


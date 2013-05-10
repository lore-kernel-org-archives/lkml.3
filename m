Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab3EJTsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 15:48:53 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:35433 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab3EJTsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 15:48:52 -0400
Date: Fri, 10 May 2013 11:59:13 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Rupesh Kumar <rupesh.kumar@stericsson.com>,
        Michel JAOUEN <michel.jaouen@stericsson.com>,
        Loic Pallardy <loic.pallardy@stericsson.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power_supply: pm2301_charger: Fix module alias prefix
Message-ID: <20130510185912.GB3486@teo>
References: <1367664669.25532.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1367664669.25532.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 04, 2013 at 06:51:09PM +0800, Axel Lin wrote:
> This driver is a i2c driver, use "i2c" rather than "platform" prefix for module
> alias.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---

Applied, thanks Axel!

Anton

>  drivers/power/pm2301_charger.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
> index a441751..fef56e2 100644
> --- a/drivers/power/pm2301_charger.c
> +++ b/drivers/power/pm2301_charger.c
> @@ -1269,5 +1269,5 @@ module_exit(pm2xxx_charger_exit);
>  
>  MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Rajkumar kasirajan, Olivier Launay");
> -MODULE_ALIAS("platform:pm2xxx-charger");
> +MODULE_ALIAS("i2c:pm2xxx-charger");
>  MODULE_DESCRIPTION("PM2xxx charger management driver");
> -- 
> 1.8.1.2

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab3IBJPG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:15:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50157 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322Ab3IBJPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 05:15:02 -0400
Date: Mon, 2 Sep 2013 11:14:57 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: gregkh@linuxfoundation.org, p.zabel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] imx-drm: imx-ldb: Staticize of_get_data_mapping()
Message-ID: <20130902091457.GW30088@pengutronix.de>
References: <1378084315-18154-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378084315-18154-1-git-send-email-festevam@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:14:43 up 8 days, 18:45, 37 users,  load average: 0.02, 0.06, 0.11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 01, 2013 at 10:11:55PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Staticize of_get_data_mapping() in order to fix the following sparse warning:
> 
> drivers/staging/imx-drm/imx-ldb.c:424:11: warning: symbol 'of_get_data_mapping' was not declared. Should it be static?
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>


Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> ---
>  drivers/staging/imx-drm/imx-ldb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/imx-drm/imx-ldb.c b/drivers/staging/imx-drm/imx-ldb.c
> index af733ea..b81ed41 100644
> --- a/drivers/staging/imx-drm/imx-ldb.c
> +++ b/drivers/staging/imx-drm/imx-ldb.c
> @@ -421,7 +421,7 @@ static const char *imx_ldb_bit_mappings[] = {
>  	[LVDS_BIT_MAP_JEIDA] = "jeida",
>  };
>  
> -const int of_get_data_mapping(struct device_node *np)
> +static const int of_get_data_mapping(struct device_node *np)
>  {
>  	const char *bm;
>  	int ret, i;
> -- 
> 1.8.1.2
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

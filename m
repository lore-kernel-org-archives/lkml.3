Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191Ab3BSPsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 10:48:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:13810 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756827Ab3BSPsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 10:48:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,696,1355126400"; 
   d="scan'208";a="289098096"
Message-ID: <1361288888.2323.30.camel@rzhang1-mobl4>
Subject: Re: [PATCH 9/9] thermal: rcar: remove __devinitconst
From: Zhang Rui <rui.zhang@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Date: Tue, 19 Feb 2013 23:48:08 +0800
In-Reply-To: <1360880818-4071454-10-git-send-email-arnd@arndb.de>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de>
	 <1360880818-4071454-10-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 23:26 +0100, Arnd Bergmann wrote:
> commit 76cc18874 "thermal: rcar: add Device Tree support"
> added device tree support for this driver, but also added
> an instance of __devinitconst, which is no longer defined
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> Cc: Zhang Rui <rui.zhang@intel.com>

applied to thermal -next tree.

thanks,
rui
> ---
>  drivers/thermal/rcar_thermal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/rcar_thermal.c b/drivers/thermal/rcar_thermal.c
> index 909bb4b..28f0919 100644
> --- a/drivers/thermal/rcar_thermal.c
> +++ b/drivers/thermal/rcar_thermal.c
> @@ -476,7 +476,7 @@ static int rcar_thermal_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> -static const struct of_device_id rcar_thermal_dt_ids[] __devinitconst = {
> +static const struct of_device_id rcar_thermal_dt_ids[] = {
>  	{ .compatible = "renesas,rcar-thermal", },
>  	{},
>  };



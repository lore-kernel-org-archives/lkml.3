Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaAFOte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 09:49:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:60375 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaAFOtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 09:49:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,613,1384329600"; 
   d="scan'208";a="434515943"
Message-ID: <1389019761.5853.18.camel@rzhang1-mobl4>
Subject: Re: [PATCH 1/1] thermal: remove const flag from .ops of imx thermal
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Date: Mon, 06 Jan 2014 22:49:21 +0800
In-Reply-To: <1389012874-13871-1-git-send-email-eduardo.valentin@ti.com>
References: <1389012874-13871-1-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 08:54 -0400, Eduardo Valentin wrote:
> As per previous changes on thermal framework API,
> registering a new thermal zone does not require
> a const thermal zone ops.
> 
> Thus, this patch removes the flag from imx thermal zone ops.
> 
> Cc: Zhang Rui <rui.zhang@intel.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

applied.

thanks,
rui
> ---
>  drivers/thermal/imx_thermal.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
> index 77a962f..43d2f77 100644
> --- a/drivers/thermal/imx_thermal.c
> +++ b/drivers/thermal/imx_thermal.c
> @@ -284,7 +284,7 @@ static int imx_unbind(struct thermal_zone_device *tz,
>  	return 0;
>  }
>  
> -static const struct thermal_zone_device_ops imx_tz_ops = {
> +static struct thermal_zone_device_ops imx_tz_ops = {
>  	.bind = imx_bind,
>  	.unbind = imx_unbind,
>  	.get_temp = imx_get_temp,



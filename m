Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaLVDCM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 22:02:12 -0500
Received: from mga14.intel.com ([192.55.52.115]:32712 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928AbaLVDCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 22:02:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,620,1413270000"; 
   d="scan'208";a="627499529"
Message-ID: <1419217315.22607.15.camel@rzhang1-toshiba>
Subject: Re: [PATCH 18/28] thermal: drop owner assignment from
 platform_drivers
From: Zhang Rui <rui.zhang@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Heiko Stuebner <heiko@sntech.de>,
        Eduardo Valentin <edubezval@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org
Date: Mon, 22 Dec 2014 11:01:55 +0800
In-Reply-To: <1419196495-9626-19-git-send-email-wsa@the-dreams.de>
References: <1419196495-9626-1-git-send-email-wsa@the-dreams.de>
	 <1419196495-9626-19-git-send-email-wsa@the-dreams.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-21 at 22:14 +0100, Wolfram Sang wrote:
> This platform_driver does not need to set an owner, it will be populated by the
> driver core.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

both PATCH 18/28 and 19/28 look good to me. applied.

thanks,
rui
> ---
> Generated with coccinelle. SmPL file is in the introductory msg. The big
> cleanup was pulled in this merge window. This series catches the bits fallen
> through. The patches shall go in via the subsystem trees.
> 
>  drivers/thermal/rockchip_thermal.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/thermal/rockchip_thermal.c b/drivers/thermal/rockchip_thermal.c
> index 1bcddfc60e91..9c6ce548e363 100644
> --- a/drivers/thermal/rockchip_thermal.c
> +++ b/drivers/thermal/rockchip_thermal.c
> @@ -677,7 +677,6 @@ static SIMPLE_DEV_PM_OPS(rockchip_thermal_pm_ops,
>  static struct platform_driver rockchip_thermal_driver = {
>  	.driver = {
>  		.name = "rockchip-thermal",
> -		.owner = THIS_MODULE,
>  		.pm = &rockchip_thermal_pm_ops,
>  		.of_match_table = of_rockchip_thermal_match,
>  	},



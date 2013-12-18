Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab3LRSkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:40:19 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34412 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab3LRSkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:40:17 -0500
Date: Wed, 18 Dec 2013 10:40:14 -0800
From: josh@joshtriplett.org
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>, linux-pm@vger.kernel.org
Subject: Re: [PATCH] drivers: thermal: Mark function as static in
 x86_pkg_temp_thermal.c
Message-ID: <20131218184014.GD24229@cloud>
References: <20131218174602.GA27918@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131218174602.GA27918@rashika>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 11:16:02PM +0530, Rashika Kheria wrote:
> Mark function sys_set_trip_temp() as static in x86_pkg_temp_thermal.c
> because it is not used outside this file.
> 
> This eliminates the following warning in x86_pkg_temp_thermal.c:
> drivers/thermal/x86_pkg_temp_thermal.c:218:5: warning: no previous prototype for ‘sys_set_trip_temp’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/thermal/x86_pkg_temp_thermal.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/thermal/x86_pkg_temp_thermal.c b/drivers/thermal/x86_pkg_temp_thermal.c
> index 7722cb9..972e1c7 100644
> --- a/drivers/thermal/x86_pkg_temp_thermal.c
> +++ b/drivers/thermal/x86_pkg_temp_thermal.c
> @@ -215,7 +215,7 @@ static int sys_get_trip_temp(struct thermal_zone_device *tzd,
>  	return 0;
>  }
>  
> -int sys_set_trip_temp(struct thermal_zone_device *tzd, int trip,
> +static int sys_set_trip_temp(struct thermal_zone_device *tzd, int trip,
>  							unsigned long temp)
>  {
>  	u32 l, h;
> -- 
> 1.7.9.5
> 

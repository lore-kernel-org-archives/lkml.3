Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3KUEJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 23:09:42 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:45452 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab3KUEJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 23:09:41 -0500
Date: Thu, 21 Nov 2013 13:09:38 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 02/05] ARM: shmobile: Add r8a7790 clocks for thermal
 devices
Message-ID: <20131121040936.GK31130@verge.net.au>
References: <20131120075921.23557.23231.sendpatchset@w520>
 <20131120075939.23557.49793.sendpatchset@w520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120075939.23557.49793.sendpatchset@w520>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 04:59:39PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Add the r8a7790 DT thermal device to the legacy clocks.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  arch/arm/mach-shmobile/clock-r8a7790.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- 0001/arch/arm/mach-shmobile/clock-r8a7790.c
> +++ work/arch/arm/mach-shmobile/clock-r8a7790.c	2013-11-20 08:22:32.000000000 +0900
> @@ -286,6 +286,7 @@ static struct clk_lookup lookups[] = {
>  	CLKDEV_DEV_ID("e6530000.i2c", &mstp_clks[MSTP929]),
>  	CLKDEV_DEV_ID("e6540000.i2c", &mstp_clks[MSTP928]),
>  	CLKDEV_DEV_ID("r8a7790-ether", &mstp_clks[MSTP813]),
> +	CLKDEV_DEV_ID("e61f0000.thermal", &mstp_clks[MSTP522]),
>  	CLKDEV_DEV_ID("rcar_thermal", &mstp_clks[MSTP522]),
>  	CLKDEV_DEV_ID("ee200000.mmc", &mstp_clks[MSTP315]),
>  	CLKDEV_DEV_ID("sh_mmcif.0", &mstp_clks[MSTP315]),
> 


Thanks. There was a small amount of fuzz when I applied this
patch to the soc3 branch. The result is below, please check it.

Assuming all goes will I plan to push this and other updates
today or tomorrow.

From: Magnus Damm <damm@opensource.se>

[PATCH] ARM: shmobile: Add r8a7790 clocks for thermal devices

Add the r8a7790 DT thermal device to the legacy clocks.

Signed-off-by: Magnus Damm <damm@opensource.se>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
 arch/arm/mach-shmobile/clock-r8a7790.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-shmobile/clock-r8a7790.c b/arch/arm/mach-shmobile/clock-r8a7790.c
index 5269640..33e80b10 100644
--- a/arch/arm/mach-shmobile/clock-r8a7790.c
+++ b/arch/arm/mach-shmobile/clock-r8a7790.c
@@ -286,6 +286,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("e6530000.i2c", &mstp_clks[MSTP929]),
 	CLKDEV_DEV_ID("e6540000.i2c", &mstp_clks[MSTP928]),
 	CLKDEV_DEV_ID("r8a7790-ether", &mstp_clks[MSTP813]),
+	CLKDEV_DEV_ID("e61f0000.thermal", &mstp_clks[MSTP522]),
 	CLKDEV_DEV_ID("rcar_thermal", &mstp_clks[MSTP522]),
 	CLKDEV_DEV_ID("ee200000.mmcif", &mstp_clks[MSTP315]),
 	CLKDEV_DEV_ID("sh_mmcif.0", &mstp_clks[MSTP315]),
-- 
1.8.4



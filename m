Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbaIOWm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:42:27 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43668 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbaIOWmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:42:23 -0400
Date: Mon, 15 Sep 2014 23:42:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andreas Werner <andreas.werner@men.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Adds Andreas Werner to maintainers list for
 MEN F21BMC
Message-ID: <20140915224219.GE25162@lee--X1>
References: <cover.1409161615.git.andreas.werner@men.de>
 <20140915073625.GA515@awelinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140915073625.GA515@awelinux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2014, Andreas Werner wrote:

> Added maintainer for the following MEN F21BMC drivers:
> 	- menf21bmc (MFD)
> 	- menf21bmc_wdt (Watchdog)
> 	- menf21bmc_hwmon (HWMON)
> 	- leds-menf21bmc (LED)
> 
> Signed-off-by: Andreas Werner <andreas.werner@men.de>
> ---
>  MAINTAINERS | 9 +++++++++
>  1 file changed, 9 insertions(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 65cc66d..c4a188c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5938,6 +5938,15 @@ S:	Supported
>  F:	drivers/mcb/
>  F:	include/linux/mcb.h
>  
> +MEN F21BMC (Board Management Controller)
> +M:	Andreas Werner <andreas.werner@men.de>
> +S:	Supported
> +F:	drivers/mfd/menf21bmc.c
> +F:	drivers/watchdog/menf21bmc_wdt.c
> +F:	drivers/leds/leds-menf21bmc.c
> +F:	drivers/hwmon/menf21bmc_hwmon.c
> +F:	Documentation/hwmon/menf21bmc
> +
>  METAG ARCHITECTURE
>  M:	James Hogan <james.hogan@imgtec.com>
>  L:	linux-metag@vger.kernel.org

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

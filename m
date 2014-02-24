Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbaBXTw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:52:27 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:59320 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753099AbaBXTwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:52:24 -0500
Date: Mon, 24 Feb 2014 20:52:23 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 40/73] watchdog: delete non-required instances of include <linux/init.h>
Message-ID: <20140224195223.GB20712@spo001.leaseweb.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com> <1390339396-3479-41-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390339396-3479-41-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> None of these files are actually using any __init type directives
> and hence don't need to include <linux/init.h>.  Most are just a
> left over from __devinit and __cpuinit removal, or simply due to
> code getting copied from one driver to the next.
> 
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: linux-watchdog@vger.kernel.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  drivers/watchdog/ar7_wdt.c          | 1 -
>  drivers/watchdog/ath79_wdt.c        | 1 -
>  drivers/watchdog/bcm47xx_wdt.c      | 1 -
>  drivers/watchdog/bcm63xx_wdt.c      | 1 -
>  drivers/watchdog/cpu5wdt.c          | 1 -
>  drivers/watchdog/cpwd.c             | 1 -
>  drivers/watchdog/davinci_wdt.c      | 1 -
>  drivers/watchdog/hpwdt.c            | 1 -
>  drivers/watchdog/i6300esb.c         | 1 -
>  drivers/watchdog/jz4740_wdt.c       | 1 -
>  drivers/watchdog/max63xx_wdt.c      | 1 -
>  drivers/watchdog/mtx-1_wdt.c        | 1 -
>  drivers/watchdog/nuc900_wdt.c       | 1 -
>  drivers/watchdog/of_xilinx_wdt.c    | 1 -
>  drivers/watchdog/omap_wdt.c         | 1 -
>  drivers/watchdog/orion_wdt.c        | 1 -
>  drivers/watchdog/pnx4008_wdt.c      | 1 -
>  drivers/watchdog/rdc321x_wdt.c      | 1 -
>  drivers/watchdog/retu_wdt.c         | 1 -
>  drivers/watchdog/riowd.c            | 1 -
>  drivers/watchdog/s3c2410_wdt.c      | 1 -
>  drivers/watchdog/sp805_wdt.c        | 1 -
>  drivers/watchdog/stmp3xxx_rtc_wdt.c | 1 -
>  drivers/watchdog/wdt_pci.c          | 1 -
>  24 files changed, 24 deletions(-)

This patch has been added to linux-watchdog-next.

Kind regards,
Wim.


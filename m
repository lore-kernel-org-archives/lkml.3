Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab3J2Hh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 03:37:27 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:39295 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751803Ab3J2HhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 03:37:25 -0400
Date: Tue, 29 Oct 2013 08:37:23 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        "'Guenter Roeck'" <linux@roeck-us.net>
Subject: Re: [PATCH V2 03/35] watchdog: use dev_get_platdata()
Message-ID: <20131029073723.GC19569@spo001.leaseweb.com>
References: <008001ce8d13$c6805fc0$53811f40$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008001ce8d13$c6805fc0$53811f40$@samsung.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

> Use the wrapper function for retrieving the platform data instead of
> accessing dev->platform_data directly.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/watchdog/iTCO_wdt.c         |    2 +-
>  drivers/watchdog/mv64x60_wdt.c      |    2 +-
>  drivers/watchdog/omap_wdt.c         |    2 +-
>  drivers/watchdog/rdc321x_wdt.c      |    2 +-
>  drivers/watchdog/stmp3xxx_rtc_wdt.c |    4 ++--
>  drivers/watchdog/ux500_wdt.c        |    2 +-
>  drivers/watchdog/wm831x_wdt.c       |    8 +++-----
>  7 files changed, 10 insertions(+), 12 deletions(-)

This patch has been added to linux-watchdog-next.

Kind regards,
Wim.


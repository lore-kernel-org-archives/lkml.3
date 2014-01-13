Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaAMVKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 16:10:25 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:52258 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751437AbaAMVKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 16:10:19 -0500
Date: Mon, 13 Jan 2014 22:10:16 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Markus Mayer <markus.mayer@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Christian Daudt <bcm@fixthebug.org>,
        Linaro Patches <patches@linaro.org>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] watchdog: bcm281xx: Debugfs support
Message-ID: <20140113211016.GA23635@spo001.leaseweb.com>
References: <1389045371-1631-1-git-send-email-markus.mayer@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389045371-1631-1-git-send-email-markus.mayer@linaro.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Markus,

> This series adds debugfs support to the bcm281xx watchdog driver. Most
> of the code submitted here was already included as part of v5 of the
> original driver submission. See
> http://www.spinics.net/lists/linux-watchdog/msg03328.html
> 
> This series is dependent on commit
> bd90ccd42c5d6317979c62919ba1c79fd34fa785 in linux-watchdog-next.
> 
> Changes since v1 of this series:
> 
> - http://www.spinics.net/lists/linux-watchdog/msg03544.html has been
>   included here
> 
> - bcm_kona_wdt_debug_init() and bcm_kona_wdt_debugfs_init() as well as
>   bcm_kona_wdt_debug_exit() and bcm_kona_debugfs_exit() were merged
>   together, so now there are just two instead of four functions 
> 
> Markus Mayer (2):
>   watchdog: bcm281xx: Debugfs support
>   watchdog: bcm281xx: Turn on debugfs support for watchdog driver
> 
>  arch/arm/configs/bcm_defconfig  |    1 +
>  drivers/watchdog/Kconfig        |   10 ++++
>  drivers/watchdog/bcm_kona_wdt.c |  108 +++++++++++++++++++++++++++++++++++++--
>  3 files changed, 115 insertions(+), 4 deletions(-)

This patch was added to linux-watchdog-next.

Kind regards,
Wim.


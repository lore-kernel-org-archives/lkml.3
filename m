Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaEZV0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:26:49 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:56577 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751534AbaEZV0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:26:47 -0400
Date: Mon, 26 May 2014 23:26:46 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] watchdog: Remove drivers for W83697HF and W83697UG
Message-ID: <20140526212646.GB23827@spo001.leaseweb.com>
References: <1396722457-8275-1-git-send-email-linux@roeck-us.net> <1396722457-8275-2-git-send-email-linux@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396722457-8275-2-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> Since both chips are now supported by the w83627hf watchdog driver,
> the chip specific drivers are no longer needed and can be removed.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v3: rebase to latest upstream kernel
> v2: resend, no change to v1
> 
>  drivers/watchdog/Kconfig        |   30 ---
>  drivers/watchdog/Makefile       |    2 -
>  drivers/watchdog/w83697hf_wdt.c |  460 ---------------------------------------
>  drivers/watchdog/w83697ug_wdt.c |  397 ---------------------------------
>  4 files changed, 889 deletions(-)
>  delete mode 100644 drivers/watchdog/w83697hf_wdt.c
>  delete mode 100644 drivers/watchdog/w83697ug_wdt.c
> 

Has been added to linux-watchdog-next.

Kind regards,
Wim.


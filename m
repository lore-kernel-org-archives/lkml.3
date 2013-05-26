Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab3EZNNa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 09:13:30 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:48014 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751939Ab3EZNN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 09:13:29 -0400
Date: Sun, 26 May 2013 15:13:28 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        "'Guenter Roeck'" <linux@roeck-us.net>
Subject: Re: [PATCH 5/5] watchdog: wm831x: use platform_{get,set}_drvdata()
Message-ID: <20130526131328.GA6387@spo001.leaseweb.com>
References: <003801ce57a2$8f0dae40$ad290ac0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003801ce57a2$8f0dae40$ad290ac0$@samsung.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

> Use the wrapper functions for getting and setting the driver data using
> platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
> so we can directly pass a struct platform_device.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/watchdog/wm831x_wdt.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Patch added to linux-watchdog-next.

Kind regards,
Wim.


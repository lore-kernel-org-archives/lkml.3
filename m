Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab3EZNgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 09:36:13 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:48029 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750923Ab3EZNgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 09:36:12 -0400
Date: Sun, 26 May 2013 15:36:10 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        "'Guenter Roeck'" <linux@roeck-us.net>
Subject: Re: [PATCH 2/5] watchdog: da9052: use platform_{get,set}_drvdata()
Message-ID: <20130526133610.GA6957@spo001.leaseweb.com>
References: <003501ce57a2$749344d0$5db9ce70$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003501ce57a2$749344d0$5db9ce70$@samsung.com>
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
>  drivers/watchdog/da9052_wdt.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Patch added to linux-watchdog-next.

Kind regards,
Wim.


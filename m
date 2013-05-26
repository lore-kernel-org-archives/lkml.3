Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3EZNgo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 09:36:44 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:48034 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751188Ab3EZNgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 09:36:43 -0400
Date: Sun, 26 May 2013 15:36:41 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        "'Guenter Roeck'" <linux@roeck-us.net>
Subject: Re: [PATCH 3/5] watchdog: da9055: use platform_{get,set}_drvdata()
Message-ID: <20130526133641.GB6957@spo001.leaseweb.com>
References: <003601ce57a2$7d2617d0$77724770$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <003601ce57a2$7d2617d0$77724770$@samsung.com>
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
>  drivers/watchdog/da9055_wdt.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Patch added to linux-watchdog-next.

Kind regards,
Wim.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab3EYTGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 15:06:46 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:47888 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757624Ab3EYTGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 15:06:44 -0400
Date: Sat, 25 May 2013 21:06:42 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        "'Guenter Roeck'" <linux@roeck-us.net>
Subject: Re: [PATCH V2 2/7] watchdog: bcm63xx_wdt: use devm_ioremap_nocache()
Message-ID: <20130525190642.GA12581@spo001.leaseweb.com>
References: <000f01ce455f$a55a20c0$f00e6240$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000f01ce455f$a55a20c0$f00e6240$@samsung.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

> Use devm_ioremap_nocache() to make cleanup paths simpler.
> 
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> No changes since v1:
> 
>  drivers/watchdog/bcm63xx_wdt.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)

Patch added to linux-watchdog-next.

Kind regards,
Wim.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757862Ab3EYTY0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 15:24:26 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:47900 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757769Ab3EYTYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 15:24:24 -0400
Date: Sat, 25 May 2013 21:24:19 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        "'Guenter Roeck'" <linux@roeck-us.net>
Subject: Re: [PATCH V2 5/7] watchdog: rc32434_wdt: use devm_ioremap_nocache() functions
Message-ID: <20130525192419.GA12860@spo001.leaseweb.com>
References: <001201ce455f$cdb6ec10$6924c430$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001201ce455f$cdb6ec10$6924c430$@samsung.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

> Use devm_ioremap_nocache() functions to make cleanup paths simpler.
> 
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> No changes since v1:
> 
>  drivers/watchdog/rc32434_wdt.c |   10 +++-------
>  1 files changed, 3 insertions(+), 7 deletions(-)
> 

Patch added to linux-watchdog-next.

Kind regards,
Wim.


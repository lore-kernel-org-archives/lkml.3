Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab3EYTKu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 15:10:50 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:47892 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757707Ab3EYTKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 15:10:47 -0400
Date: Sat, 25 May 2013 21:10:45 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        "'Guenter Roeck'" <linux@roeck-us.net>
Subject: Re: [PATCH V2 3/7] watchdog: mv64x60_wdt: use devm_ioremap()
Message-ID: <20130525191045.GA12656@spo001.leaseweb.com>
References: <001001ce455f$aefd0430$0cf70c90$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001001ce455f$aefd0430$0cf70c90$@samsung.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

> Use devm_ioremap() to make cleanup paths simpler.
> 
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> No changes since v1:
> 
>  drivers/watchdog/mv64x60_wdt.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 

Patch added to linux-watchdog-next.

Kind regards,
Wim.


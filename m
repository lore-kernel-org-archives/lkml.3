Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857Ab3EYTTb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 15:19:31 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:47896 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757769Ab3EYTT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 15:19:29 -0400
Date: Sat, 25 May 2013 21:19:28 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        "'Guenter Roeck'" <linux@roeck-us.net>
Subject: Re: [PATCH V2 4/7] watchdog: nuc900_wdt: use devm_*() functions
Message-ID: <20130525191928.GA12790@spo001.leaseweb.com>
References: <001101ce455f$c441cf60$4cc56e20$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001101ce455f$c441cf60$4cc56e20$@samsung.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

> Use devm_*() functions to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> Changes since v1:
> - used sizeof(*nuc900_wdt) instead of sizeof(struct nuc900_wdt)
> - declared 'nuc900_wdt->res' variable as logical variable
> 
>  drivers/watchdog/nuc900_wdt.c |   50 +++++++++--------------------------------
>  1 files changed, 11 insertions(+), 39 deletions(-)
> 

Patch added to linux-watchdog-next.

Kind regards,
Wim.


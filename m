Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab3EYTrI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 15:47:08 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:47914 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757750Ab3EYTrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 15:47:07 -0400
Date: Sat, 25 May 2013 21:47:05 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        "'Guenter Roeck'" <linux@roeck-us.net>
Subject: Re: [PATCH V3 7/7] watchdog: ts72xx_wdt: use devm_*() functions
Message-ID: <20130525194705.GA13129@spo001.leaseweb.com>
References: <000a01ce46f9$334257f0$99c707d0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000a01ce46f9$334257f0$99c707d0$@samsung.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

> Use devm_*() functions to make cleanup paths simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> Changes since v2:
> - removed unnecessary platform_set_drvdata(pdev, NULL)
> 
>  drivers/watchdog/ts72xx_wdt.c |   67 ++++++----------------------------------
>  1 files changed, 10 insertions(+), 57 deletions(-)
> 

Patch added to linux-watchdog-next.

Kind regards,
Wim.


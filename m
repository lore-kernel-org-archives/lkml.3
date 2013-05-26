Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab3EZNON (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 09:14:13 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:48018 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752859Ab3EZNOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 09:14:12 -0400
Date: Sun, 26 May 2013 15:14:10 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH RESEND 2/2] watchdog: wm831x_wdt: use devm_gpio_request_one()
Message-ID: <20130526131410.GB6387@spo001.leaseweb.com>
References: <000a01ce44bc$4ebef180$ec3cd480$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000a01ce44bc$4ebef180$ec3cd480$@samsung.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

> Use devm_gpio_request_one() to make cleanup paths simpler.
> Also, GPIOF_DIR_OUT | GPIOF_INIT_LOW is replaced with
> GPIOF_OUT_INIT_LOW.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/watchdog/wm831x_wdt.c |   17 ++++++-----------
>  1 files changed, 6 insertions(+), 11 deletions(-)
> 

Patch added to linux-watchdog-next.

Kind regards,
Wim.


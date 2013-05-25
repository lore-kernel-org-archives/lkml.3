Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab3EYUXc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 16:23:32 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:47926 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757924Ab3EYUXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 16:23:31 -0400
Date: Sat, 25 May 2013 22:23:29 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH RESEND 3/5] watchdog: pnx4008_wdt: use devm_clk_get()
Message-ID: <20130525202329.GA13521@spo001.leaseweb.com>
References: <000401ce44ba$326e7a70$974b6f50$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000401ce44ba$326e7a70$974b6f50$@samsung.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

> Use devm_clk_get() to make cleanup paths more simple.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/watchdog/pnx4008_wdt.c |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 

Patch added to linux-watchdog-next.

Kind regards,
Wim.


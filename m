Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab3EZPi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 11:38:29 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:48094 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754018Ab3EZPi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 11:38:28 -0400
Date: Sun, 26 May 2013 17:38:24 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: jz4740: Pass device to clk_get
Message-ID: <20130526153824.GA7990@spo001.leaseweb.com>
References: <1368381843-3856-1-git-send-email-lars@metafoo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368381843-3856-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars-Peter,

> In preparation to switching the jz4740 clk driver to the common clk framework
> make sure to pass the device to clk_get().
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/watchdog/jz4740_wdt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Patch added to linux-watchdog-next.

Kind regards,
Wim.


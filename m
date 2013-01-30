Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3A3Tbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:31:50 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:33163 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753070Ab3A3Tbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:31:49 -0500
Date: Wed, 30 Jan 2013 20:31:44 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Fabio Porcedda <fabio.porcedda@gmail.com>
Subject: Re: [PATCH 10/19] watchdog: at91sam9: at91_wdt_dt_ids cannot be __init
Message-ID: <20130130193144.GA20303@spo001.leaseweb.com>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de> <1359153858-31992-1-git-send-email-arnd@arndb.de> <1359153858-31992-11-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359153858-31992-11-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

> The device IDs are referenced by the driver and potentially
> used beyond the init time, as kbuild correctly warns
> about. Remove the __initconst annotation.
> 
> Without this patch, building at91_dt_defconfig results in:
> 
> WARNING: drivers/watchdog/built-in.o(.data+0x28): Section mismatch in reference from the variable at91wdt_driver to the (unknown reference) .init.rodata:(unknown)
> The variable at91wdt_driver references
> the (unknown reference) __initconst (unknown)
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: linux-watchdog@vger.kernel.org
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Fabio Porcedda <fabio.porcedda@gmail.com>

Added to linux-watchdog-next.

Kind regards,
Wim.


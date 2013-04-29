Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab3D2Qmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:42:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:34527 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275Ab3D2Qmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:42:38 -0400
Message-ID: <517EA2E4.8030905@infradead.org>
Date: Mon, 29 Apr 2013 09:42:12 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: linux-next: Tree for Apr 29 (staging/gdm72xx)
References: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au>
In-Reply-To: <20130429191754.8ee71fb814790bf345516ab8@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/13 02:17, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130426:
> 

on x86_64:

when CONFIG_MMC=m and
CONFIG_WIMAX_GDM72XX_SDIO=y (because it is boolean, not tristate):

gdm_sdio.c:(.text+0x147093): undefined reference to `sdio_claim_host'
gdm_sdio.c:(.text+0x1470a2): undefined reference to `sdio_release_irq'
gdm_sdio.c:(.text+0x1470b1): undefined reference to `sdio_disable_func'
gdm_sdio.c:(.text+0x1470c0): undefined reference to `sdio_release_host'
gdm_sdio.c:(.text+0x14725a): undefined reference to `sdio_claim_host'
gdm_sdio.c:(.text+0x14728f): undefined reference to `sdio_memcpy_toio'
gdm_sdio.c:(.text+0x1472fa): undefined reference to `sdio_memcpy_toio'
gdm_sdio.c:(.text+0x147342): undefined reference to `sdio_release_host'
gdm_sdio.c:(.text+0x1477b6): undefined reference to `sdio_readb'
gdm_sdio.c:(.text+0x1477db): undefined reference to `sdio_writeb'
gdm_sdio.c:(.text+0x1477f5): undefined reference to `sdio_memcpy_fromio'
gdm_sdio.c:(.text+0x14795b): undefined reference to `sdio_memcpy_fromio'
gdm_sdio.c:(.text+0x1479ba): undefined reference to `sdio_memcpy_fromio'
gdm_sdio.c:(.text+0x147ba8): undefined reference to `sdio_writeb'
gdm_sdio.c:(.text+0x147f45): undefined reference to `sdio_claim_host'
gdm_sdio.c:(.text+0x147f54): undefined reference to `sdio_enable_func'
gdm_sdio.c:(.text+0x147f6a): undefined reference to `sdio_claim_irq'
gdm_sdio.c:(.text+0x148343): undefined reference to `sdio_writeb'
gdm_sdio.c:(.text+0x148352): undefined reference to `sdio_release_host'
sdio_boot.c:(.text+0x148543): undefined reference to `sdio_memcpy_toio'
sdio_boot.c:(.text+0x1485b7): undefined reference to `sdio_readb'
sdio_boot.c:(.text+0x14862c): undefined reference to `sdio_memcpy_fromio'
sdio_boot.c:(.text+0x14867d): undefined reference to `sdio_writeb'
sdio_boot.c:(.text+0x14869a): undefined reference to `sdio_writeb'
gdm_sdio.c:(.init.text+0xa6bc): undefined reference to `sdio_register_driver'
gdm_sdio.c:(.exit.text+0x23b6): undefined reference to `sdio_unregister_driver'



-- 
~Randy

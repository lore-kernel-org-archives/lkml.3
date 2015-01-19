Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbbASTjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 14:39:46 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:55049 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbbASTjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 14:39:45 -0500
Date: Mon, 19 Jan 2015 11:39:43 -0800
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: drivers for 3.20 #1
Message-ID: <20150119193943.GH16883@quad.lixom.net>
References: <1421341350-13936-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421341350-13936-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 06:02:30PM +0100, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> This is a pull-request about AT91 drivers for 3.20. We took the USB gadget part
> with us as it depends on the Matrix syscon part. There is no dependency anyway.
> 
> Thanks, best regards,
> 
> The following changes since commit eaa27f34e91a14cdceed26ed6c6793ec1d186115:
> 
>   linux 3.19-rc4 (2015-01-11 12:44:53 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-drivers
> 
> for you to fetch changes up to a5514d142e7f5cff8e02a6fb4cfcb3e301c0eb59:
> 
>   usb: gadget: at91_udc: Allocate udc instance (2015-01-15 14:53:23 +0100)
> 
> ----------------------------------------------------------------
> First batch of drivers changes for 3.20:
> - Internal AHB bus matrix (Matrix) and Static Memory Controller (SMC) are now
>   mfd/syscon drivers.
> - USB gadget full speed (at91_udc): fixes, simplification and multi-platform awareness
>   DT enhancement.
> 
> ----------------------------------------------------------------
> Boris Brezillon (12):
>       mfd: syscon: Add atmel-matrix registers definition
>       mfd: syscon: Add Atmel Matrix bus DT binding documentation
>       mfd: syscon: Add atmel-smc registers definition
>       mfd: syscon: Add Atmel SMC binding doc
>       usb: gadget: at91_udc: Fix clock names
>       usb: gadget: at91_udc: Drop uclk clock
>       usb: gadget: at91_udc: Document DT clocks and clock-names property
>       usb: gadget: at91_udc: Remove non-DT handling code
>       usb: gadget: at91_udc: Simplify probe and remove functions
>       usb: gadget: at91_udc: Rework for multi-platform kernel support
>       usb: gadget: at91_udc: Update DT binding documentation
>       usb: gadget: at91_udc: Allocate udc instance

Merged into next/drivers. Thanks.


-Olof

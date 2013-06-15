Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab3FOBwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 21:52:20 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:39758 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3FOBwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 21:52:19 -0400
Date: Fri, 14 Jun 2013 18:52:24 -0700
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, balbi@ti.com, richard.genoud@gmail.com,
        voice.shen@atmel.com, vinod.koul@intel.com,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: Device Tree update for 3.11 #2
Message-ID: <20130615015224.GA25585@quad.lixom.net>
References: <1370279139-7181-1-git-send-email-nicolas.ferre@atmel.com>
 <1371250067-19317-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371250067-19317-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 12:47:47AM +0200, Nicolas Ferre wrote:
> Arnd, Olof,
> 
> Additional pull-request for AT91 DT patches.
> It contains the remaining part of the USB gadget pull-request that I sent you
> last week. After having split it, here is the DT part.
> It also contains the update of DMA bindings: it is the AT91 part the should go
> through arm-soc. I have included the patch (ARM: at91: dt: add header to define
> at_hdmac configuration) so that we avoid build errors whichever git tree
> (slave-dma or arm-soc) is merged first.
> A SPI DT patch for at91sam9x5 is also added.
> 
> Thanks, best regards,
> 
> The following changes since commit 028633c238f91dc113520a7ad25d37b2ba9068af:
> 
>   ARM: at91/dt: add pinctrl definition for at91 tc blocks (2013-05-31 22:40:37 +0200)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-dt

Pulled, thanks.


-Olof

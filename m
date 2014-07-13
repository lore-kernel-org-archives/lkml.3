Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaGMEf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 00:35:27 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64465 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaGMEfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 00:35:20 -0400
Date: Sat, 12 Jul 2014 21:35:44 -0700
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: dt for 3.17 #1
Message-ID: <20140713043544.GD14206@quad.lixom.net>
References: <1404926979-31356-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404926979-31356-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 07:29:39PM +0200, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> This is a big pull-request concerning DT on AT91. The bulk of it is the move of
> the remaining SoCs to CCF. Some fixes and little additions are also included.
> Alexandre's work were taken as a pull-request: as it is my first one,
> please tell me if I did the inclusion correctly.

Looks good, you might want to ask him to write better tag descriptions though,
or fill them in a bit yourself when you do the merge.

> Thanks, best regards,
> 
> The following changes since commit 4c834452aad01531db949414f94f817a86348d59:
> 
>   Linux 3.16-rc3 (2014-06-29 14:11:36 -0700)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-dt
> 
> for you to fetch changes up to bf4d997ab890c2e32f3db390bec29fdd382da174:
> 
>   Merge tag 'CCF-for-3.17' of git://github.com/at91linux/linux-at91 into at91-3.17-dt (2014-07-09 19:14:31 +0200)
> 
> ----------------------------------------------------------------
> 
> First DT update for 3.17:
> - move of crystals DT definitions to the /clocks node
> - addition of clock entries for sound for CCF enabled platforms
> - addition of DMA and DMA + nand on at91sam9rl
> - move to CCF for all not-converted-yet AT91 SoCs: at91rm9200, at91sam9260/9g20,
>   at91sam9g45 family and at91sam9263

Merged, thanks!


-Olof

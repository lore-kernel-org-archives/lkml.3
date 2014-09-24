Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbaIXFie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 01:38:34 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:40120 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaIXFic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 01:38:32 -0400
Date: Tue, 23 Sep 2014 21:59:06 -0700
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: drivers for 3.18 #2 (bis)
Message-ID: <20140924045906.GC24803@localhost>
References: <1409934969-11584-1-git-send-email-nicolas.ferre@atmel.com>
 <1410797563-13378-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410797563-13378-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 06:12:43PM +0200, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> I re-send this pull-request with the work done by Maxime to take Arnd's
> comments into annount: removal of the early_platform devices, and by keeping
> the old mechanism with a function exported by the PIT timer and called by the
> board files.
> 
> Here is the old message that I sent you: just as a reference.
> "
> This pull-request is focused on the work that Maxime did for migrating our
> timer (PIT) to the clocksource sub-system. A big cleanup happened which allows
> us to be even closer to the point when we have only the bare minimum in our
> formerly crowded mach-at91 directory.
> "
> 
> This pull-request goes on top of what is already in your at91/drivers branch.
> 
> Thanks, best regards,
> 
> The following changes since commit 405a72c5e78b5c560c8b2711d4000fa5eb063e1b:
> 
>   power: reset: at91-poweroff: fix wakeup status register index (2014-09-01 18:40:44 +0200)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-drivers2
> 
> for you to fetch changes up to b052ff30cd450c91a32e8e928979bca021462996:
> 
>   ARM: at91: PIT: Move the driver to drivers/clocksource (2014-09-15 17:55:48 +0200)
> 
> ----------------------------------------------------------------
> Second drivers series for AT91/3.18:
> - move of the PIT (basic timer) from mach-at91 to its proper location:
>   drivers/clocksource
> - big cleanup of this driver along the way

Thanks, merged.


-Olof

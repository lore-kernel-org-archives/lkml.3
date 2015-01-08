Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbbAHWlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 17:41:42 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:61890 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbbAHWll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 17:41:41 -0500
Date: Thu, 8 Jan 2015 14:41:50 -0800
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: fixes for 3.19 #1 (bis)
Message-ID: <20150108224150.GB13612@quad.lixom.net>
References: <1420456477-18204-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420456477-18204-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 12:14:37PM +0100, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> This is the rebase of my previous pull-request on top of 3.19-rc1. As said at
> the time of my early messages, I was waiting for the arm-soc *and* pinctrl
> material to reach Linus T.'s tree before sending this pull-request. In fact
> this sequence was needed for the gpio header removal. The little patch about
> #include deletion just follows an earlier merge conflict in arm-soc tree: I was
> also waiting for this moment before sending the definitive fix, just to be
> sure.
> 
> In comparison with the previous pull-request, I also added a tiny correction of
> the sama5d4.dtsi timer entry. All the rest is pretty straightforward.
> 
> Thanks, best regards,
> 
> The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:
> 
>   Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-fixes
> 
> for you to fetch changes up to 0e049c66ebf56a415cadd6c593b7ee0a2cb9d19d:
> 
>   ARM: at91/dt: sama5d4: fix the timer reg length (2015-01-05 11:07:14 +0100)
> 
> ----------------------------------------------------------------
> First fixes batch for AT91 on 3.19 folowing The big cleanup:
> - removal of unused Kconfig RTC options
> - GPIO header file is now in same directory as the pinctrl driver
> - little fix on #includes
> - removal of DEBUG_LL from the sama5 common defconfig
> - little fix of reg size in sama5d4.dtsi
> 
> ----------------------------------------------------------------
> Bo Shen (1):
>       ARM: at91/dt: sama5d4: fix the timer reg length

This is the only fix among these patches, isn't it? The others seem to
be code removals/cleanups better targeted for 3.20, as far as I can tell.


-Olof

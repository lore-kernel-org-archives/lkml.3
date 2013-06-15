Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab3FOABu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 20:01:50 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:55478 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab3FOABt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 20:01:49 -0400
Date: Fri, 14 Jun 2013 17:01:54 -0700
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: Re: [GIT PULL 1/5]: ux500 core changes for v3.11
Message-ID: <20130615000154.GB18124@quad.lixom.net>
References: <CACRpkdZLQa9_2m6WUYWaBty0F4a13zJA+tnPJZrWYBOeZ=vfrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZLQa9_2m6WUYWaBty0F4a13zJA+tnPJZrWYBOeZ=vfrg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 02:21:10PM +0200, Linus Walleij wrote:
> Hi ARM SoC folks,
> 
> this is the ux500 core changes for v3.11. See the signed
> tag for details.
> 
> The following changes since commit e4aa937ec75df0eea0bee03bffa3303ad36c986b:
> 
>   Linux 3.10-rc3 (2013-05-26 16:00:47 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git
> tags/ux500-core-for-arm-soc

Hi,

> 
> for you to fetch changes up to 080e0435e54298992dfc03dc04ca53cfe3de36ba:
> 
>   ARM: ux500: avoid warning in ux500_read_asicid (2013-06-04 11:21:58 +0200)
> 
> ----------------------------------------------------------------
> Ux500 core changes:
> - Fixes for size and location of PRCMU TCDM
> - SD/MMC/SDIO caps updates to boardfiles
> - Misc fixes
> 
> ----------------------------------------------------------------
> Arnd Bergmann (1):
>       ARM: ux500: avoid warning in ux500_read_asicid
> 
> Lee Jones (3):
>       ARM: ux500: Increase the size of the PRCMU's TCPM size
>       ARM: ux500: Remove incorrect DB9540 PRCMU TCDM base location
>       ARM: ux500: regulators: Remove misleading comment
> 
> Ulf Hansson (6):
>       ARM: ux500: Enable 100MHz for SD/SDIO/MMC devices
>       ARM: ux500: Don't set plf ocr mask for SD/MMC device
>       ARM: ux500: Enable support for RPMB and Reliable Write for eMMC
>       ARM: ux500: Enable support for discard for MMC/SD
>       ARM: ux500: Set eMMC and WLAN card slot as non-removable
>       ARM: ux500: Enable support for UHS-I SD-cards

So, the first two patches seem to be fixes (the TCDM ones). Then a bunch of
board patches, and then one warning fix.

Sorting the three fixes in a fixes-non-critical branch, and the rest in a board
branch, could have been a good way to organize this.

Anyway, not a big deal, I'll pull this into next/boards, since that's what most
of the patches are for.


-Olof

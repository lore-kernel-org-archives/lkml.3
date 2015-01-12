Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbbALWMV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 17:12:21 -0500
Received: from mail-yk0-f169.google.com ([209.85.160.169]:53324 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbbALWMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 17:12:19 -0500
Date: Mon, 12 Jan 2015 14:12:30 -0800
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Wenyou Yang <wenyou.yang@atmel.com>,
        Alexander Stein <alexanders83@web.de>, Bo Shen <voice.shen@atmel.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: fixes for 3.19 #1 (ter)
Message-ID: <20150112221230.GD22090@quad.lixom.net>
References: <1421076472-10589-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421076472-10589-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 04:27:52PM +0100, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> Here is the fixes pull-request for 3.19 that supersedes the ones already sent.
> It collects all the fixes that I have currently for this kernel revision.
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
> for you to fetch changes up to b8659752c37ec157ee254cff443b1c9d523aea22:
> 
>   ARM: at91: board-dt-sama5: add phy_fixup to override NAND_Tree (2015-01-12 15:50:23 +0100)

Thanks Nicolas, now merged!


-Olof

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3EGJnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:43:12 -0400
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:45661 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754500Ab3EGJnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:43:11 -0400
Date: Tue, 7 May 2013 15:12:06 +0530
From: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 54/63] ARM: ux500: Replace ST-E's home-brew DMA
 direction definition with the generic one
Message-ID: <20130507094205.GA32548@bnru10>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
 <1367591569-32197-55-git-send-email-lee.jones@linaro.org>
 <20130506071355.GA5552@bnru10>
 <20130507073921.GT24153@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130507073921.GT24153@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 09:39:21 +0200, Lee Jones wrote:
> On Mon, 06 May 2013, Srinidhi Kasagar wrote:
> 
> > On Fri, May 03, 2013 at 16:32:40 +0200, Lee Jones wrote:
> > > STEDMA40_*_TO_* direction definitions are identical in all but name to
> > > the pre-defined generic DMA_*_TO_* ones. Let's make things easy by not
> > > duplicating such things.
> > > 
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  arch/arm/mach-ux500/board-mop500-audio.c |   12 ++++++------
> > >  arch/arm/mach-ux500/board-mop500-sdi.c   |   16 ++++++++--------
> > >  arch/arm/mach-ux500/board-mop500.c       |   22 +++++++++++-----------
> > >  arch/arm/mach-ux500/usb.c                |    4 ++--
> > >  4 files changed, 27 insertions(+), 27 deletions(-)
> > 
> > Hope you have taken care for all other files, because, I see
> > few more instances in my tree apart from the above files.
> 
> Would you be kind enough to paste those files please?

arch/arm/mach-ux500/board-mop500-audio.c:       .dir = STEDMA40_MEM_TO_PERIPH,
arch/arm/mach-ux500/board-mop500-audio.c:       .dir = STEDMA40_MEM_TO_PERIPH,
arch/arm/mach-ux500/board-mop500-audio.c:       .dir = STEDMA40_MEM_TO_PERIPH,
arch/arm/mach-ux500/board-mop500-sdi.c: .dir = STEDMA40_MEM_TO_PERIPH,
arch/arm/mach-ux500/board-mop500-sdi.c: .dir = STEDMA40_MEM_TO_PERIPH,
arch/arm/mach-ux500/board-mop500-sdi.c: .dir = STEDMA40_MEM_TO_PERIPH,
arch/arm/mach-ux500/board-mop500-sdi.c: .dir = STEDMA40_MEM_TO_PERIPH,
arch/arm/mach-ux500/board-mop500.c:                             .dir = STEDMA40_MEM_TO_PERIPH,
arch/arm/mach-ux500/board-mop500.c:             .dir = STEDMA40_MEM_TO_PERIPH,
arch/arm/mach-ux500/board-mop500.c:     .dir = STEDMA40_MEM_TO_PERIPH,
arch/arm/mach-ux500/board-mop500.c:     .dir = STEDMA40_MEM_TO_PERIPH,
arch/arm/mach-ux500/board-mop500.c:     .dir = STEDMA40_MEM_TO_PERIPH,
arch/arm/mach-ux500/board-mop500.c:     .dir = STEDMA40_MEM_TO_PERIPH,
arch/arm/mach-ux500/devices-db8500.c:   .dir = STEDMA40_MEM_TO_MEM,
arch/arm/mach-ux500/devices-db8500.c:   .dir = STEDMA40_MEM_TO_MEM,
arch/arm/mach-ux500/usb.c:              .dir = STEDMA40_MEM_TO_PERIPH, \

regards,
srinidhi

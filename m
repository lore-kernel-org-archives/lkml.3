Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab3EGHj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 03:39:28 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:43113 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab3EGHj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 03:39:26 -0400
Date: Tue, 7 May 2013 08:39:21 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 54/63] ARM: ux500: Replace ST-E's home-brew DMA direction
 definition with the generic one
Message-ID: <20130507073921.GT24153@gmail.com>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
 <1367591569-32197-55-git-send-email-lee.jones@linaro.org>
 <20130506071355.GA5552@bnru10>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130506071355.GA5552@bnru10>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 May 2013, Srinidhi Kasagar wrote:

> On Fri, May 03, 2013 at 16:32:40 +0200, Lee Jones wrote:
> > STEDMA40_*_TO_* direction definitions are identical in all but name to
> > the pre-defined generic DMA_*_TO_* ones. Let's make things easy by not
> > duplicating such things.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/mach-ux500/board-mop500-audio.c |   12 ++++++------
> >  arch/arm/mach-ux500/board-mop500-sdi.c   |   16 ++++++++--------
> >  arch/arm/mach-ux500/board-mop500.c       |   22 +++++++++++-----------
> >  arch/arm/mach-ux500/usb.c                |    4 ++--
> >  4 files changed, 27 insertions(+), 27 deletions(-)
> 
> Hope you have taken care for all other files, because, I see
> few more instances in my tree apart from the above files.

Would you be kind enough to paste those files please?

> Otherwise..
> 
> Acked-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>
> 
> regards,
> srinidhi

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

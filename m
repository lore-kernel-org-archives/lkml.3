Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbaFRH6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 03:58:23 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62983 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231AbaFRH6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 03:58:21 -0400
Date: Wed, 18 Jun 2014 08:58:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH] mfd: mc13xxx: Use regmap irq framework for interrupts
Message-ID: <20140618075816.GL21030@lee--X1>
References: <1402122010-28843-1-git-send-email-shc_work@mail.ru>
 <20140617200459.GU29841@lee--X1>
 <1403062279.528598806@f152.i.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403062279.528598806@f152.i.mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Alexander Shiyan wrote:

> Tue, 17 Jun 2014 21:04:59 +0100 от Lee Jones <lee.jones@linaro.org>:
> > On Sat, 07 Jun 2014, Alexander Shiyan wrote:
> > 
> > > This patch convert mc13xxx MFD driver to use regmap irq framework
> > > for interrupt registration.
> > > 
> > > Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> > > ---
> > >  drivers/mfd/Kconfig         |   1 +
> > >  drivers/mfd/mc13xxx-core.c  | 299 ++++++--------------------------------------
> > >  drivers/mfd/mc13xxx.h       |   7 +-
> > >  include/linux/mfd/mc13xxx.h |  21 +++-
> > >  4 files changed, 59 insertions(+), 269 deletions(-)
> > 
> > Patch looks good to me and I love the diffstat.  If any problems occur
> > as a result of applying this patch we can fix it up as subsequent
> > patch submissions.
> 
> Unfortunately, prolonged use of the modified version, revealed two errors.
> I will try to make incremental patch quickly, or can send a second version
> of the patch.

Very well, I'll yank the patch for now.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

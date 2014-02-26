Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaBZWAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 17:00:13 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:47730 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaBZWAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 17:00:11 -0500
Date: Wed, 26 Feb 2014 22:00:04 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        davinci-linux-open-source@linux.davincidsp.com,
        Samuel Ortiz <sameo@linux.intel.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        Cyril Chemparathy <cyril@ti.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/5] mfd: remove obsolete ti-ssp driver
Message-ID: <20140226220004.GQ9195@lee--X1>
References: <1393418614-3968549-1-git-send-email-arnd@arndb.de>
 <1393418614-3968549-5-git-send-email-arnd@arndb.de>
 <20140226125157.GM9195@lee--X1>
 <20140226205703.GA21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140226205703.GA21483@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > The tnetv107x platform is getting removed, so this driver
> > > is not needed any more.
> > > 
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > > Cc: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/mfd/Kconfig  |  11 --
> > >  drivers/mfd/Makefile |   1 -
> > >  drivers/mfd/ti-ssp.c | 465 ---------------------------------------------------
> > >  3 files changed, 477 deletions(-)
> > >  delete mode 100644 drivers/mfd/ti-ssp.c
> > 
> > Applied, thanks.
> 
> This makes me wonder whether you apply any patch you receive via email,
> or whether you read the covering email first.

I did (miss-)read the cover letter first.

> Arnd's 0/5 email said:
> 
> 	However, I'm looking for an Ack from
> 	Cyril Chemparathy and Sekhar Nori first, to be sure we
> 	won't need this code in the future.

I read this to mean "looking for an Ack from Cyril and Sekhar for
patches which are due to go in via a different tree (ARM-SoC?)".

My apologies for misreading. Patch removed from MFD -next until I get
a further nod.

> This is exactly the reason why I'd now recommend that if people want to
> send out patches which they don't intend maintainers to take, that they
> use "[PATCH RFC" in the subject _and_ they make sure that the patch can't
> be trivially applied.  That means maintainers have to (a) not notice the
> RFC in the subject, and _then_ they have to intentionally fix the patch
> before applying.  Both taken together will be sufficient deterrent for
> this kind of mistake happening.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

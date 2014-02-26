Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaBZU5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:57:16 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:52145 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753616AbaBZU5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:57:15 -0500
Date: Wed, 26 Feb 2014 20:57:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        davinci-linux-open-source@linux.davincidsp.com,
        Samuel Ortiz <sameo@linux.intel.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        Cyril Chemparathy <cyril@ti.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/5] mfd: remove obsolete ti-ssp driver
Message-ID: <20140226205703.GA21483@n2100.arm.linux.org.uk>
References: <1393418614-3968549-1-git-send-email-arnd@arndb.de> <1393418614-3968549-5-git-send-email-arnd@arndb.de> <20140226125157.GM9195@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226125157.GM9195@lee--X1>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 12:51:57PM +0000, Lee Jones wrote:
> > The tnetv107x platform is getting removed, so this driver
> > is not needed any more.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > Cc: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/mfd/Kconfig  |  11 --
> >  drivers/mfd/Makefile |   1 -
> >  drivers/mfd/ti-ssp.c | 465 ---------------------------------------------------
> >  3 files changed, 477 deletions(-)
> >  delete mode 100644 drivers/mfd/ti-ssp.c
> 
> Applied, thanks.

This makes me wonder whether you apply any patch you receive via email,
or whether you read the covering email first.

Arnd's 0/5 email said:

	However, I'm looking for an Ack from
	Cyril Chemparathy and Sekhar Nori first, to be sure we
	won't need this code in the future.

This is exactly the reason why I'd now recommend that if people want to
send out patches which they don't intend maintainers to take, that they
use "[PATCH RFC" in the subject _and_ they make sure that the patch can't
be trivially applied.  That means maintainers have to (a) not notice the
RFC in the subject, and _then_ they have to intentionally fix the patch
before applying.  Both taken together will be sufficient deterrent for
this kind of mistake happening.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.

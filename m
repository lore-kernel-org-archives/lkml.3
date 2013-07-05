Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab3GEU7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 16:59:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:46509 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab3GEU7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 16:59:52 -0400
Date: Fri, 5 Jul 2013 22:59:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
cc: Baruch Siach <baruch@tkos.co.il>, John Stultz <john.stultz@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Michal Simek <michal.simek@xilinx.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] clocksource/cadence_ttc: Reuse clocksource as
 sched_clock
In-Reply-To: <4fab6223-45c5-453e-9972-1c12aa79a312@CO1EHSMHS008.ehs.local>
Message-ID: <alpine.DEB.2.02.1307052259090.32106@ionos.tec.linutronix.de>
References: <1372888216-10726-1-git-send-email-soren.brinkmann@xilinx.com> <20130704033026.GX4288@tarshish> <0030b826-0eb1-4bb8-a0de-1d8dc68bd81a@TX2EHSMHS017.ehs.local> <alpine.DEB.2.02.1307052238170.32106@ionos.tec.linutronix.de>
 <4fab6223-45c5-453e-9972-1c12aa79a312@CO1EHSMHS008.ehs.local>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-887108065-1373057994=:32106"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-887108065-1373057994=:32106
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Fri, 5 Jul 2013, Sören Brinkmann wrote:
> On Fri, Jul 05, 2013 at 10:42:03PM +0200, Thomas Gleixner wrote:
> > We have a mechanism for that in place, if stuff goes cross trees. One
> > of the trees provides a set of commit for the other tree to pull, so
> > we do not end up with merge dependencies and conflicts.
> > 
> > Why is clocksource stuff going through armsoc unless it contains
> > related modifications in arch/arm/
> We overhauled Zynq's common clock code and migrated all Zynq drivers to
> it - the TTC being one. I'm pretty sure you were on the CC list for that
> change.
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=30e1e28598c2674c133148d8aec6d431d7acd314
> 

That's fine as it has no dependencies on any of the clocksource core
changes AFAICT.

Thanks,

	tglx
--8323329-887108065-1373057994=:32106--

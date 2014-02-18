Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441AbaBRQW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:22:29 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14112 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610AbaBRQW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:22:28 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+V88BzLd5Qwg0ilZRIE3P3VABcp2gN1Mk=
X-DKIM: OpenDKIM Filter v2.0.1 titan 679A852BB2A
Date: Tue, 18 Feb 2014 11:22:10 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: mvebu fixes for v3.14
Message-ID: <20140218162210.GU7862@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Here is a small round of fixes for irq-orion.c.  They've been in -next
for over a week.  Please pull.

We have a set of watchdog changes depending on this that are going
through mvebu/arm-soc.  So please don't rebase, just let me know if
there's something that isn't right.  I'll fix it up and resend.

thx,

Jason.


The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:

  Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)

are available in the git repository at:

  git://git.infradead.org/linux-mvebu.git tags/irqchip-mvebu-fixes-3.14

for you to fetch changes up to 12bd4f7c135482fd097e7e169308d84b72c32b69:

  IRQ: Orion: Fix getting generic chip pointer. (2014-02-08 15:42:07 +0000)

----------------------------------------------------------------
irqchip mvebu fixes for v3.14

 - orion:
    - fixes for clearing bridge cause register, and clearing stale interrupts

----------------------------------------------------------------
Andrew Lunn (1):
      IRQ: Orion: Fix getting generic chip pointer.

Sebastian Hesselbarth (3):
      irqchip: orion: clear bridge cause register on init
      irqchip: orion: use handle_edge_irq on bridge irqs
      irqchip: orion: clear stale interrupts in irq_startup

 drivers/irqchip/irq-orion.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

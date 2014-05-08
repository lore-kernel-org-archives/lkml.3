Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaEHOux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:50:53 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:21949 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751523AbaEHOuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:50:51 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+b5z+fQfCd45g0rvTcp5T2DXw6VBagOFU=
X-DKIM: OpenDKIM Filter v2.0.1 titan A458556F915
Date: Thu, 8 May 2014 10:50:41 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: mvebu: driver changes for v3.16
Message-ID: <20140508145041.GB12708@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Here's the first round of irqchip changes from the mvebu folks.  Not too
big this time around.  This should be everything for v3.16.  I'm not
aware of any other pending patches.

These changes have been in -next for quite a while (for Thomas', well
over a week).

Please pull.

thx,

Jason.


The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.infradead.org/linux-mvebu.git tags/irqchip-mvebu-3.16

for you to fetch changes up to bffbc6eabd0e48bba5415c4aec34cb75d459c73a:

  irqchip: orion: Reverse irq handling priority (2014-05-08 14:42:09 +0000)

----------------------------------------------------------------
irqchip mvebu changes for v3.16

 - orion
    - reverse irq handling priority

 - armada-370-xp
    - do set_smp_cross_call in the driver
    - use cpu notifier to init secondary cpus

----------------------------------------------------------------
Sebastian Hesselbarth (1):
      irqchip: orion: Reverse irq handling priority

Thomas Petazzoni (2):
      irqchip: irq-armada-370-xp: Do the set_smp_cross_call() in the driver
      irqchip: irq-armada-370-xp: Use cpu notifier to initialize secondary CPUs

 arch/arm/mach-mvebu/armada-370-xp.h |  2 --
 arch/arm/mach-mvebu/platsmp.c       |  8 --------
 drivers/irqchip/irq-armada-370-xp.c | 24 ++++++++++++++++++++++--
 drivers/irqchip/irq-orion.c         |  4 ++--
 4 files changed, 24 insertions(+), 14 deletions(-)

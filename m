Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbaFYMip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:38:45 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:48083 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752596AbaFYMio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:38:44 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19XAEYnEHpoRdzkfZfkV0f5rc4T6oedeUE=
X-DKIM: OpenDKIM Filter v2.0.1 titan 113AD599532
Date: Wed, 25 Jun 2014 08:38:42 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: fixes for v3.16
Message-ID: <20140625123842.GQ10202@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Here's a round of fixes for irqchip.  They've been in -next a few days
and are based on v3.16-rc1.

Please pull.

thx,

Jason.

The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-urgent-3.16

for you to fetch changes up to 4f4366033945419b0c52118c29d3057d7c558765:

  irqchip: spear_shirq: Fix interrupt offset (2014-06-21 23:26:39 +0000)

----------------------------------------------------------------
irqchip fixes for v3.16

 - armada-370-xp
    - Mask all interrupts during init

 - brcmstb-l2
    - interrupts are edge-sensitive

 - spear_shirq
    - fix interrupt offset

----------------------------------------------------------------
Florian Fainelli (1):
      irqchip: brcmstb-l2: Level-2 interrupts are edge sensitive

Thomas Gleixner (1):
      irqchip: spear_shirq: Fix interrupt offset

Thomas Petazzoni (1):
      irqchip: armada-370-xp: Mask all interrupts during initialization.

 drivers/irqchip/irq-armada-370-xp.c | 17 +++++++++++++++--
 drivers/irqchip/irq-brcmstb-l2.c    |  2 +-
 drivers/irqchip/spear-shirq.c       |  2 +-
 3 files changed, 17 insertions(+), 4 deletions(-)

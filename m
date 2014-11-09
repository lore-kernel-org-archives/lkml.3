Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaKIGkf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 01:40:35 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:11312 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751138AbaKIGke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 01:40:34 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18eqCFHU8vX6YazIUzh6jskd7QgdDqT0js=
X-DKIM: OpenDKIM Filter v2.0.1 titan 6AFBC6159F0
Date: Sun, 9 Nov 2014 01:40:32 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: Core changes for v3.19
Message-ID: <20141109064032.GW3698@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

This is a little smaller than I usual send, but I'm trying to keep on
top of it with everything else I have going on.  These changes have been
in -next for at least 4 builds of -next.

Please pull.

thx,

Jason.


The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:

  Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)

are available in the git repository at:

  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-core-3.19

for you to fetch changes up to 1dacf194b1468546a5715db58cbb65d50b598482:

  irqchip: irq-armada-370-xp: Use proper return value for ->set_affinity() (2014-11-09 03:56:37 +0000)

----------------------------------------------------------------
irqchip core changes for v3.19

 - hip04
    - Convert a straggler to handle_domain_irq()

 - dw-apb-ictl
    - Select GENERIC_IRQ_CHIP

 - armada-370-xp
    - Use proper return value for ->set_affinity()

----------------------------------------------------------------
Jisheng Zhang (1):
      irqchip: dw-apb-ictl: Select GENERIC_IRQ_CHIP

Marc Zyngier (1):
      irqchip: hip04: Convert to handle_domain_irq

Thomas Petazzoni (1):
      irqchip: irq-armada-370-xp: Use proper return value for ->set_affinity()

 drivers/irqchip/Kconfig             | 1 +
 drivers/irqchip/irq-armada-370-xp.c | 2 +-
 drivers/irqchip/irq-hip04.c         | 3 +--
 3 files changed, 3 insertions(+), 3 deletions(-)

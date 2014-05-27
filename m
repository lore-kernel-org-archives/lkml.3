Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaE0Ou6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:50:58 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:63018 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaE0Ou5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:50:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+cFXbkvhK9kgRVaQjEP/KryJzg1GjIoc4=
X-DKIM: OpenDKIM Filter v2.0.1 titan 166BC580D2D
Date: Tue, 27 May 2014 10:50:55 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: core changes for v3.16
Message-ID: <20140527145055.GP8664@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Here's the patches I've collected since you asked me to start helping
out.  It's only been a few weeks so there isn't too much here.  A lot of
the patches I've encountered aren't ready yet, and I'll continue working
with those for the next window.  -rc7 dropped earlier than expected. :-/

Please pull.

thx,

Jason.


The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-3.16

for you to fetch changes up to c8dfe94bc7a14c6a644ce55ef77b7a81505c696f:

  Documentation: brcmstb-l2: Add Broadcom STB Level-2 interrupt controller binding (2014-05-27 14:43:36 +0000)

----------------------------------------------------------------
irqchip core changes for v3.16

 - irq-gic
    - use a mask field

 - irq-armada-370-xp
    - move the DT binding docs to the irqchip directory

 - irq-brcmstb-l2
    - new driver for Broadcom Set Top Box Level-2

----------------------------------------------------------------
Ezequiel Garcia (1):
      irqchip: armada-370-xp: Move the devicetree binding documentation

Florian Fainelli (2):
      irqchip: brcmstb-l2: Add Broadcom Set Top Box Level-2 interrupt controller
      Documentation: brcmstb-l2: Add Broadcom STB Level-2 interrupt controller binding

Haojian Zhuang (1):
      irqchip: gic: Use mask field in GICC_IAR

 .../bindings/interrupt-controller/brcm,l2-intc.txt |  29 +++
 .../marvell,armada-370-xp-mpic.txt}                |   0
 drivers/irqchip/Kconfig                            |   6 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-brcmstb-l2.c                   | 202 +++++++++++++++++++++
 drivers/irqchip/irq-gic.c                          |   2 +-
 include/linux/irqchip/arm-gic.h                    |   2 +
 7 files changed, 241 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,l2-intc.txt
 rename Documentation/devicetree/bindings/{arm/armada-370-xp-mpic.txt => interrupt-controller/marvell,armada-370-xp-mpic.txt} (100%)
 create mode 100644 drivers/irqchip/irq-brcmstb-l2.c

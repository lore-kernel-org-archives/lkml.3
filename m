Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbbAKCBt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 21:01:49 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:49894 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751132AbbAKCBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 21:01:48 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Xt99w/ec5Kr9lsRDwfCjAxI2N8g8gJew=
X-DKIM: OpenDKIM Filter v2.0.1 titan 89D37643112
Date: Sat, 10 Jan 2015 21:01:45 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] irqchip: Fixes for v3.19
Message-ID: <20150111020145.GT24989@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

Here's a round of fixes for v3.19.  Nothing too exciting or
controversial (other than I'm a bit behind due to the holidays and
such).

Please pull.

thx,

Jason.

The following changes since commit 97bf6af1f928216fd6c5a66e8a57bfa95a659672:

  Linux 3.19-rc1 (2014-12-20 17:08:50 -0800)

are available in the git repository at:

  git://git.infradead.org/users/jcooper/linux.git tags/irqchip-urgent-3.19

for you to fetch changes up to 91d1179212161f220938198b742c328ad38fd0a3:

  irqchip: atmel-aic-common: Prevent clobbering of priority when changing IRQ type (2015-01-07 12:41:45 +0000)

----------------------------------------------------------------
irqchip urgent fixes for v3.19-rcX

 - mtk-sysirq: Fix error handling
 - hip04: Fix cpu map for 16bit value
 - gic-v3-its: Clear a warning regarding decimal constants
 - omap-intc: Fix legacy DMA regression
 - atmel-aic-common: Retain priority when changing type

----------------------------------------------------------------
Felipe Balbi (1):
      irqchip: omap-intc: Fix legacy DMA regression

Gavin Li (1):
      irqchip: atmel-aic-common: Prevent clobbering of priority when changing IRQ type

Wang Long (1):
      irqchip: hip04: Initialize hip04_cpu_map to 0xffff

Will Deacon (1):
      irqchip: gic-v3-its: Fix use of max with decimal constant

Yingjoe Chen (1):
      irqchip: mtk-sysirq: Use IS_ERR() instead of NULL pointer check

 drivers/irqchip/irq-atmel-aic-common.c |  4 ++--
 drivers/irqchip/irq-gic-v3-its.c       |  2 +-
 drivers/irqchip/irq-hip04.c            |  2 +-
 drivers/irqchip/irq-mtk-sysirq.c       |  4 ++--
 drivers/irqchip/irq-omap-intc.c        | 26 +++++++++++++++++++++-----
 5 files changed, 27 insertions(+), 11 deletions(-)

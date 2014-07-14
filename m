Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbaGNWf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 18:35:59 -0400
Received: from exprod5og103.obsmtp.com ([64.18.0.145]:60259 "HELO
	exprod5og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756976AbaGNWf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 18:35:56 -0400
From: Feng Kan <fkan@apm.com>
To: tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com,
        linux-kernel@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V4 0/2] irqchip: gic: Add support for GIC v2 bypass disable
Date: Mon, 14 Jul 2014 15:36:04 -0700
Message-Id: <1405377366-3244-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up hex number in the gic driver and then adds
the code to preserve GIC v2 bypass disable bits in the GIC driver.

V4 Change: rebase off latest irq tree, merge after gic v3 changes.

V3 Change: remove incorrect Signoff by 

V2 Change:
	seem my send email was not working correctly, resending this with
        rebase pull.
	- had to pull HaoJian's change out of arm-gic.h to keep consistency.
	- replace GIC defines as noted by Marc
	- remove GIC_CPU_DISABLE since it no longer used.
	- fix gic_cpu_if_down as noted by Marc


Feng Kan (2):
  irqchip: gic: replace hex numbers with defines.
  irqchip: gic: preserve gic V2 bypass bits in cpu ctrl register

 drivers/irqchip/irq-gic-common.c | 15 +++++++------
 drivers/irqchip/irq-gic.c        | 46 ++++++++++++++++++++++++++++------------
 include/linux/irqchip/arm-gic.h  | 16 ++++++++++++++
 3 files changed, 58 insertions(+), 19 deletions(-)

-- 
1.9.1


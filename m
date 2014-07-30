Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaG3V4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:56:13 -0400
Received: from exprod5og125.obsmtp.com ([64.18.0.245]:43474 "HELO
	exprod5og125.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752017AbaG3V4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:56:11 -0400
From: Feng Kan <fkan@apm.com>
To: tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com,
        linux-kernel@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V4 RESEND 0/2] irqchip: gic: Add support for GIC v2 bypass disable
Date: Wed, 30 Jul 2014 14:56:57 -0700
Message-Id: <1406757419-18729-1-git-send-email-fkan@apm.com>
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


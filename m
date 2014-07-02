Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278AbaGBVS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 17:18:58 -0400
Received: from exprod5og120.obsmtp.com ([64.18.0.137]:57969 "HELO
	exprod5og120.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751809AbaGBVS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 17:18:57 -0400
From: Feng Kan <fkan@apm.com>
To: tglx@linutronix.de, jason@lakedaemon.net, marc.zyngier@arm.com,
        linux-kernel@vger.kernel.org, patches@apm.com
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V3 0/2] irqchip: gic: Add support for GIC v2 bypass disable
Date: Wed,  2 Jul 2014 14:18:57 -0700
Message-Id: <1404335939-31754-1-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up hex number in the gic driver and then adds
the code to preserve GIC v2 bypass disable bits in the GIC driver.

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

 drivers/irqchip/irq-gic.c       | 83 +++++++++++++++++++++++++++++++----------
 include/linux/irqchip/arm-gic.h |  2 -
 2 files changed, 63 insertions(+), 22 deletions(-)

-- 
1.9.1


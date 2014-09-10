Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaIJAoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 20:44:32 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39221 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaIJAo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 20:44:29 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jason@lakedaemon.net, tglx@linutronix.de, computersforpeace@gmail.com,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v2 0/2] irqchip: Broadcom BCM7120-style Level 2 interrupt controller
Date: Tue,  9 Sep 2014 17:44:20 -0700
Message-Id: <1410309862-27784-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason, Thomas, Mark,

This patch set adds support for the second type of Level-2 interrupt controller
found on Broadcom Set Top Box hardware.

Version 2 should address your previous comments made on the initial submission.

Thanks!

Florian Fainelli (2):
  irqchip: add Broadcom BCM7120-style Level 2 interrupt controller
  Documentation: bcm7120-l2: Add Broadcom BCM7120-style L2 binding

 .../interrupt-controller/brcm,bcm7120-l2-intc.txt  |  86 ++++++++
 drivers/irqchip/Makefile                           |   3 +-
 drivers/irqchip/irq-bcm7120-l2.c                   | 220 +++++++++++++++++++++
 3 files changed, 308 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
 create mode 100644 drivers/irqchip/irq-bcm7120-l2.c

-- 
1.9.1


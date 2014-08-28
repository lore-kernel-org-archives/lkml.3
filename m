Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaH1WgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 18:36:08 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64787 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaH1WgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 18:36:06 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jason@lakedaemon.net, tglx@linutronix.de, computersforpeace@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 0/2] irqchip: Broadcom BCM7120-style Level 2 interrupt controller
Date: Thu, 28 Aug 2014 15:35:24 -0700
Message-Id: <1409265326-7579-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason, Thomas,

This patch set adds support for the second type of Level-2 interrupt controller
found on Broadcom Set Top Box hardware.

Thanks!

Florian Fainelli (2):
  irqchip: add Broadcom BCM7120-style Level 2 interrupt controller
  Documentation: bcm7120-l2: Add Broadcom BCM7120-style L2 binding

 .../interrupt-controller/brcm,bcm7120-l2-intc.txt  |  44 ++++
 drivers/irqchip/Makefile                           |   3 +-
 drivers/irqchip/irq-bcm7120-l2.c                   | 222 +++++++++++++++++++++
 3 files changed, 268 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,bcm7120-l2-intc.txt
 create mode 100644 drivers/irqchip/irq-bcm7120-l2.c

-- 
1.9.1


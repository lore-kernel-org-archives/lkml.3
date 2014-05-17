Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030351AbaEQRxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:53:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35559 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964856AbaEQRxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:53:35 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-arm-kernel@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brian Norris <computersforpeace@gmail.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 0/2] irqchip: Broadcom Set Top Box Level-2 interrupt controller
Date: Sat, 17 May 2014 10:52:51 -0700
Message-Id: <1400349173-11045-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

This patch set adds an irqchip driver for the Broadcom Set Top Box Level-2
interrupt controller hardware, as well as a corresponding Device Tree binding
document.

Thanks!

Florian Fainelli (2):
  irqchip: add Broadcom Set Top Box Level-2 interrupt controller
  Documentation: add Broadcom STB Level-2 interrupt controller binding

 .../bindings/interrupt-controller/brcm,l2-intc.txt |  29 +++
 drivers/irqchip/Kconfig                            |   6 +
 drivers/irqchip/Makefile                           |   1 +
 drivers/irqchip/irq-brcmstb-l2.c                   | 231 +++++++++++++++++++++
 4 files changed, 267 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/brcm,l2-intc.txt
 create mode 100644 drivers/irqchip/irq-brcmstb-l2.c

-- 
1.9.1


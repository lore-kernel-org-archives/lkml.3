Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191AbaEVQhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:37:04 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:60431 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaEVQhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:37:01 -0400
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brian Norris <computersforpeace@gmail.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-kernel@vger.kernel.org (open list), jason@lakedaemon.net
Subject: [PATCH v2 0/2] irqchip: Broadcom Set Top Box Level-2 interrupt controller
Date: Thu, 22 May 2014 09:36:44 -0700
Message-Id: <1400776606-22427-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas, Jason,

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


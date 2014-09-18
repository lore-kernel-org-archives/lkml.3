Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbaIRTFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:05:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40076 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbaIRTFV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:05:21 -0400
From: Nishanth Menon <nm@ti.com>
To: <lee.jones@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        Mark Brown <broonie@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        <linux-omap@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V3 0/3] mfd: palmas: add optional wakeup irq
Date: Thu, 18 Sep 2014 14:04:43 -0500
Message-ID: <1411067086-16613-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
V3 update for the previous series:
Changes in V3 (from review updates):
	- Allow driver to function even if wakeirq fails
	- Fix irq flags

V2: http://marc.info/?l=linux-kernel&m=140995041418575&w=2
v1: https://patchwork.kernel.org/patch/4743321/

Nishanth Menon (3):
  Documentation: dt-bindings: mfd: palmas: Fix example style of i2c
    peripheral
  Documentation: dt-bindings: mfd: palmas: document optional wakeup IRQ
  mfd: palmas: Add support for optional wakeup

 Documentation/devicetree/bindings/mfd/palmas.txt |   22 +++++++-
 drivers/mfd/palmas.c                             |   62 ++++++++++++++++++++++
 include/linux/mfd/palmas.h                       |    2 +
 3 files changed, 85 insertions(+), 1 deletion(-)

-- 
1.7.9.5


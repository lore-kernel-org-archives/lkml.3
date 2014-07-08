Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbaGHB01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:26:27 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:16418 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175AbaGHB00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 21:26:26 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH 0/3] Qualcomm pm8xxx gpio driver
Date: Mon, 7 Jul 2014 18:26:22 -0700
Message-ID: <1404782785-1824-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is device tree bindings as well as a driver for the gpio blocks found in
Qualcomm pm8018, pm8038, pm8058, pm8917 and pm8921 pmic chips.

The first patch extends the pm8921-core to expose a function to read out the
"RT status" of an interrupt pin. This is the way input many input values are
exposed in these set of pmics.

Bjorn Andersson (3):
  mfd: pm8921: Expose pm8xxx_read_irq_status
  pinctrl: Device tree bindings for Qualcomm pm8xxx gpio block
  pinctrl: Introduce pinctrl driver for Qualcomm pm8xxx

 .../bindings/pinctrl/qcom,pm8xxx-gpio.txt          |  230 ++++++
 drivers/mfd/pm8921-core.c                          |   36 +
 drivers/pinctrl/Kconfig                            |   11 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-pm8xxx-gpio.c              |  795 ++++++++++++++++++++
 include/dt-bindings/pinctrl/qcom,pm8xxx-gpio.h     |   34 +
 include/linux/mfd/pm8921-core.h                    |   32 +
 7 files changed, 1139 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pm8xxx-gpio.txt
 create mode 100644 drivers/pinctrl/pinctrl-pm8xxx-gpio.c
 create mode 100644 include/dt-bindings/pinctrl/qcom,pm8xxx-gpio.h
 create mode 100644 include/linux/mfd/pm8921-core.h

-- 
1.7.9.5


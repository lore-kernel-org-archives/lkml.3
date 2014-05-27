Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaE0R2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:28:52 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:4292 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470AbaE0R2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:28:46 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
CC: Josh Cartwright <joshc@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>
Subject: [PATCH 0/3] Qualcomm Resource Power Manager driver
Date: Tue, 27 May 2014 10:28:38 -0700
Message-ID: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.8.2.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds a regulator driver for the Resource Power Manager found in
Qualcomm 8660, 8960 and 8064 based devices.

The RPM driver exposes resources to its child devices, that can be accessed to
implement drivers for the regulators, clocks and bus frequency control that's
owned by the RPM in these devices.

Bjorn Andersson (3):
  mfd: devicetree: bindings: Add Qualcomm RPM DT binding
  mfd: qcom-rpm: Driver for the Qualcomm RPM
  regulator: qcom-rpm: Regulator driver for the Qualcomm RPM

 Documentation/devicetree/bindings/mfd/qcom,rpm.txt | 283 +++++++
 drivers/mfd/Kconfig                                |  15 +
 drivers/mfd/Makefile                               |   1 +
 drivers/mfd/qcom_rpm.c                             | 554 ++++++++++++++
 drivers/regulator/Kconfig                          |  12 +
 drivers/regulator/Makefile                         |   1 +
 drivers/regulator/qcom_rpm-regulator.c             | 852 +++++++++++++++++++++
 include/dt-bindings/mfd/qcom_rpm.h                 | 148 ++++
 include/linux/mfd/qcom_rpm.h                       |  13 +
 9 files changed, 1879 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/qcom,rpm.txt
 create mode 100644 drivers/mfd/qcom_rpm.c
 create mode 100644 drivers/regulator/qcom_rpm-regulator.c
 create mode 100644 include/dt-bindings/mfd/qcom_rpm.h
 create mode 100644 include/linux/mfd/qcom_rpm.h

-- 
1.8.2.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaJAQbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:31:05 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:59680 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbaJAQbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:31:01 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v5 0/4] Qualcomm SPMI PMIC pin controller drivers
Date: Wed,  1 Oct 2014 19:30:54 +0300
Message-Id: <1412181058-29179-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v4:

- Use PMIC name in compatible string.
- PINCTRL_QCOM_SPMI_PMIC from Kconfig symbol.
- Remove pmic string from drivers file names.
- Fixed coding style issues.
- Use qcom-spmi-gpio and qcom-spmi-mpp from dirver names,
  to be similar to qcom-spmi-iadc, qcom-spmi-vadc and 
  qcom-spmi-temp-alarm drivers.

Short description:

Patches adds pin control drivers for Multi-Purpose Pin (MPP) and
General-purpose pin (GPIO) controllers found in Qualcomm SPMI based
PMIC chips.

MPP's are enhanced GPIO's with analog circuits, which support 
analog and digital input/output.

v4: https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg725568.html

Bjorn Andersson (1):
  pinctrl: Device tree bindings for Qualcomm PMIC GPIO block

Ivan T. Ivanov (3):
  pinctrl: Device tree bindings for Qualcomm PMIC MPP block
  pinctrl: Qualcomm SPMI PMIC GPIO pin controller driver
  pinctrl: Qualcomm SPMI PMIC MPP pin controller driver

 .../devicetree/bindings/pinctrl/qcom,pmic-gpio.txt | 215 +++++
 .../devicetree/bindings/pinctrl/qcom,pmic-mpp.txt  | 162 ++++
 drivers/pinctrl/qcom/Kconfig                       |  13 +
 drivers/pinctrl/qcom/Makefile                      |   2 +
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c           | 937 ++++++++++++++++++++
 drivers/pinctrl/qcom/pinctrl-spmi-mpp.c            | 953 +++++++++++++++++++++
 include/dt-bindings/pinctrl/qcom,pmic-gpio.h       | 142 +++
 include/dt-bindings/pinctrl/qcom,pmic-mpp.h        |  44 +
 8 files changed, 2468 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pmic-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,pmic-mpp.txt
 create mode 100644 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
 create mode 100644 drivers/pinctrl/qcom/pinctrl-spmi-mpp.c
 create mode 100644 include/dt-bindings/pinctrl/qcom,pmic-gpio.h
 create mode 100644 include/dt-bindings/pinctrl/qcom,pmic-mpp.h

-- 
1.9.1


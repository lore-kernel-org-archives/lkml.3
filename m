Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaGGPMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:12:24 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:35837 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbaGGPMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:12:21 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 0/4] New Qualcomm PMIC pin controller drivers
Date: Mon,  7 Jul 2014 18:11:29 +0300
Message-Id: <1404745893-6379-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Hi,

This set of patches adds pin control drivers for Multi-purpose
pin (MPP) and General-purpose pin (GPIO) controllers found 
in Qualcomm PMIC chips.

MPP's are enhanced GPIO's with analog circuits, which support 
following functions in addition to digital input/output: analog
input/output and current sinks. 

PMIC PM8941 have 8 MPP's and 36 GPIO's. PMIC PM8841 have 4 MPP's.

Ivan T. Ivanov (4):
  pinctrl: qpnp: Qualcomm PMIC pin controller driver
  pinctrl: qcom: Add documentation for pinctrl-qpnp binding
  pinctrl: qcom: Add PM8941 and PM8941 pinctrl drivers
  ARM: dts: qcom: Add PM8941 and PM8841 pinctrl nodes

 .../bindings/pinctrl/qcom,qpnp-pinctrl.txt         |   78 ++
 arch/arm/boot/dts/qcom-msm8974.dtsi                |   16 +
 drivers/pinctrl/Kconfig                            |   27 +
 drivers/pinctrl/Makefile                           |    3 +
 drivers/pinctrl/pinctrl-pm8841.c                   |   84 ++
 drivers/pinctrl/pinctrl-pm8941.c                   |   96 ++
 drivers/pinctrl/pinctrl-qpnp.c                     | 1454 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-qpnp.h                     |   41 +
 include/dt-bindings/pinctrl/pinctrl-qpnp.h         |   76 +
 9 files changed, 1875 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,qpnp-pinctrl.txt
 create mode 100644 drivers/pinctrl/pinctrl-pm8841.c
 create mode 100644 drivers/pinctrl/pinctrl-pm8941.c
 create mode 100644 drivers/pinctrl/pinctrl-qpnp.c
 create mode 100644 drivers/pinctrl/pinctrl-qpnp.h
 create mode 100644 include/dt-bindings/pinctrl/pinctrl-qpnp.h

-- 
1.8.3.2


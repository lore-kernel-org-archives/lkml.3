Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaILTku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:40:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37027 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaILTks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:40:48 -0400
From: Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [GIT PULL] qcom DT changes for v3.18
Date: Fri, 12 Sep 2014 14:40:41 -0500
Message-Id: <13536005-9FFF-4362-8B87-5F0DC9930D29@codeaurora.org>
Cc: Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Georgi Djakov <gdjakov@mm-sol.com>, pramod.gurav@smartplayin.com,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-dt-for-3.18

for you to fetch changes up to edb81ca3bf586ad526ee67b245cb87f7c7142a87:

  ARM: DT: QCOM: apq8064: Add dma support for sdcc node (2014-09-11 12:07:40 -0500)

----------------------------------------------------------------
Qualcomm ARM Based Device Tree Updates for v3.18

* Added APQ8084 dt support for clocks, serial, pinctrl, and IFC6540 board
* Added IPQ8064 dt support for basic SoC and AP148 board
* Added APQ8064 dt support for pinctrl, reset, SDHC, and multimedia clocks
* Added PMIC 8058 dt support on MSM8660, enables PMIC based power key,
  keypad, rtc, and vibrator
* Added PMIC 8921 dt support on MSM8960, enables PMIC based power key,
  keypad, and rtc

----------------------------------------------------------------
Georgi Djakov (4):
      ARM: dts: qcom: Add APQ8084 Global Clock Controller DT node
      ARM: dts: qcom: Add APQ8084 serial port DT node
      ARM: dts: qcom: Add initial IFC6540 board device tree
      ARM: dts: qcom: Add TLMM DT node for APQ8084

Kumar Gala (1):
      ARM: qcom: Add initial IPQ8064 SoC and AP148 device trees

Pramod Gurav (2):
      ARM: DT: APQ8064: Add pinctrl support
      ARM: DT: APQ8064: Add node for ps_hold function in pinctrl

Srinivas Kandagatla (2):
      ARM: DT: apq8064: Add sdcc support via mcci driver.
      ARM: DT: QCOM: apq8064: Add dma support for sdcc node

Stephen Boyd (3):
      ARM: dts: msm: Add 8921 PMIC to ssbi bus
      ARM: dts: msm: Add 8058 PMIC to ssbi bus
      ARM: dts: qcom: Add 8064 multimedia clock controller node

 arch/arm/boot/dts/Makefile                 |   2 +
 arch/arm/boot/dts/qcom-apq8064-ifc6410.dts |  12 +++
 arch/arm/boot/dts/qcom-apq8064.dtsi        | 103 ++++++++++++++++++++++++
 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts |  23 ++++++
 arch/arm/boot/dts/qcom-apq8084-mtp.dts     |   6 ++
 arch/arm/boot/dts/qcom-apq8084.dtsi        |  51 ++++++++++++
 arch/arm/boot/dts/qcom-ipq8064-ap148.dts   |  85 ++++++++++++++++++++
 arch/arm/boot/dts/qcom-ipq8064-v1.0.dtsi   |   1 +
 arch/arm/boot/dts/qcom-ipq8064.dtsi        | 250 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/qcom-msm8660-surf.dts    |  30 +++++++
 arch/arm/boot/dts/qcom-msm8660.dtsi        |  42 ++++++++++
 arch/arm/boot/dts/qcom-msm8960-cdp.dts     |  15 ++++
 arch/arm/boot/dts/qcom-msm8960.dtsi        |  37 +++++++++
 arch/arm/mach-qcom/board.c                 |   2 +
 14 files changed, 659 insertions(+)
 create mode 100644 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
 create mode 100644 arch/arm/boot/dts/qcom-ipq8064-ap148.dts
 create mode 100644 arch/arm/boot/dts/qcom-ipq8064-v1.0.dtsi
 create mode 100644 arch/arm/boot/dts/qcom-ipq8064.dtsi

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation


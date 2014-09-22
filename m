Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaIVUPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:15:53 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60025 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaIVUPv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:15:51 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: [GIT PULL] qcom DT changes for v3.18-2
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <13536005-9FFF-4362-8B87-5F0DC9930D29@codeaurora.org>
Date: Mon, 22 Sep 2014 15:15:47 -0500
Cc: Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Georgi Djakov <gdjakov@mm-sol.com>,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <C891343A-AC78-4CF0-8A6A-9BF741CDA58A@codeaurora.org>
References: <13536005-9FFF-4362-8B87-5F0DC9930D29@codeaurora.org>
To: arm@kernel.org
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-dt-for-3.18-2

for you to fetch changes up to aabff7bfe55afd01d71a5f11d4a84bd873c20f5e:

  ARM: DT: msm8960: Add sdcc nodes (2014-09-22 13:49:43 -0500)

----------------------------------------------------------------
Qualcomm ARM Based Device Tree Updates for v3.18-2

* Added SDCC nodes on MSM8960/CDP and MSM8660/SURF
* Added I2C and SDCC4/WLAN on APQ8064/IFC6410
* Added I2C on MSM8984/DB8074

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

Srinivas Kandagatla (3):
      ARM: DT: apq8064: Add sdcc support via mcci driver.
      ARM: DT: QCOM: apq8064: Add dma support for sdcc node
      ARM: DT: apq8064: add support to sdcc4 for wlan.

Stephen Boyd (5):
      ARM: dts: msm: Add 8921 PMIC to ssbi bus
      ARM: dts: msm: Add 8058 PMIC to ssbi bus
      ARM: dts: qcom: Add 8064 multimedia clock controller node
      ARM: DT: msm8660: Add sdcc nodes
      ARM: DT: msm8960: Add sdcc nodes

kiran.padwal@smartplayin.com (2):
      ARM: dts: qcom: Add I2C dt node for MSM8974 and DB8074 board
      ARM: DT: apq8064: Add i2c device nodes

 arch/arm/boot/dts/Makefile                     |   2 +
 arch/arm/boot/dts/qcom-apq8064-ifc6410.dts     |  43 +++++
 arch/arm/boot/dts/qcom-apq8064.dtsi            | 183 ++++++++++++++++++
 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts |  21 +++
 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts     |  23 +++
 arch/arm/boot/dts/qcom-apq8084-mtp.dts         |   6 +
 arch/arm/boot/dts/qcom-apq8084.dtsi            |  51 +++++
 arch/arm/boot/dts/qcom-ipq8064-ap148.dts       |  85 +++++++++
 arch/arm/boot/dts/qcom-ipq8064-v1.0.dtsi       |   1 +
 arch/arm/boot/dts/qcom-ipq8064.dtsi            | 250 +++++++++++++++++++++++++
 arch/arm/boot/dts/qcom-msm8660-surf.dts        |  42 +++++
 arch/arm/boot/dts/qcom-msm8660.dtsi            |  93 +++++++++
 arch/arm/boot/dts/qcom-msm8960-cdp.dts         |  27 +++
 arch/arm/boot/dts/qcom-msm8960.dtsi            |  87 +++++++++
 arch/arm/boot/dts/qcom-msm8974.dtsi            |  15 +-
 arch/arm/mach-qcom/board.c                     |   2 +
 16 files changed, 929 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/boot/dts/qcom-apq8084-ifc6540.dts
 create mode 100644 arch/arm/boot/dts/qcom-ipq8064-ap148.dts
 create mode 100644 arch/arm/boot/dts/qcom-ipq8064-v1.0.dtsi
 create mode 100644 arch/arm/boot/dts/qcom-ipq8064.dtsi

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

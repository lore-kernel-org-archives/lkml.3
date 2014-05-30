Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469AbaE3QiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:38:23 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59646 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbaE3QiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:38:22 -0400
Date: Fri, 30 May 2014 11:38:13 -0500 (CDT)
From: Kumar Gala <galak@codeaurora.org>
X-X-Sender: galak@galak-ubuntu.qualcomm.com
To: arm@kernel.org
cc: Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [GIT PULL] qcom DT changes for v3.16-2
Message-ID: <alpine.DEB.2.00.1405301137040.5291@galak-ubuntu.qualcomm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 08f9234ad6b0b8bc51046346eabf5b92e631e62a:

   soc: qcom: Add device tree binding for GSBI (2014-05-23 11:38:53 -0500)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/galak/linux-qcom.git tags/qcom-dt-for-3.16-2

for you to fetch changes up to f46d23f6f3676720de2a3f195413a5e69f202238:

   ARM: dts: qcom: Add APQ8084-MTP board support (2014-05-29 11:16:45 -0500)

----------------------------------------------------------------
Qualcomm ARM Based Device Tree Updates for v3.16-2

* Updated MSM8660/MSM8960/MSM8974 dts for various updates or conformitity
   to binding specs
* Added APQ8064 SoC and IFC6410 board device tree support
* Added APQ8084 SoC and APQ8084-MTP board device tree support

----------------------------------------------------------------
Georgi Djakov (2):
       ARM: dts: qcom: Add APQ8084 SoC support
       ARM: dts: qcom: Add APQ8084-MTP board support

Kumar Gala (4):
       ARM: dts: qcom: Update msm8974/apq8074 device trees
       ARM: dts: qcom: Update msm8960 device trees
       ARM: dts: qcom: Update msm8660 device trees
       ARM: dts: qcom: Add initial APQ8064 SoC and IFC6410 board device trees

  arch/arm/boot/dts/Makefile                     |   9 +-
  arch/arm/boot/dts/qcom-apq8064-ifc6410.dts     |  16 +++
  arch/arm/boot/dts/qcom-apq8064-v2.0.dtsi       |   1 +
  arch/arm/boot/dts/qcom-apq8064.dtsi            | 170 +++++++++++++++++++++++
  arch/arm/boot/dts/qcom-apq8074-dragonboard.dts |  28 +++-
  arch/arm/boot/dts/qcom-apq8084-mtp.dts         |   6 +
  arch/arm/boot/dts/qcom-apq8084.dtsi            | 179 +++++++++++++++++++++++++
  arch/arm/boot/dts/qcom-msm8660-surf.dts        |  10 ++
  arch/arm/boot/dts/qcom-msm8660.dtsi            | 115 +++++++++-------
  arch/arm/boot/dts/qcom-msm8960-cdp.dts         |  10 ++
  arch/arm/boot/dts/qcom-msm8960.dtsi            | 176 +++++++++++++-----------
  arch/arm/boot/dts/qcom-msm8974.dtsi            |  49 +++----
  arch/arm/mach-qcom/board.c                     |   4 +-
  13 files changed, 612 insertions(+), 161 deletions(-)
  create mode 100644 arch/arm/boot/dts/qcom-apq8064-ifc6410.dts
  create mode 100644 arch/arm/boot/dts/qcom-apq8064-v2.0.dtsi
  create mode 100644 arch/arm/boot/dts/qcom-apq8064.dtsi
  create mode 100644 arch/arm/boot/dts/qcom-apq8084-mtp.dts
  create mode 100644 arch/arm/boot/dts/qcom-apq8084.dtsi

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

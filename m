Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaCGJn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:43:58 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:47978 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751977AbaCGJnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:43:33 -0500
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Rob Landley <rob@landley.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Maxime Coquelin <maxime.coquelin@st.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com
Cc: lee.jones@linaro.org
Subject: [PATCH v2 0/5] Add STiH407 SoC and reference board support
Date: Fri,  7 Mar 2014 10:41:07 +0100
Message-Id: <1394185272-26054-1-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds basic support to the STMicroelectronics STiH407 SoC and its
B2120 reference board. The STiH407 is a dual-core ARM Cortex-A9 CPU aimed at
STB market.

Changes since v1:
-----------------
	- Changed patch 2 commit title
	- Rebased pinctrl patches to linux-pinctrl/devel
	- Rebased ARM patches to arm_soc/for-next

Giuseppe Cavallaro (2):
  pinctrl: st: add pinctrl support for the STiH407 SoC
  pinctrl: st: Enhance the controller to manage unavailable registers

Maxime Coquelin (3):
  ARM: STi: Add STiH407 SoC support
  ARM: dts: Add STiH407 SoC support
  ARM: dts: STiH407: Add B2120 board support

 Documentation/arm/sti/stih407-overview.txt    |  18 +
 Documentation/devicetree/bindings/arm/sti.txt |  15 +
 arch/arm/boot/dts/Makefile                    |   3 +-
 arch/arm/boot/dts/stih407-b2120.dts           |  78 ++++
 arch/arm/boot/dts/stih407-clock.dtsi          |  41 ++
 arch/arm/boot/dts/stih407-pinctrl.dtsi        | 618 ++++++++++++++++++++++++++
 arch/arm/boot/dts/stih407.dtsi                | 250 +++++++++++
 arch/arm/mach-sti/Kconfig                     |   9 +
 arch/arm/mach-sti/board-dt.c                  |   1 +
 drivers/pinctrl/pinctrl-st.c                  | 123 +++--
 10 files changed, 1110 insertions(+), 46 deletions(-)
 create mode 100644 Documentation/arm/sti/stih407-overview.txt
 create mode 100644 Documentation/devicetree/bindings/arm/sti.txt
 create mode 100644 arch/arm/boot/dts/stih407-b2120.dts
 create mode 100644 arch/arm/boot/dts/stih407-clock.dtsi
 create mode 100644 arch/arm/boot/dts/stih407-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/stih407.dtsi

-- 
1.9.0


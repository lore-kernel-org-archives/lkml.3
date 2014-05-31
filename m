Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaEaPqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 11:46:20 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:44671 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaEaPqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 11:46:17 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sboyd@codeaurora.org, rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v2 0/4] clk: qcom: Add APQ8084 Global Clock Controller support
Date: Sat, 31 May 2014 18:45:30 +0300
Message-Id: <1401551134-28485-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for the global clock controller found on the
APQ8084 based platforms.

Patches 1,2 can go through clk-next and 3,4 through arm-soc.

Changes from v1:
 - Moved APQ8084 clocks into a separate file and under separate Kconfig
   entry. Dropped the override function patch from v1.
 - Added the missing information about resets (suggested by Kumar Gala).
 - Made the UART DT node "disabled" in dtsi and "okay" in dts (suggested
   by Kumar Gala)

Georgi Djakov (4):
  clk: qcom: Add APQ8084 Global Clock Controller documentation
  clk: qcom: Add APQ8084 Global Clock Controller support
  ARM: dts: qcom: Add APQ8084 Global Clock Controller DT node
  ARM: dts: qcom: Add APQ8084 serial port DT node

 .../devicetree/bindings/clock/qcom,gcc.txt         |    1 +
 arch/arm/boot/dts/qcom-apq8084-mtp.dts             |    6 +
 arch/arm/boot/dts/qcom-apq8084.dtsi                |   18 +
 drivers/clk/qcom/Kconfig                           |    8 +
 drivers/clk/qcom/Makefile                          |    1 +
 drivers/clk/qcom/gcc-apq8084.c                     | 2951 ++++++++++++++++++++
 include/dt-bindings/clock/qcom,gcc-apq8084.h       |  337 +++
 include/dt-bindings/reset/qcom,gcc-apq8084.h       |  116 +
 8 files changed, 3438 insertions(+)
 create mode 100644 drivers/clk/qcom/gcc-apq8084.c
 create mode 100644 include/dt-bindings/clock/qcom,gcc-apq8084.h
 create mode 100644 include/dt-bindings/reset/qcom,gcc-apq8084.h

-- 
1.7.9.5


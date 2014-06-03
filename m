Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbaFCOZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:25:10 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:49795 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbaFCOZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:25:09 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: mturquette@linaro.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sboyd@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v3 0/2] clk: qcom: Add APQ8084 Global Clock Controller support
Date: Tue,  3 Jun 2014 17:24:07 +0300
Message-Id: <1401805449-26499-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for the global clock controller found on the
APQ8084 based platforms.

Applies to clk-next.

Changes from v2:
 - Removed resets not belonging to gcc. (suggested by Stephen Boyd)
 - Split the DT patches into separate patchset. (suggested by Kumar Gala)

Changes from v1:
 - Moved APQ8084 clocks into a separate file and under separate Kconfig
   entry. Dropped the override function patch from v1.
 - Added the missing information about resets (suggested by Kumar Gala).
 - Made the UART DT node "disabled" in dtsi and "okay" in dts (suggested
   by Kumar Gala)

Georgi Djakov (2):
  clk: qcom: Add APQ8084 Global Clock Controller documentation
  clk: qcom: Add APQ8084 Global Clock Controller support

 .../devicetree/bindings/clock/qcom,gcc.txt         |    1 +
 drivers/clk/qcom/Kconfig                           |    8 +
 drivers/clk/qcom/Makefile                          |    1 +
 drivers/clk/qcom/gcc-apq8084.c                     | 2944 ++++++++++++++++++++
 include/dt-bindings/clock/qcom,gcc-apq8084.h       |  337 +++
 include/dt-bindings/reset/qcom,gcc-apq8084.h       |  109 +
 6 files changed, 3400 insertions(+)
 create mode 100644 drivers/clk/qcom/gcc-apq8084.c
 create mode 100644 include/dt-bindings/clock/qcom,gcc-apq8084.h
 create mode 100644 include/dt-bindings/reset/qcom,gcc-apq8084.h

-- 
1.7.9.5


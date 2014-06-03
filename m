Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbaFCO34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:29:56 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:50108 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752637AbaFCO3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:29:55 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: galak@codeaurora.org
Cc: mturquette@linaro.org, sboyd@codeaurora.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v3 0/2] ARM: dts: qcom: Add APQ8084 DT nodes for GCC and UART
Date: Tue,  3 Jun 2014 17:29:39 +0300
Message-Id: <1401805781-26637-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds DT nodes for the APQ8084 global clock controller 
and serial port.

Should go through qcom/arm-soc tree.

Changes from v2:
 - Split the DT patches into separate patchset. (suggested by Kumar Gala)

Changes from v1:
 - Moved APQ8084 clocks into a separate file and under separate Kconfig
   entry. Dropped the override function patch from v1.
 - Added the missing information about resets (suggested by Kumar Gala).
 - Made the UART DT node "disabled" in dtsi and "okay" in dts (suggested
   by Kumar Gala)


Georgi Djakov (2):
  ARM: dts: qcom: Add APQ8084 Global Clock Controller DT node
  ARM: dts: qcom: Add APQ8084 serial port DT node

 arch/arm/boot/dts/qcom-apq8084-mtp.dts |    6 ++++++
 arch/arm/boot/dts/qcom-apq8084.dtsi    |   18 ++++++++++++++++++
 2 files changed, 24 insertions(+)

-- 
1.7.9.5


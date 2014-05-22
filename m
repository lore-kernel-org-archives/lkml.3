Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751254AbaEVQZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:25:09 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:58939 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbaEVQZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:25:06 -0400
From: Georgi Djakov <gdjakov@mm-sol.com>
To: mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sboyd@codeaurora.org, rdunlap@infradead.org
Cc: linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v1 0/5] clk: gcc: Add APQ8084 Global Clock Controller support
Date: Thu, 22 May 2014 19:24:40 +0300
Message-Id: <1400775885-10296-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for the global clock controller found on the
APQ8084 based platforms.

It applies to the clk-next tree and the following patchset on top of it:
https://lkml.org/lkml/2014/5/16/666

Georgi Djakov (5):
  clk: qcom: Add APQ8084 Global Clock Controller documentation
  clk: qcom: Allow an override function to be passed as data
  clk: gcc: Add APQ8084 Global Clock Controller support
  ARM: dts: qcom: Add APQ8084 Global Clock Controller DT node
  ARM: dts: qcom: Add APQ8084 serial port DT node

 .../devicetree/bindings/clock/qcom,gcc.txt         |    1 +
 arch/arm/boot/dts/qcom-apq8084.dtsi                |   17 ++
 drivers/clk/qcom/Kconfig                           |    4 +-
 drivers/clk/qcom/gcc-msm8974.c                     |  174 ++++++++++++++++++--
 include/dt-bindings/clock/qcom,gcc-msm8974.h       |    4 +
 5 files changed, 185 insertions(+), 15 deletions(-)

-- 
1.7.9.5


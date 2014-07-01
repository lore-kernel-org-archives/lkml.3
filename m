Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaGAOb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:31:29 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:61657 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaGAOb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:31:27 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, srinivas.kandagatla@gmail.com,
        maxime.coquelin@st.com, patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH 0/3] Add reset controllers for STiH407 SoC
Date: Tue,  1 Jul 2014 15:30:44 +0100
Message-Id: <1404225047-9495-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds reset controller support for the STiH407 SoC.

Peter Griffin (3):
  drivers: reset: stih407: Add softreset, powerdown and picophy
    controllers
  ARM: sti: Add STiH407 Kconfig entry to select STIH407_RESET
  ARM: STi: STiH407: Add reset controller support.

 .../bindings/reset/st,sti-picophyreset.txt         |  41 ++++++
 arch/arm/boot/dts/stih407.dtsi                     |  16 +++
 arch/arm/mach-sti/Kconfig                          |  10 ++
 drivers/reset/sti/Kconfig                          |   4 +
 drivers/reset/sti/Makefile                         |   1 +
 drivers/reset/sti/reset-stih407.c                  | 159 +++++++++++++++++++++
 .../dt-bindings/reset-controller/stih407-resets.h  |  60 ++++++++
 7 files changed, 291 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt
 create mode 100644 drivers/reset/sti/reset-stih407.c
 create mode 100644 include/dt-bindings/reset-controller/stih407-resets.h

-- 
1.9.1


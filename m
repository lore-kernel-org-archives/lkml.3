Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaGBOJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:09:36 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:62689 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaGBOJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:09:34 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de, srinivas.kandagatla@gmail.com,
        maxime.coquelin@st.com, patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org, devicetree@vger.kernel.org
Subject: [PATCH v2 0/4] Add reset controllers for STiH407 SoC
Date: Wed,  2 Jul 2014 15:08:45 +0100
Message-Id: <1404310129-14667-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds reset controller support for the STiH407 SoC.

Changes since v1
 - Update copyright to 2014
 - Add const qualifier
 - Fix various whitespace issues
 - Remove THIS_OWNER
 - Move DT documentation into separate patch

Peter Griffin (4):
  reset: stih407: Add softreset, powerdown and picophy controllers
  reset: sti: Document sti-picophyreset controllers bindings.
  ARM: sti: Add STiH407 Kconfig entry to select STIH407_RESET
  ARM: sti: Add STiH407 reset controller support.

 .../bindings/reset/st,sti-picophyreset.txt         |  42 ++++++
 arch/arm/boot/dts/stih407.dtsi                     |  16 +++
 arch/arm/mach-sti/Kconfig                          |  10 ++
 drivers/reset/sti/Kconfig                          |   4 +
 drivers/reset/sti/Makefile                         |   1 +
 drivers/reset/sti/reset-stih407.c                  | 158 +++++++++++++++++++++
 .../dt-bindings/reset-controller/stih407-resets.h  |  61 ++++++++
 7 files changed, 292 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reset/st,sti-picophyreset.txt
 create mode 100644 drivers/reset/sti/reset-stih407.c
 create mode 100644 include/dt-bindings/reset-controller/stih407-resets.h

-- 
1.9.1


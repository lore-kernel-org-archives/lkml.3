Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbaCEDlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:41:47 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:55743 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755237AbaCEDln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:41:43 -0500
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, kernel@stlinux.com,
        Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@st.com>
Subject: [PATCH 0/5] Add ST Keyscan driver
Date: Wed,  5 Mar 2014 04:39:27 +0100
Message-Id: <1393990772-9567-1-git-send-email-gabriel.fernandez@st.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of this series is to add ST Keyscan support to ST SoCs.
The DT definition is added for STiH415 and STiH416 SoCs on
B2000 board.

Gabriel Fernandez (4):
  drivers: input: keyboard: st-keyscan: add keyscan driver
  ARM: STi: DT: add keyscan for stih416
  ARM: STi: DT: add keyscan for stih41x-b2000
  ARM: multi_v7_defconfig: add st-keyscan driver

Giuseppe CONDORELLI (1):
  ARM: STi: DT: add keyscan for stih415

 .../devicetree/bindings/input/st-keypad.txt        |  50 ++++
 arch/arm/boot/dts/stih415-pinctrl.dtsi             |  16 +
 arch/arm/boot/dts/stih415.dtsi                     |  10 +
 arch/arm/boot/dts/stih416-pinctrl.dtsi             |  16 +
 arch/arm/boot/dts/stih416.dtsi                     |  10 +
 arch/arm/boot/dts/stih41x-b2000.dtsi               |  12 +
 arch/arm/configs/multi_v7_defconfig                |   1 +
 drivers/input/keyboard/Kconfig                     |  12 +
 drivers/input/keyboard/Makefile                    |   1 +
 drivers/input/keyboard/st-keyscan.c                | 323 +++++++++++++++++++++
 10 files changed, 451 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/input/st-keypad.txt
 create mode 100644 drivers/input/keyboard/st-keyscan.c

-- 
1.9.0


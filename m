Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab3IRKEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 06:04:05 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:35683 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882Ab3IRKEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 06:04:01 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Wolfram Sang <wsa@the-dreams.de>, srinivas.kandagatla@st.com,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org
Cc: stephen.gallimore@st.com, stuart.menefy@st.com,
        Lee Jones <lee.jones@linaro.org>, gabriel.fernandez@st.com,
        olivier.clergeaud@st.com, Maxime Coquelin <maxime.coquelin@st.com>
Subject: [PATCH 0/4] Add I2C support to ST SoCs
Date: Wed, 18 Sep 2013 12:01:19 +0200
Message-Id: <1379498483-4236-1-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The goal of this series is to add I2C support to ST SoCs.
The DT definition is added for STiH415 and STiH416 SoCs on
B2000 and B2020 boards.

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>

Maxime Coquelin (4):
  i2c: busses: i2c-st: Add ST I2C controller
  ARM: STi: Supply I2C configuration to STiH416 SoC
  ARM: STi: Supply I2C configuration to STiH415 SoC
  ARM: STi: Add I2C config to B2000 and B2020 boards

 Documentation/devicetree/bindings/i2c/i2c-st.txt |   35 ++
 arch/arm/boot/dts/stih415-pinctrl.dtsi           |   36 ++
 arch/arm/boot/dts/stih415.dtsi                   |   57 ++
 arch/arm/boot/dts/stih416-pinctrl.dtsi           |   35 ++
 arch/arm/boot/dts/stih416.dtsi                   |   57 ++
 arch/arm/boot/dts/stih41x-b2000.dtsi             |    7 +
 arch/arm/boot/dts/stih41x-b2020.dtsi             |   20 +
 drivers/i2c/busses/Kconfig                       |   10 +
 drivers/i2c/busses/Makefile                      |    1 +
 drivers/i2c/busses/i2c-st.c                      |  713 ++++++++++++++++++++++
 drivers/i2c/busses/i2c-st.h                      |  216 +++++++
 11 files changed, 1187 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-st.txt
 create mode 100644 drivers/i2c/busses/i2c-st.c
 create mode 100644 drivers/i2c/busses/i2c-st.h

-- 
1.7.9.5


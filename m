Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaA3PS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 10:18:29 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:39833 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752846AbaA3PS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 10:18:28 -0500
From: Patrice CHOTARD <patrice.chotard@st.com>
To: Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Cc: maxime.coquelin@st.com, alexandre.torgue@st.com, patrice.chotard@st.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH 0/4] ARM:sti: Add STiD127 platform and board support
Date: Thu, 30 Jan 2014 15:55:40 +0100
Message-Id: <1391093744-19905-1-git-send-email-patrice.chotard@st.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrice Chotard <patrice.chotard@st.com>

This patch-set adds basic support for STMicroelectronics STiD127 
with B2112 board support. STiD127 is dual-core ARM Cortex-A9 CPU 
to function as a cable modem or in combination with a back end
as a gateway set top box.

Alexandre TORGUE (4):
  ARM: STi: add stid127 soc support
  pinctrl: st: add stid127 support
  ARM: dts: Add support of STid127 Soc.
  ARM: dts: add B2112 board support

 arch/arm/boot/dts/Makefile             |    3 +-
 arch/arm/boot/dts/stid127-b2112.dts    |   35 +++++
 arch/arm/boot/dts/stid127-clock.dtsi   |   31 ++++
 arch/arm/boot/dts/stid127-pinctrl.dtsi |  245 ++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/stid127.dtsi         |  130 +++++++++++++++++
 arch/arm/mach-sti/board-dt.c           |    6 +
 drivers/pinctrl/pinctrl-st.c           |   25 ++++
 7 files changed, 474 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/stid127-b2112.dts
 create mode 100644 arch/arm/boot/dts/stid127-clock.dtsi
 create mode 100644 arch/arm/boot/dts/stid127-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/stid127.dtsi

-- 
1.7.9.5


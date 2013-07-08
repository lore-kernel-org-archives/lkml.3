Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab3GHIZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 04:25:40 -0400
Received: from eu1sys200aog123.obsmtp.com ([207.126.144.155]:49484 "EHLO
	eu1sys200aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143Ab3GHIZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 04:25:38 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH v1 0/4] ARM: STi fixes and ethernet support
Date: Mon,  8 Jul 2013 09:15:01 +0100
Message-Id: <1373271301-11060-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch series fixes 2 configuration issues and adds ethernet support to
STiH415, STiH416 based B2000, B2020 boards.
With this patchset B2000 and B2020 can have basic ethernet support in
MII and RGMII modes.

Thanks,
srini

Srinivas Kandagatla (4):
  ARM: dts: STi: Fix pinconf setup for STiH416 serial2
  ARM: STi: Set correct ARM ERRATAs.
  ARM: STi: Add STiH415 ethernet support.
  ARM: STi: Add STiH416 ethernet support.

 arch/arm/boot/dts/stih415-pinctrl.dtsi |   82 ++++++++++++++++
 arch/arm/boot/dts/stih415.dtsi         |   34 +++++++
 arch/arm/boot/dts/stih416-pinctrl.dtsi |   92 +++++++++++++++++-
 arch/arm/boot/dts/stih416.dtsi         |   38 +++++++-
 arch/arm/boot/dts/stih41x-b2000.dtsi   |   21 ++++
 arch/arm/boot/dts/stih41x-b2020.dtsi   |   14 +++
 arch/arm/mach-sti/Kconfig              |    3 +-
 arch/arm/mach-sti/Makefile             |    2 +-
 arch/arm/mach-sti/board-dt.c           |    2 +
 arch/arm/mach-sti/stih41x.c            |  166 ++++++++++++++++++++++++++++++++
 arch/arm/mach-sti/stih41x.h            |    4 +
 11 files changed, 454 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/mach-sti/stih41x.c
 create mode 100644 arch/arm/mach-sti/stih41x.h

-- 
1.7.6.5


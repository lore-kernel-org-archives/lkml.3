Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab3GIHgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:36:12 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:37099 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753386Ab3GIHgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:36:09 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH v2 0/2] ARM: STi Fixes
Date: Tue,  9 Jul 2013 08:25:52 +0100
Message-Id: <1373354752-26292-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch series fixes 2 configuration issues related to serial
setup on STiH416 and ARM ERRATA selection.

Changes since v1:
	- Split out fixes in seperate patch set.

Srinivas Kandagatla (2):
  ARM: dts: STi: Fix pinconf setup for STiH416 serial2
  ARM: STi: Set correct ARM ERRATAs.

 arch/arm/boot/dts/stih416-pinctrl.dtsi |   10 +++++++++-
 arch/arm/boot/dts/stih416.dtsi         |    2 +-
 arch/arm/mach-sti/Kconfig              |    3 ++-
 3 files changed, 12 insertions(+), 3 deletions(-)

-- 
1.7.6.5


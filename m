Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbaIIOAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:00:17 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54057 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbaIIOAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:00:15 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [GIT PULL] ARM: dts: OMAP5 / DRA7: pinctrl updates 
Date: Tue, 9 Sep 2014 08:59:38 -0500
Message-ID: <1410271178-28336-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Tony,

Please pull this series was posted[1] and based on the previous pulls
[2] [3], updating the dts to enable the relevant feature.

NOTE: I have dropped patch #1 of the series based on [4].

These could go to your branch omap-for-v3.18/dt

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  https://github.com/nmenon/linux-2.6-playground.git pull/v3.18/for-dt-pinctrl-updates

for you to fetch changes up to 66b0436977e2c62388d48836ff784f1fedb49c4f:

  ARM: dts: dra7-evm: Mark uart1 rxd as wakeup capable (2014-09-09 08:33:29 -0500)

----------------------------------------------------------------
Nishanth Menon (5):
      ARM: dts: OMAP5: switch to compatible pinctrl
      ARM: dts: DRA7: switch to compatible pinctrl
      ARM: dts: AM437x: switch to compatible pinctrl
      ARM: dts: OMAP5 / DRA7: switch over to interrupts-extended property for UART
      ARM: dts: dra7-evm: Mark uart1 rxd as wakeup capable

 arch/arm/boot/dts/am4372.dtsi  |    4 +++-
 arch/arm/boot/dts/dra7-evm.dts |    2 ++
 arch/arm/boot/dts/dra7.dtsi    |   24 +++++++++++++-----------
 arch/arm/boot/dts/omap5.dtsi   |   20 ++++++++++++--------
 4 files changed, 30 insertions(+), 20 deletions(-)

[1] http://marc.info/?l=linux-kernel&m=140871681606779&w=2
[2] http://marc.info/?l=linux-kernel&m=141019565513129&w=2
[3] http://marc.info/?l=linux-kernel&m=141019566913133&w=2
[4] http://marc.info/?l=linux-omap&m=141022429924564&w=2

Regards,
Nishanth Menon

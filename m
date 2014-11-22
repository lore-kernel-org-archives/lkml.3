Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbaKVU0i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 15:26:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbaKVU0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 15:26:36 -0500
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org
Cc: Kukjin Kim <kgene@kernel.org>,
        =?UTF-8?q?=EA=B9=80=ED=95=99=EC=A3=BC?= <ruppi.kim@hardkernel.com>,
        Humberto Naves <hsnaves@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Johann Pfefferl <johann.pfefferl@siemens.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
Subject: [PATCH v2 0/5] ARM: EXYNOS: ODROID-XU DT and LEDs
Date: Sat, 22 Nov 2014 21:26:19 +0100
Message-Id: <1416687984-3546-1-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series adds a dedicated ODROID-XU device tree and enhances it with 
LED configuration, to match the downstream 3.14 based behavior.

Regards,
Andreas

v1 -> v2:
* Inserted needed Sobs from Hakjoo Kim
* Rebased pinctrl (.svc, .{g,w}eint_{con,mask,pend} fields dropped)

Andreas Färber (3):
  ARM: dts: exynos5410: Clean up SMDK5410 indentation
  ARM: dts: exynos5410: Prepare ODROID-XU device tree
  ARM: dts: exynos5410: Add ODROID-XU LEDs

Hakjoo Kim (2):
  pinctrl: exynos: add exynos5410 SoC specific data
  ARM: dts: add pinctrl support to Exynos5410

 .../bindings/pinctrl/samsung-pinctrl.txt           |   1 +
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/exynos5410-odroidxu.dts          | 103 ++++++
 arch/arm/boot/dts/exynos5410-pinctrl.dtsi          | 406 +++++++++++++++++++++
 arch/arm/boot/dts/exynos5410-smdk5410.dts          |   6 +-
 arch/arm/boot/dts/exynos5410.dtsi                  |  30 ++
 drivers/pinctrl/samsung/pinctrl-exynos.c           | 126 +++++++
 drivers/pinctrl/samsung/pinctrl-samsung.c          |   2 +
 drivers/pinctrl/samsung/pinctrl-samsung.h          |   1 +
 9 files changed, 673 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/boot/dts/exynos5410-odroidxu.dts
 create mode 100644 arch/arm/boot/dts/exynos5410-pinctrl.dtsi

-- 
2.1.2


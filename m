Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaG1MSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:18:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbaG1MSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:18:20 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org, Hakjoo Kim <ruppi.kim@hardkernel.com>
Cc: Tarek Dakhran <t.dakhran@samsung.com>, Kevin Hilman <khilman@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
Subject: [RFC 0/5] ARM: EXYNOS: ODROID-XU DT and LEDs
Date: Mon, 28 Jul 2014 14:18:07 +0200
Message-Id: <1406549892-5558-1-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series adds a dedicated ODROID-XU device tree and enhances it with 
LED configuration, to match the downstream 3.14 based behavior.

It had turned out less trivial than I initially thought as the whole 
pinctrl stuff is still missing. I thus cherry-pick two downstream commits.

Hakjoo, can you please reply with a Signed-off-by to your patches
so that we can get them into upstream? Thanks in advance!

Regards,
Andreas

Cc: Hakjoo Kim <ruppi.kim@hardkernel.com>

Andreas Färber (3):
  ARM: dts: exynos5410: Clean up SMDK5410 indentation
  ARM: dts: exynos5410: Prepare ODROID-XU device tree
  ARM: dts: exynos5410: Add ODROID-XU LEDs

Hakjoo Kim (2):
  pinctrl: exynos: add exynos5410 SoC specific data
  ARM: dts: add pinctrl support to Exynos5410

 .../bindings/pinctrl/samsung-pinctrl.txt           |   1 +
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/exynos5410-odroidxu.dts          | 111 ++++++
 arch/arm/boot/dts/exynos5410-pinctrl.dtsi          | 408 +++++++++++++++++++++
 arch/arm/boot/dts/exynos5410-smdk5410.dts          |   6 +-
 arch/arm/boot/dts/exynos5410.dtsi                  |  32 ++
 drivers/pinctrl/pinctrl-exynos.c                   | 126 +++++++
 drivers/pinctrl/pinctrl-samsung.c                  |   2 +
 drivers/pinctrl/pinctrl-samsung.h                  |   1 +
 9 files changed, 685 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/boot/dts/exynos5410-odroidxu.dts
 create mode 100644 arch/arm/boot/dts/exynos5410-pinctrl.dtsi

-- 
1.9.3


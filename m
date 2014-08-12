Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaHLXVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 19:21:24 -0400
Received: from mail-pa0-f73.google.com ([209.85.220.73]:60653 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaHLXVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 19:21:19 -0400
From: Doug Anderson <dianders@chromium.org>
To: Heiko Stuebner <heiko@sntech.de>, Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Addy Ke <addy.ke@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Doug Anderson <dianders@chromium.org>,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux@arm.linux.org.uk, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, galak@codeaurora.org
Subject: [PATCH v4 0/2] Add eMMC and SD card support for rk3288-evb
Date: Tue, 12 Aug 2014 16:21:12 -0700
Message-Id: <1407885674-16469-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds basic eMMC and SD card support for the rk3288-evb
board based on Addy's dw_mmc patch.

Note that we don't have regulators specified yet (no regulator driver
for rk808-based board).  We also don't yet support UHS modes or MMC
DDR50 (which require regulator support plus dw_mmc driver support for
tuning).  Those features can come later.

Changes in v4:
- Add status="disabled".
- Squash patch #1 and #4 since Jaehoon's patch landed.
- Squashed patches #2 and #3 since Jaehoon's patch landed.

Changes in v3:
- Removed DDR50 mode since it needs tuning, which isn't there yet.

Changes in v2:
- Refer to the new title of Jaehoon's patch
- New patchwork link for Addy's patch
- Squashed in the DDR50 mode since Addy spun his patch.

Doug Anderson (2):
  ARM: dts: Add emmc and sdmmc to the rk3288 device tree
  ARM: dts: Enable emmc and sdmmc on the rk3288-evb boards

 arch/arm/boot/dts/rk3288-evb.dtsi | 24 ++++++++++++++++++++++++
 arch/arm/boot/dts/rk3288.dtsi     | 20 ++++++++++++++++++++
 2 files changed, 44 insertions(+)

-- 
2.1.0.rc2.206.gedb03e5


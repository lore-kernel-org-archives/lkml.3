Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbaICUpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 16:45:32 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44907 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbaICUop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 16:44:45 -0400
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>, Addy Ke <addy.ke@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>
Cc: Alexandru Stan <amstan@chromium.org>, Sonny Rao <sonnyrao@chromium.org>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, broonie@linaro.org,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        linux-spi@vger.kernel.org, galak@codeaurora.org
Subject: [PATCH 0/3] SPI Fixes for spi-rockchip
Date: Wed,  3 Sep 2014 13:44:24 -0700
Message-Id: <1409777067-17422-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These three patches are random SPI fixes for spi-rockchip.  They are
unrelated and can be applied / NAKed separately.  They've been tested
in PIO mode on an rk3288 board (since SPI DMA isn't currently working
for some unknown reason).


Doug Anderson (3):
  spi/rockchip: Fix the wait_for_idle() timeout
  spi/rockchip: Don't warn if SPI is busy but disabled
  dt-bindings: spi/rockchip: Mark DMA as optional

 Documentation/devicetree/bindings/spi/spi-rockchip.txt | 8 ++++++--
 drivers/spi/spi-rockchip.c                             | 5 +++--
 2 files changed, 9 insertions(+), 4 deletions(-)

-- 
2.1.0.rc2.206.gedb03e5


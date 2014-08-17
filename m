Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaHQDyc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 23:54:32 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:58640 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaHQDy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 23:54:28 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] ARM: sun8i: Enable pinctrl, i2c and mmc
Date: Sun, 17 Aug 2014 11:52:06 +0800
Message-Id: <1408247538-16950-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

This series enables all the controllers on sun8i that we already have
drivers for, excluding SPI as the tablet I have does not use it and
I cannot test it. If there's a way to test it without external connections
or devices please let me know.

This series is based on 3.17-rc1, however it should cleanly apply over
the sun8i-rtc patch you've queued.

The commit logs pretty much explain themselves. Note that PLL6 is not
implemented yet. I've some patches for the clocks that I will send later.


Cheers
ChenYu


Chen-Yu Tsai (12):
  ARM: dts: sun8i: Add PIO controller node to the sun8i dtsi
  ARM: dts: sun8i: Add R_PIO controller node to the dtsi
  ARM: dts: sun8i: Add pinmux set for uart0
  ARM: dts: sun8i: Add pin muxing option for R_UART
  ARM: dts: sun8i: ippo-q8h: Add pinctrl properties for R_UART
  ARM: dts: sun8i: Add mmc clocks to the dtsi
  ARM: dts: sun8i: Add pin-muxing info for the mmc controllers
  ARM: dts: sun8i: Add mmc controller nodes
  ARM: dts: sun8i: Enable mmc controller on ippo-q8h-v5
  ARM: dts: sun8i: Add pin-muxing info for the i2c controllers
  ARM: dts: sun8i: Add i2c controller nodes
  ARM: dts: sun8i: Enable i2c controllers on ippo-q8h-v5

 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts |  41 +++++++
 arch/arm/boot/dts/sun8i-a23.dtsi            | 169 ++++++++++++++++++++++++++++
 2 files changed, 210 insertions(+)

-- 
2.1.0


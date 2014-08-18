Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaHRQv5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 12:51:57 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:35660 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbaHRQvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 12:51:55 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] ARM: sun8i: Enable pinctrl, i2c and mmc
Date: Tue, 19 Aug 2014 00:51:49 +0800
Message-Id: <1408380711-26308-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

This is v2 of the remaining sun8i series. I've dropped the patches you
merged. The remaining patches have been rebased onto sunxi-next.

This series enables all the controllers on sun8i that we already have
drivers for, excluding SPI as the tablet I have does not use it and
I cannot test it. If there's a way to test it without external connections
or devices please let me know.

The commit logs pretty much explain themselves. Note that PLL6 is not
implemented yet. I've some patches for the clocks that I will send later.


Cheers
ChenYu


Changes since v1:

  - Removed clock-frequency from i2c controller nodes, as they match
    the default value.
  - Dropped patches that were merged in v1.
  - Rebased onto sunxi-next.


Chen-Yu Tsai (2):
  ARM: dts: sun8i: Add i2c controller nodes
  ARM: dts: sun8i: Enable i2c controllers on ippo-q8h-v5

 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts | 19 +++++++++++++++++
 arch/arm/boot/dts/sun8i-a23.dtsi            | 33 +++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

-- 
2.1.0


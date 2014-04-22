Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaDVI1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:27:37 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46217 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751745AbaDVI1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:27:33 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] ARM: berlin: add SDHCI support
Date: Tue, 22 Apr 2014 10:27:26 +0200
Message-Id: <1398155248-1659-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds the Berlin BG2Q SDHCI nodes to support the 3 controllers
available. The Berlin BG2Q SDHCI controllers are compatible with the pxav3
driver. This patches also enable the SD Card reader and the eMMC of the
BG2Q DMP.

This series applies on top of Alexandre's patches for the Berlin's pll:
https://patchwork.kernel.org/patch/3890341/
https://patchwork.kernel.org/patch/3876271/

Changes since v1:
	The v2 introduced a custom Berlin SDHCI driver. It turns out the
	available pxav3 driver was compatible with the BG2Q SDHCI controllers.
	- removed the unneeded custom driver
	- switched to the pxav3 driver
	- removed the board specific properties from the SoC device tree

Antoine Ténart (2):
  ARM: dts: berlin: add the SDHCI nodes for the BG2Q
  ARM: dts: berlin: enable SD card reader and eMMC for the BG2Q DMP

 arch/arm/boot/dts/berlin2q-marvell-dmp.dts | 11 ++++++++++
 arch/arm/boot/dts/berlin2q.dtsi            | 32 ++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

-- 
1.8.3.2


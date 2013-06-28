Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab3F1NDE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:03:04 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:59951 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab3F1NDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:03:01 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>, jimwall@q.com,
        brian@crystalfontz.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv3 0/8] ARM: mxs: Various Crystalfontz DT additions
Date: Fri, 28 Jun 2013 15:02:49 +0200
Message-Id: <1372424577-8279-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series add DT for the Crystalfontz CFA-10056 and Crystalfontz
CFA-10058.

The first patch simplifies board detection in mach-mxs.c as suggested by Thomas
Petazzoni in his review of the precedent DT additions.

The next two patches are adding the DTs.

The last patches are cleaning up the remaining boards DTs.

Changes in v3
 - Cleaned up all the DTs for crystalfontz boards.

Changes in v2:
 - took into account the review from Maxime Ripard

Thanks,

Alexandre Belloni (6):
  ARM: mxs: Simplify detection of CrystalFontz boards
  ARM: mxs: dt: cfa10036: make hogpins grabbed by respective drivers
  ARM: mxs: dt: cfa10037: make hogpins grabbed by respective drivers
  ARM: mxs: dt: cfa10049: make hogpins grabbed by respective drivers
  ARM: mxs: dt: cfa10055: make hogpins grabbed by respective drivers
  ARM: mxs: dt: cfa10057: remove hogpins

Brian Lilly (2):
  ARM: mxs: dt: Add Crystalfontz CFA-10056 device tree
  ARM: mxs: dt: Add Crystalfontz CFA-10058 device tree

 arch/arm/boot/dts/Makefile           |   2 +
 arch/arm/boot/dts/imx28-cfa10036.dts |   7 +-
 arch/arm/boot/dts/imx28-cfa10037.dts |  19 +++--
 arch/arm/boot/dts/imx28-cfa10049.dts |  73 +++++++++++++++---
 arch/arm/boot/dts/imx28-cfa10055.dts |  38 ++++------
 arch/arm/boot/dts/imx28-cfa10056.dts | 120 +++++++++++++++++++++++++++++
 arch/arm/boot/dts/imx28-cfa10057.dts |  23 +-----
 arch/arm/boot/dts/imx28-cfa10058.dts | 141 +++++++++++++++++++++++++++++++++++
 arch/arm/mach-mxs/mach-mxs.c         |   5 +-
 9 files changed, 360 insertions(+), 68 deletions(-)
 create mode 100644 arch/arm/boot/dts/imx28-cfa10056.dts
 create mode 100644 arch/arm/boot/dts/imx28-cfa10058.dts

-- 
1.8.1.2


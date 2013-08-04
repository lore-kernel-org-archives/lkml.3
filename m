Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab3HDJeO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 05:34:14 -0400
Received: from up.free-electrons.com ([94.23.35.102]:36861 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752446Ab3HDJeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 05:34:13 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/6] ARM: sunxi: DTSI cleanups
Date: Sun,  4 Aug 2013 11:33:58 +0200
Message-Id: <1375608844-13159-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This small patchset removes the useless reg property in the soc bus that is not
required for the simple-bus we're using.

It also fixes the base address of this bus in the node name that was wrong from
the start.

Maxime

Maxime Ripard (6):
  ARM: sun4i: a10: Remove useless simple-bus reg property
  ARM: sun4i: dt: Fix A10 SoC bus base address
  ARM: sun5i: a10s: Remove useless simple-bus reg property
  ARM: sun5i: dt: Fix A10s SoC bus base address
  ARM: sun5i: a13: Remove useless simple-bus reg property
  ARM: sun5i: dt: Fix A13 SoC bus base address

 arch/arm/boot/dts/sun4i-a10-cubieboard.dts       | 2 +-
 arch/arm/boot/dts/sun4i-a10-hackberry.dts        | 2 +-
 arch/arm/boot/dts/sun4i-a10-mini-xplus.dts       | 2 +-
 arch/arm/boot/dts/sun4i-a10.dtsi                 | 3 +--
 arch/arm/boot/dts/sun5i-a10s-olinuxino-micro.dts | 2 +-
 arch/arm/boot/dts/sun5i-a10s.dtsi                | 3 +--
 arch/arm/boot/dts/sun5i-a13-olinuxino.dts        | 2 +-
 arch/arm/boot/dts/sun5i-a13.dtsi                 | 3 +--
 8 files changed, 8 insertions(+), 11 deletions(-)

-- 
1.8.3.4


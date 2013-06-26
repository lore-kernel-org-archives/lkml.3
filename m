Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab3FZPki (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 11:40:38 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:49307 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3FZPkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 11:40:37 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>, jimwall@q.com,
        brian@crystalfontz.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 0/3] ARM: mxs: Various Crystalfontz DT additions
Date: Wed, 26 Jun 2013 17:40:29 +0200
Message-Id: <1372261232-21051-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series add DT for the Crystalfontz CFA-10056 and Crystalfontz
CFA-10058.

The first patch simplifies board detection in mach-mxs.c as suggested by Thomas
Petazzoni in his review of the precedent DT additions.

The next patches are ading the DTs.

Changes in v2:
 - took into account the review from Maxime Ripard

Thanks,
Alexandre

Alexandre Belloni (1):
  ARM: mxs: Simplify detection of CrystalFontz boards

Brian Lilly (2):
  ARM: mxs: dt: Add Crystalfontz CFA-10056 device tree
  ARM: mxs: dt: Add Crystalfontz CFA-10058 device tree

 arch/arm/boot/dts/Makefile           |   2 +
 arch/arm/boot/dts/imx28-cfa10056.dts | 171 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/imx28-cfa10058.dts | 158 ++++++++++++++++++++++++++++++++
 arch/arm/mach-mxs/mach-mxs.c         |   5 +-
 4 files changed, 332 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/boot/dts/imx28-cfa10056.dts
 create mode 100644 arch/arm/boot/dts/imx28-cfa10058.dts

-- 
1.8.1.2


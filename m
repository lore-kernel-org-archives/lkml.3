Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030290AbaLLOvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 09:51:13 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34107 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967761AbaLLOvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 09:51:10 -0500
From: Matthias Brugger <matthias.bgg@gmail.com>
To: wim@iguana.be, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, grant.likely@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, heiko@sntech.de,
        yingjoe.chen@gmail.com, ibanezchen@gmail.com, matthias.bgg@gmail.com,
        greta.zhang@mediatek.com, eddie.huang@mediatek.com
Subject: [PATCH v2 0/2] ARM: mediatek: Add watchdog driver
Date: Fri, 12 Dec 2014 15:50:57 +0100
Message-Id: <1418395859-32209-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mediatek SoCs have a watchdog driver. This patch set adds driver and DTS
binding. The driver also implements a restart handler to reboot the SoC.

Changes for v2:
- we don't need to have the watchdog enabled to do a sotware reset
- disable dual mode and irq mode when starting the watchdog
- update commit message to name the SoCs the driver supports

Matthias Brugger (2):
  watchdog: Add driver for Mediatek watchdog
  ARM: mediatek: dts: Add bindings for watchdog

 .../devicetree/bindings/watchdog/mtk-wdt.txt       |  13 ++
 drivers/watchdog/Kconfig                           |  10 +
 drivers/watchdog/Makefile                          |   1 +
 drivers/watchdog/mtk_wdt.c                         | 257 +++++++++++++++++++++
 4 files changed, 281 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/watchdog/mtk-wdt.txt
 create mode 100644 drivers/watchdog/mtk_wdt.c

-- 
1.9.1


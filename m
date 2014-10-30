Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbaJ3DSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 23:18:15 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:36074 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752974AbaJ3DSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 23:18:13 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Oct 2014 23:18:13 EDT
X-Listener-Flag: 11101
From: <flora.fu@mediatek.com>
To: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>, <arm@kernel.org>
CC: Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/3] Add Reset Controller for MediaTek SoC 
Date: Thu, 30 Oct 2014 11:12:10 +0800
Message-ID: <1414638733-10080-1-git-send-email-flora.fu@mediatek.com>
X-Mailer: git-send-email 1.8.1.1.dirty
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver is based on 3.18-rc1. . 
This series adds support generic reset controller for MediaTek SoC.
Reset registers contain several bytes and each bit is able to reset individual module in SoC.
 - Patch 1/3: Add a driver in reset controller
 - Patch 2/3: Add device tree bindings
 - Patch 3/3: Add reset controller to MT8135 board dts
   
 Flora Fu (3):
  ARM: mediatek: Add Reset Controller for MediaTek SoC
  dt-bindings: Add Reset Controller for MediaTek SoC
  ARM: dts: mt8135: Add Reset Controller for MediaTek SoC

 .../devicetree/bindings/reset/mediatek,reset.txt   |  37 +++++
 arch/arm/boot/dts/mt8135.dtsi                      |  22 +++
 drivers/reset/Makefile                             |   1 +
 drivers/reset/reset-mtk.c                          | 149 +++++++++++++++++++++
 4 files changed, 209 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reset/mediatek,reset.txt
 create mode 100644 drivers/reset/reset-mtk.c

--
1.8.1.1.dirty



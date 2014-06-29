Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaF2Uug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 16:50:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbaF2Uue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 16:50:34 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Andreas Olofsson <andreas@adapteva.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
Subject: [PATCH 0/1] ARM: dts: zynq: Prepare Parallella
Date: Sun, 29 Jun 2014 22:50:20 +0200
Message-Id: <1404075022-28745-1-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch adds an initial device tree for the Parallella board.
UART, SD card, Ethernet are enabled.
Not yet enabled are HDMI (FPGA, ADV7513), QSPI and 2x USB.

Where I'm a bit unsure is the PHY placement; placement as subnode of the 
GEM corresponds to what was in the downstream 3.12 based device tree. It 
is a separate chip on the board though, whereas GEM is on the SoC.

Regards,
Andreas

Andreas Färber (1):
  ARM: dts: zynq: Add Parallella device tree

 arch/arm/boot/dts/Makefile            |  4 ++-
 arch/arm/boot/dts/zynq-parallella.dts | 63 +++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/zynq-parallella.dts

-- 
1.9.3


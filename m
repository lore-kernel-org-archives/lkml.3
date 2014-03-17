Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574AbaCQPGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 11:06:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58933 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932903AbaCQPGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 11:06:32 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] ARM: add initial support for the Marvell BG2-Q DMP
Date: Mon, 17 Mar 2014 16:06:25 +0100
Message-Id: <1395068788-19786-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serie adds the initial support for the Marvell BG2-Q DMP (part of the
Berlin family). SoC has nodes for cpu, l2 cache controller, interrupt
controllers, local timer, apb timers and uarts for now.

Homepage: http://www.marvell.com/digital-entertainment/armada-1500-pro/

Changes since v2:
	- removed the 'clocks' container node
	- got rid of some useless status="okay"
	- added the remaining 6 apb timers
	- added cpuclk

Changes since v1:
        - removed duplicated label and hierarchy from the Marvell BG2-Q DMP
          device tree
        - updated the memory size
        - added more information in commit logs
        - shorted nodes by address
        - fixed clocks cells config
        - renamed the Marvell BG2-Q DMP device tree
        - moved documentation changes into a single patch
        - fixed documentation typo

Antoine Ténart (3):
  ARM: dts: berlin2q: add the Marvell Armada 1500 pro
  ARM: berlin2q: add the Marvell Armada 1500 pro in the documentation
  ARM: dts: berlin2q: add the Marvell BG2-Q DMP device tree

 Documentation/arm/Marvell/README                   |   5 +
 .../devicetree/bindings/arm/marvell,berlin.txt     |   1 +
 arch/arm/boot/dts/Makefile                         |   3 +-
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts         |  28 +++
 arch/arm/boot/dts/berlin2q.dtsi                    | 210 +++++++++++++++++++++
 5 files changed, 246 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/berlin2q-marvell-dmp.dts
 create mode 100644 arch/arm/boot/dts/berlin2q.dtsi

-- 
1.8.3.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbaDVPjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:39:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49879 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756666AbaDVPiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:38:52 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, tj@kernel.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] ARM: berlin: add AHCI support
Date: Tue, 22 Apr 2014 17:38:19 +0200
Message-Id: <1398181105-19714-1-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds the support for Berlin SoCs AHCI controllers. The
controller allows to use the SATA host interface and, for example, the
eSATA port on the BG2Q.

Also enable the eSATA interface on the BG2Q DMP.

Tested on the BG2Q DMP.

Antoine Ténart (6):
  ata: ahci: add AHCI support for Berlin SoCs
  Documentation: bindings: add the berlin-achi compatible to the ahci
    platform
  ARM: berlin: add the AHCI node for the BG2Q
  ARM: berlin: enable the eSATA interface on the BG2Q DMP
  ARM: berlin: add the AHCI node for the BG2
  ARM: berlin: add the AHCI node for the BG2CD

 .../devicetree/bindings/ata/ahci-platform.txt      |   3 +-
 arch/arm/boot/dts/berlin2.dtsi                     |   7 +
 arch/arm/boot/dts/berlin2cd.dtsi                   |   7 +
 arch/arm/boot/dts/berlin2q-marvell-dmp.dts         |   5 +
 arch/arm/boot/dts/berlin2q.dtsi                    |  12 ++
 drivers/ata/Kconfig                                |   9 ++
 drivers/ata/Makefile                               |   1 +
 drivers/ata/ahci_berlin.c                          | 175 +++++++++++++++++++++
 8 files changed, 218 insertions(+), 1 deletion(-)
 create mode 100644 drivers/ata/ahci_berlin.c

-- 
1.8.3.2


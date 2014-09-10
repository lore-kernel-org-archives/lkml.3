Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaIJNhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:37:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51214 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbaIJNhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:37:36 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mugunthan V N <mugunthanvnm@ti.com>
Subject: [PATCH v2 0/2] Add DRA7xx CPSW Ethernet support in Device Tree
Date: Wed, 10 Sep 2014 19:07:25 +0530
Message-ID: <1410356247-25925-1-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding device tree entry for CPSW to make it work in Dual EMAC mode.
These patches were tested with DRA7 hwmod patches on top of linux-next.
Patches are tested on top of Nishanth's PM tree for v3.17 [1] and pushed
my tree to [2].

Did a boot test with CPSW and ping test with suspend/resume, the boot logs
on DRA7xx EVM are posted at [3]

[1] git://github.com/nmenon/linux-2.6-playground.git testing/v3.17/cpu-idle-suspend-dra7-omap5-framework
[2] git://git.ti.com/~mugunthanvnm/ti-linux-kernel/linux.git v3.17/dra7-evm-cpsw
[3] http://pastebin.ubuntu.com/8309289/

Changes from initial version:
* Dropped patch for pinoff states
* Changed pinoff state to mode15

Mugunthan V N (2):
  ARM: dts: dra7: Add CPSW and MDIO module nodes for dra7
  ARM: dts: dra7-evm: Enable CPSW and MDIO for dra7xx EVM

 arch/arm/boot/dts/dra7-evm.dts | 107 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/dra7.dtsi    |  59 +++++++++++++++++++++++
 2 files changed, 166 insertions(+)

-- 
2.1.0


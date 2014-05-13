Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbaEMIE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:04:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48955 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbaEMIE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:04:26 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mugunthan V N <mugunthanvnm@ti.com>
Subject: [PATCH 0/3] Add DRA7xx CPSW Ethernet support in Device Tree
Date: Tue, 13 May 2014 13:34:03 +0530
Message-ID: <1399968246-21166-1-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 1.9.2.459.g68773ac
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding device tree entry for CPSW to make it work in Dual EMAC mode.

DRA7 cpsw phy sel driver patch has been pulled in net-next git with the
following commit id *d415fa1b88748d664b7b6a310dd8e699d2686cf7*

Mugunthan V N (3):
  pinctrl: dra7: dt-bindings: add pin off modes for dra7 SoC
  arm/dts: dra7xx: Add CPSW and MDIO module nodes for dra7xx
  arm/dts: dra7xx: Enable CPSW and MDIO for dra7xx EVM

 arch/arm/boot/dts/dra7-evm.dts    | 103 ++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/dra7.dtsi       |  59 ++++++++++++++++++++++
 include/dt-bindings/pinctrl/dra.h |   8 +++
 3 files changed, 170 insertions(+)

-- 
1.9.2.459.g68773ac


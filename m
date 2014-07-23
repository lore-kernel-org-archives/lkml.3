Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbaGWNYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:24:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52671 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaGWNYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:24:52 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mugunthan V N <mugunthanvnm@ti.com>
Subject: [PATCH 0/3] Add DRA7xx CPSW Ethernet support in Device Tree
Date: Wed, 23 Jul 2014 18:54:39 +0530
Message-ID: <1406121882-32658-1-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 2.0.2.673.g9ab0882
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding device tree entry for CPSW to make it work in Dual EMAC mode.

These patches were tested with DRA7 hwmod patches on top of linux-next.
The patches were already reviewed [1] and has been waiting for cross bar
and hwmod to be pulled in. Now since all dependent patches has already
pulled in, so reposting the patches again.

[1] https://lkml.org/lkml/2014/5/13/89

Mugunthan V N (3):
  pinctrl: dra7: dt-bindings: add pin off modes for dra7 SoC
  arm/dts: dra7xx: Add CPSW and MDIO module nodes for dra7xx
  arm/dts: dra7xx: Enable CPSW and MDIO for dra7xx EVM

 arch/arm/boot/dts/dra7-evm.dts    | 105 ++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/dra7.dtsi       |  58 +++++++++++++++++++++
 include/dt-bindings/pinctrl/dra.h |   8 +++
 3 files changed, 171 insertions(+)

-- 
2.0.2.673.g9ab0882


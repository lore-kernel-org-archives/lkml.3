Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaIHTUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 15:20:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44494 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbaIHTUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 15:20:08 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mugunthan V N <mugunthanvnm@ti.com>
Subject: [resend PATCH 0/3] Add DRA7xx CPSW Ethernet support in Device Tree
Date: Tue, 9 Sep 2014 00:49:55 +0530
Message-ID: <1410203998-8700-1-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 2.1.0
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

Patches are tested on linux-next, the boot logs on DRA7xx EVM [2]

[1] https://lkml.org/lkml/2014/5/13/89
[2] http://slexy.org/view/s2YqO0Wj9b 

Mugunthan V N (3):
  pinctrl: dra7: dt-bindings: add pin off modes for dra7 SoC
  arm/dts: dra7xx: Add CPSW and MDIO module nodes for dra7xx
  arm/dts: dra7xx: Enable CPSW and MDIO for dra7xx EVM

 arch/arm/boot/dts/dra7-evm.dts    | 107 ++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/dra7.dtsi       |  59 +++++++++++++++++++++
 include/dt-bindings/pinctrl/dra.h |   8 +++
 3 files changed, 174 insertions(+)

-- 
2.1.0


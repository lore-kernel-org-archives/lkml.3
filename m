Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaLCNr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:47:26 -0500
Received: from lucky1.263xmail.com ([211.157.147.132]:34990 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaLCNrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:47:23 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: lyz@rock-chips.com
X-FST-TO: ulrich.prinz@googlemail.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: lyz@rock-chips.com
X-UNIQUE-TAG: <8a94fc1c1650b87cd261b211b5d3dc1c>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: LiYunzhi <lyz@rock-chips.com>
To: ulrich.prinz@googlemail.com, dianders <dianders@chromium.org>,
        heiko <heiko@sntech.de>, huangtao <huangtao@rock-chips.com>,
        wulf <wulf@rock-chips.com>, kever.yang@rock-chips.com,
        linux-usb@vger.kernel.org, kishon@ti.com, linux-kernel@vger.kernel.org,
        zyw@rock-chips.com, lyz@rock-chips.com
Subject: [PATCH] add a PHY driver Rockchip RK3288 USB2 PHY
Date: Wed,  3 Dec 2014 21:46:49 +0800
Message-Id: <1417614410-15885-1-git-send-email-lyz@rock-chips.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: lyz <lyz@rock-chips.com>

This patche to add a generic PHY driver for ROCKCHIP usb PHYs,
currently this driver can support RK3288. The RK3288 SoC have
three independent USB PHY IPs which are all configured through a
set of registers located in the GRF (general register files)
module. This driver powered off these USB PHYs and gating
their clocks when system suspend for saving power.

lyz (1):
  phy: add Rockchip RK3288 USB2 PHY driver.

 .../devicetree/bindings/phy/rockchip-usb-phy.txt   |  17 ++
 drivers/phy/Kconfig                                |   7 +
 drivers/phy/Makefile                               |   1 +
 drivers/phy/phy-rockchip-usb.c                     | 179 +++++++++++++++++++++
 4 files changed, 204 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/rockchip-usb-phy.txt
 create mode 100644 drivers/phy/phy-rockchip-usb.c

-- 
2.0.0



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaHWAQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 20:16:21 -0400
Received: from regular1.263xmail.com ([211.150.99.140]:34477 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaHWAQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 20:16:20 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: rui.zhang@intel.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <13fe9a9eff0915e85c7f8ca17c0bbc01>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: rui.zhang@intel.com, eduardo.valentin@ti.com, rdunlap@infradead.org,
        heiko@sntech.de
Cc: cf@rock-chips.com, grant.linkely@linaro.org, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, zyw@rock-chips.com, huangtao@rock-chips.com,
        xjq@rock-chips.com, addy.ke@rock-chips.com, dianders@chromium.org,
        Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH 0/2] Rockchip SoC thermal driver
Date: Sat, 23 Aug 2014 08:15:32 +0800
Message-Id: <1408752934-18318-1-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the thermal Found on Rockhip SoCs.

Caesar Wang (2):
  dt-bindings: document Rockchip thermal
  thermal: rockchip: add driver for Rockchip thermal

Tested on rk3288 Board.
 .../bindings/thermal/rockchip-thermal.txt          |   33 +
 drivers/thermal/Kconfig                            |    9 +
 drivers/thermal/Makefile                           |    1 +
 drivers/thermal/rockchip_thermal.c                 |  659 ++++++++++++++++++++
 4 files changed, 702 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
 create mode 100644 drivers/thermal/rockchip_thermal.c

-- 
1.7.9.5



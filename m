Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbaHZXm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 19:42:27 -0400
Received: from regular1.263xmail.com ([211.150.99.140]:41789 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755541AbaHZXmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 19:42:25 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <f41f77f446b181cf22b3f1def8018b19>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        grant.likely@linaro.org
Cc: robh+dt@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, dtor@chromium.org, zyw@rock-chips.com,
        addy.ke@rock-chips.com, Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v2 0/2] Rockchip soc theamal driver
Date: Wed, 27 Aug 2014 07:41:41 +0800
Message-Id: <1409096503-7081-1-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the thermal Found on Rockhip RK32 SoCs.
Tested on RK3288 SDK board.

Changes in v2:
	* address comments from Heiko Stubner:
	- fix dt-bindings in rockchip-thermal.txt
	- remove Author mark 
	- rename TSADC_XXX->TSADC_XXX,it eill ready to merge compatible other SoCs.
	- fix a identation
	- remove clk_set_rate(),it's no necessary. 
	- fix the SIMPLE_DEV_PM_OPS() function  style.

Caesar Wang (2):
  thermal: rockchip: add driver for thermal
  dt-bindings: document Rockchip thermal

 .../bindings/thermal/rockchip-thermal.txt          |   20 +
 drivers/thermal/Kconfig                            |    9 +
 drivers/thermal/Makefile                           |    1 +
 drivers/thermal/rockchip_thermal.c                 |  642 ++++++++++++++++++++
 4 files changed, 672 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
 create mode 100644 drivers/thermal/rockchip_thermal.c

-- 
1.7.9.5



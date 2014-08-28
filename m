Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbaH1BAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 21:00:13 -0400
Received: from regular1.263xmail.com ([211.150.99.132]:45702 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbaH1BAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 21:00:09 -0400
X-Greylist: delayed 91063 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Aug 2014 21:00:07 EDT
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: wxt@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: wxt@rock-chips.com
X-UNIQUE-TAG: <b4f22d6b6a7dffdaf0af345581125956>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Caesar Wang <caesar.wang@rock-chips.com>
To: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        grant.likely@linaro.org
Cc: robh+dt@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, huangtao@rock-chips.com, cf@rock-chips.com,
        dianders@chromium.org, dtor@chromium.org, zyw@rock-chips.com,
        addy.ke@rock-chips.com, dmitry.torokhov@gmail.com,
        Caesar Wang <caesar.wang@rock-chips.com>
Subject: [PATCH v3 0/4] Rockchip soc theamal driver
Date: Thu, 28 Aug 2014 08:59:18 +0800
Message-Id: <1409187562-12370-1-git-send-email-caesar.wang@rock-chips.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes in v3:(add dts configure)
        * address comments from Dmitry Torokhov and Arnd Bergmann:
        - fix clock-names in rockchip-thermal.txt
        - remove rockchip_thermal_control() in rockchip_set_mode()
        - fix some code style.
        - add dts configure.

Changes in v2:
        * address comments from Heiko Stubner:
        - fix dt-bindings in rockchip-thermal.txt
        - remove Author mark
        - rename TSADC_XXX->TSADCV2_XXX,it eill ready to merge compatible other SoCs.
        - fix a identation
        - remove clk_set_rate(),it's no necessary.
        - fix the SIMPLE_DEV_PM_OPS() function  style.

Tested On rk3288 SDK board.

Caesar Wang (4):
  thermal: rockchip: add driver for thermal
  dt-bindings: document Rockchip thermal
  ARM: dts: add main Thermal info to rk3288
  ARM: dts: enable Thermal on rk3288-evb board

 .../bindings/thermal/rockchip-thermal.txt          |  20 +
 arch/arm/boot/dts/rk3288-evb.dtsi                  |   7 +
 arch/arm/boot/dts/rk3288.dtsi                      |  18 +
 drivers/thermal/Kconfig                            |   9 +
 drivers/thermal/Makefile                           |   1 +
 drivers/thermal/rockchip_thermal.c                 | 669 +++++++++++++++++++++
 6 files changed, 724 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/thermal/rockchip-thermal.txt
 create mode 100644 drivers/thermal/rockchip_thermal.c

-- 
1.9.1



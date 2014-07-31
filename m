Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaGaUwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 16:52:06 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50257 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaGaUwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 16:52:03 -0400
From: Kever Yang <kever.yang@gmail.com>
X-Google-Original-From: Kever Yang <kever.yang@rock-chips.com>
To: Paul Zimmerman <paulz@synopsys.com>
Cc: dianders@chromium.org, heiko@sntech.de, olof@lixom.net,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, cf@rock-chips.com,
        xjq@rock-chips.com, wulf@rock-chips.com, lyz@rock-chips.com,
        hj@rock-chips.com, huangtao@rock-chips.com,
        Kever Yang <kever.yang@rock-chips.com>, devicetree@vger.kernel.org,
        Matt Porter <mporter@linaro.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        linux-usb@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 0/5] Patches to add support for Rockchip dwc2 controller
Date: Thu, 31 Jul 2014 13:51:41 -0700
Message-Id: <1406839906-14633-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches to add support for dwc2 controller found in
Rockchip processors rk3066, rk3188 and rk3288,
and enable dts for rk3288 evb.

Changes in v3:
- Moved out of pin control and sort by base address
- EHCI and HSIC move new for version 3.
- Rebase

Changes in v2:
- Split out dr_mode and rk3288 bindings.
- add compatible "snps,dwc2" bingding info
- set most parameters as driver auto-detect
- change the node name from 'dwc2' to 'usb'
- evb patch added in version 2

Doug Anderson (1):
  ARM: dts: Fix the sort ordering of EHCI and HSIC in rk3288.dtsi

Kever Yang (4):
  Documentation: dt-bindings: add dt binding info for Rockchip dwc2
  usb: dwc2: add compatible data for rockchip soc
  ARM: dts: add rk3288 dwc2 controller support
  ARM: dts: Enable USB otg and host1(dwc) on rk3288-evb

 Documentation/devicetree/bindings/usb/dwc2.txt |    3 ++
 arch/arm/boot/dts/rk3288-evb.dtsi              |    6 +++
 arch/arm/boot/dts/rk3288.dtsi                  |   61 ++++++++++++++++--------
 drivers/usb/dwc2/platform.c                    |   29 +++++++++++
 4 files changed, 78 insertions(+), 21 deletions(-)

-- 
1.7.9.5


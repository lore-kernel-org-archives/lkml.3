Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaG3BcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:32:16 -0400
Received: from regular2.263xmail.com ([211.157.152.3]:59155 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaG3BcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:32:14 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: heiko@sntech.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <192cc9e887bb8dc54333d7e2c996c573>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Kever Yang <kever.yang@rock-chips.com>
To: heiko@sntech.de, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, linux@arm.linux.org.uk,
        paulz@synopsys.com, gregkh@linuxfoundation.org, mporter@linaro.org,
        kishon@ti.com, balbi@ti.com
Cc: swarren@wwwdotorg.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        kever.yang@rock-chips.com, addy.ke@rock-chips.com, xjq@rock-chips.com,
        cf@rock-chips.com, lyz@rock-chips.com, wulf@rock-chips.com,
        dianders@chromium.org, olof@lixom.net, sonnyrao@chromium.org
Subject: [PATCH 0/4] usb: dwc2: add suport for Rockchip dwc2 controller
Date: Tue, 29 Jul 2014 18:31:09 -0700
Message-Id: <1406683873-18194-1-git-send-email-kever.yang@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <963258>
References: <963258>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This path is to add the support for dwc2 controller found ind
Rockchip processors rk3066, rk3188 and rk3288

This patch also add dr_mode for dwc2 driver.

Kever Yang (4):
  Documentation: dt-bindings: add dt binding info for Rockchip dwc2
  ARM: dts: add rk3288 dwc2 controller support
  usb: dwc2: add compatible data for rockchip soc
  usb: dwc2: add dr_mode support for dwc2

 Documentation/devicetree/bindings/usb/dwc2.txt |    5 ++++
 arch/arm/boot/dts/rk3288.dtsi                  |   20 ++++++++++++++
 drivers/usb/dwc2/core.c                        |   13 ++++++++++
 drivers/usb/dwc2/core.h                        |    2 ++
 drivers/usb/dwc2/platform.c                    |   33 ++++++++++++++++++++++++
 5 files changed, 73 insertions(+)

-- 
1.7.9.5



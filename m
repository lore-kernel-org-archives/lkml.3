Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaIWC4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:56:04 -0400
Received: from mail-pa0-f67.google.com ([209.85.220.67]:56005 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaIWC4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:56:01 -0400
From: "jinkun.hong" <jinkun.hong@rock-chips.com>
To: linux-rockchip@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org
Cc: "jinkun.hong" <jinkun.hong@rock-chips.com>
Subject: [PATCH 0/3] ARM: rk3288 : Add PM Domain support
Date: Mon, 22 Sep 2014 19:55:13 -0700
Message-Id: <1411440916-6830-1-git-send-email-jinkun.hong@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "jinkun.hong" <jinkun.hong@rock-chips.com>

Use PM Domain framework to manage the clock.
It depends on the patch:
http://www.spinics.net/lists/arm-kernel/msg360672.html


jinkun.hong (3):
  power-domain: add power domain drivers for Rockchip platform
  dt-bindings: add document of Rockchip power domain
  ARM: dts: add rk3288 power-domain node

 .../bindings/arm/rockchip/power_domain.txt         |   48 +++
 arch/arm/boot/dts/rk3288.dtsi                      |   45 +++
 arch/arm/mach-rockchip/Kconfig                     |    1 +
 arch/arm/mach-rockchip/Makefile                    |    1 +
 arch/arm/mach-rockchip/pm_domains.c                |  372 ++++++++++++++++++++
 include/dt-bindings/power-domain/rk3288.h          |   11 +
 6 files changed, 478 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/rockchip/power_domain.txt
 create mode 100644 arch/arm/mach-rockchip/pm_domains.c
 create mode 100644 include/dt-bindings/power-domain/rk3288.h

-- 
1.7.9.5


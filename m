Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaHVOCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:02:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33290 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338AbaHVOB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:01:29 -0400
From: Nishanth Menon <nm@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Tero Kristo <t-kristo@ti.com>, Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <devicetree@vger.kernel.org>, Dave Gerlach <d-gerlach@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/3] pinctrl: Add DRA7/AM437x pinctrl compatibility
Date: Fri, 22 Aug 2014 09:00:59 -0500
Message-ID: <1408716062-26055-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series are various fixes and improvements for pinctrl
for AM437x and DRA7. It also tries to add documentation for existing
pinctrl bindings for Texas Instruments' OMAP SoCs.

Functionality depends on the dts update (in series 6), PRM fixes and
the pdata quirk changes

This is part 4/6 series which eventually enables framework for
suspend-to-ram and cpuidle for OMAP5 and DRA7

Each of series is based on v3.17-rc1 and this specific series is available:
weblink: https://github.com/nmenon/linux-2.6-playground/commits/push/v3.17/pinctrl-compat

git repo: https://github.com/nmenon/linux-2.6-playground.git push/v3.17/pinctrl-compat

An complete integrated branch is available here: https://github.com/nmenon/linux-2.6-playground/commits/testing/v3.17/cpu-idle-suspend-dra7-omap5-framework

Keerthy (1):
  pinctrl: single: AM437x: Add pinctrl compatibility

Nishanth Menon (2):
  pinctrl: bindings: Add OMAP pinctrl binding
  pinctrl: single: Add DRA7 pinctrl compatibility

 .../bindings/pinctrl/ti,omap-pinctrl.txt           |   11 +++++++++++
 drivers/pinctrl/pinctrl-single.c                   |   14 ++++++++++++++
 2 files changed, 25 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/ti,omap-pinctrl.txt

-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab3LKKWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 05:22:16 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34323 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab3LKKWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 05:22:11 -0500
From: Nishanth Menon <nm@ti.com>
To: <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/2] net: smc91x: add DT flags for legacy platforms
Date: Wed, 11 Dec 2013 04:21:43 -0600
Message-ID: <1386757305-12545-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

SMC91x driver has been converted to device tree, however users of
older lan91c94 based platform need description provided previously by
platform_data. Without this, ethernet fails to function on these platforms.

For example, on SDP2430:
Before: http://pastebin.mozilla.org/3753793
After: http://pastebin.mozilla.org/3753792

Nishanth Menon (2):
  net: smc91x: Read hardware behavior flags from device tree
  ARM: dts: omap2430-sdp: add flags for ethernet functionality

 Documentation/devicetree/bindings/net/smsc91x.txt |   45 +++++++++
 arch/arm/boot/dts/omap2430-sdp.dts                |    5 +
 drivers/net/ethernet/smsc/smc91x.c                |  106 ++++++++++++++++++++-
 3 files changed, 155 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/smsc91x.txt

Regards,
Nishanth Menon
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761819Ab3JPUVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:21:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48783 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761422Ab3JPUVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:21:34 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Rajendra Nayak <rnayak@ti.com>, Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 0/2] ARM: dts: OMAP2+: add i2c aliases
Date: Wed, 16 Oct 2013 15:21:02 -0500
Message-ID: <1381954864-24410-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <525E8D91.5090400@ti.com>
References: <525E8D91.5090400@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add i2c aliases for OMAP and AM processor dts nodes to ensure proper
i2c ordering. Based on Benoit's for_13/dts branch[1]

Changes in V2:
	- Following Rajendra's suggestion, done for all OMAP and AM
	  series SoCs, where i2c is defined.

V1: https://patchwork.kernel.org/patch/3046671/

Nishanth Menon (2):
  ARM: dts: OMAP3+: Add i2c aliases
  ARM: dts: AM33xx+: Add i2c aliases

 arch/arm/boot/dts/am33xx.dtsi |    3 +++
 arch/arm/boot/dts/am4372.dtsi |    3 +++
 arch/arm/boot/dts/dra7.dtsi   |    5 +++++
 arch/arm/boot/dts/omap3.dtsi  |    3 +++
 arch/arm/boot/dts/omap4.dtsi  |    4 ++++
 arch/arm/boot/dts/omap5.dtsi  |    5 +++++
 6 files changed, 23 insertions(+)

[1] https://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/log/?h=for_3.13/dts

-- 
1.7.9.5


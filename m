Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaA2STv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:19:51 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50281 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbaA2STo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:19:44 -0500
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Tero Kristo <t-kristo@ti.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/2] ARM: dts/OMAP: add cpu clock nodes
Date: Wed, 29 Jan 2014 12:19:15 -0600
Message-ID: <1391019557-22313-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add clock nodes for all existing OMAP platforms where cpufreq-cpu0
can be used.

Sanity tested with linux next-20140128 tag, applies on
master 0e47c96 Merge tag 'for-linus-20140127' of git://git.infradead.org/linux-mtd

Ofcourse, I have send 7 different versions[1] previously, so I will start from
version 1 again considering that I have finally based on master.

If folks feel that the clock nodes must be split out into various platforms, I
can regenerate the series again.

Nishanth Menon (2):
  clk: ti: am335x: remove unecessary cpu0 clk node
  ARM: dts: OMAP3+: add clock nodes for CPU

 arch/arm/boot/dts/am33xx.dtsi |    4 ++++
 arch/arm/boot/dts/am4372.dtsi |    5 +++++
 arch/arm/boot/dts/dra7.dtsi   |    5 +++++
 arch/arm/boot/dts/omap3.dtsi  |    5 +++++
 arch/arm/boot/dts/omap4.dtsi  |    5 +++++
 arch/arm/boot/dts/omap5.dtsi  |    6 ++++++
 drivers/clk/ti/clk-33xx.c     |    1 -
 7 files changed, 30 insertions(+), 1 deletion(-)

[1] Last version of the patch series was posted here:
	http://marc.info/?l=linux-omap&m=138245695726479&w=2
-- 
1.7.9.5

Regards,
Nishanth Menon

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541Ab3HNIfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 04:35:55 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:35305 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab3HNIfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 04:35:53 -0400
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: bcousson@baylibre.com
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uri.y@variscite.com, nm@ti.com
Subject: [PATCH v2 0/2] omap4/twl6030: typical connection to omap4 as a separate dtsi file
Date: Wed, 14 Aug 2013 11:35:46 +0300
Message-Id: <1376469348-10797-1-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

There is no functional changes between v1 and v2 - just
added the patch for omap4-var-som - Uri Yosef confirmed
this board have the same connection of OMAP4<->TWL6030 as
SDP4430 board

Ruslan Bilovol (2):
  arm: dts: twl6030: typical connection to omap4 as a separate dtsi
    file
  arm: dts: omap4: configure connection to PMIC on Variscite's SOM

 arch/arm/boot/dts/omap4-panda-common.dtsi |   21 +---------------
 arch/arm/boot/dts/omap4-sdp.dts           |   21 +---------------
 arch/arm/boot/dts/omap4-var-som.dts       |    1 +
 arch/arm/boot/dts/twl6030_omap4.dtsi      |   38 +++++++++++++++++++++++++++++
 4 files changed, 41 insertions(+), 40 deletions(-)
 create mode 100644 arch/arm/boot/dts/twl6030_omap4.dtsi

-- 
1.7.9.5


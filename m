Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab3BRMzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 07:55:04 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:58276 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab3BRMmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 07:42:13 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: linux@arm.linux.org.uk, b-cousson@ti.com, tony@atomide.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 0/1] ARM: DTS: OMAP4: Add OMAP4 Blaze Tablet support
Date: Mon, 18 Feb 2013 14:41:56 +0200
Message-Id: <1361191317-24988-1-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch is a second attempt to add basic support of OMAP4 Blaze Tablet
software development platform - in this case using only Device Tree.

Additional information about this platform can be found here:
http://www.svtronics.com/omap?product_id=15

Ruslan Bilovol (1):
  ARM: DTS: OMAP4: Add OMAP4 Blaze Tablet support

 arch/arm/boot/dts/Makefile              |    1 +
 arch/arm/boot/dts/omap4-blazetablet.dts |  390 +++++++++++++++++++++++++++++++
 2 files changed, 391 insertions(+)
 create mode 100644 arch/arm/boot/dts/omap4-blazetablet.dts

-- 
1.7.9.5


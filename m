Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647Ab3B0Lnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 06:43:49 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:33051 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414Ab3B0Lnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 06:43:47 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: linux@arm.linux.org.uk, b-cousson@ti.com, tony@atomide.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH RESEND 0/1] ARM: DTS: OMAP4: Add OMAP4 Blaze Tablet support
Date: Wed, 27 Feb 2013 13:43:41 +0200
Message-Id: <1361965422-28057-1-git-send-email-ruslan.bilovol@ti.com>
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


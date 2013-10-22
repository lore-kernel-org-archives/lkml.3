Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab3JVWuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 18:50:16 -0400
Received: from ring0.de ([91.143.88.219]:38620 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755167Ab3JVWuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 18:50:10 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: lkml.org]
From: Sebastian Reichel <sre@debian.org>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@debian.org>
Subject: [PATCH 00/14] DTS: ARM: OMAP3-N900: Add misc. HW
Date: Wed, 23 Oct 2013 00:49:29 +0200
Message-Id: <1382482183-14426-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds misc. hardware elements to the Nokia N900 DTS
file. Apart from the last two patches the kernel drivers in 3.12
are already capable of handling the DT entries.

The series is based on bcousson/linux-omap-dt.git:for_3.13/dts.

Additional notes:

* LP5523 support depends on [0], which goes through the
  Bryan Wu's tree.
* TWL4030 supports depends on [1], which is not yet queued.
* Apart from those two I did not include any patches, which
  also need changes in the drivers.

[0] https://lkml.org/lkml/2013/10/22/166
[1] https://lkml.org/lkml/2013/10/22/147

-- Sebastian

Sebastian Reichel (14):
  DTS: ARM: OMAP3-N900: Add pinctrl for i2c devices
  DTS: ARM: OMAP3-N900: Fix i2c bus speed
  DTS: ARM: OMAP3-N900: Add UART support
  DTS: ARM: OMAP3-N900: Add support for SD cards
  DTS: ARM: OMAP3-N900: GPIO key definitions
  DTS: ARM: OMAP3-N900: Add vibrator device
  DTS: ARM: OMAP3-N900: Add LP5523 support
  DTS: TWL4030: Add missing regulators
  DTS: ARM: OMAP3-N900: Specify regulator info
  DTS: ARM: OMAP3-N900: Add NAND support
  DTS: ARM: OMAP3-N900: Mux RX51_LCD_RESET_GPIO in DTS
  DTS: ARM: OMAP3-N900: Add TLV320AIC3X support
  DTS: ARM: OMAP3-N900: Add LP5523 support
  DTS: TWL4030: Add power button support

 arch/arm/boot/dts/omap3-n900.dts | 396 ++++++++++++++++++++++++++++++++++++++-
 arch/arm/boot/dts/twl4030.dtsi   |  49 ++++-
 2 files changed, 438 insertions(+), 7 deletions(-)

-- 
1.8.4.rc3


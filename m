Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3JVMrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 08:47:36 -0400
Received: from ring0.de ([91.143.88.219]:35970 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635Ab3JVMrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:47:31 -0400
X-Spam-Report: * -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, linux-input@vger.kernel.org
Cc: =?UTF-8?q?=27Beno=C3=AEt=20Cousson=27?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCHv2 0/3] Add Nokia N900 DT support
Date: Tue, 22 Oct 2013 14:47:19 +0200
Message-Id: <1382446042-27099-1-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree support for the Nokia N900 keyboard.

Changes since v1:
 * create "DTS: ARM: TWL4030: Add keypad node" patch, which
   was part of "Input: twl4030-keypad - add device tree support"
   before.
 * use "IS_ENABLED(CONFIG_OF)" to check if DT is enabled

Currently non-DT boot crashes for me very early, so I was not able
to check this patch using non-DT boot.

-- Sebastian

Sebastian Reichel (3):
  Input: twl4030-keypad - add device tree support
  DTS: ARM: TWL4030: Add keypad node
  ARM: dts: N900: TWL4030 Keypad Matrix definition

 .../devicetree/bindings/input/twl4030-keypad.txt   | 31 ++++++++
 arch/arm/boot/dts/omap3-n900.dts                   | 55 +++++++++++++
 arch/arm/boot/dts/twl4030.dtsi                     |  7 ++
 drivers/input/keyboard/twl4030_keypad.c            | 91 ++++++++++++++++++----
 4 files changed, 167 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/twl4030-keypad.txt

-- 
1.8.4.rc3


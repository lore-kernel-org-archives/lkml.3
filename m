Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbbA1VUD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:20:03 -0500
Received: from mail-oi0-f54.google.com ([209.85.218.54]:45976 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762141AbbA1UuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:20 -0500
From: Rob Herring <robh@kernel.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>
Subject: [PATCH 0/3] Versatile AB/PB clocksource support
Date: Wed, 28 Jan 2015 11:56:29 -0600
Message-Id: <1422467792-2065-1-git-send-email-robh@kernel.org>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Versatile clocksource driver can also be used on Versatile AB and PB 
platforms, not just Versatile Express. This series adds support for 
those boards.

I've split this off from the rest of the Versatile DT and 
multi-platform support as I'm not going to get it in place for 3.20. 
This part is fairly trivial and is ready to go.

Daniel, Can you please take the whole series.

Rob

Rob Herring (3):
  dt/bindings: Add binding for Versatile system registers
  clocksource: versatile: adapt for Versatile AB and PB boards
  dts: versatile: add sysregs node

 Documentation/devicetree/bindings/arm/versatile-sysreg.txt | 10 ++++++++++
 arch/arm/boot/dts/versatile-ab.dts                         |  5 +++++
 drivers/clocksource/versatile.c                            |  4 +++-
 3 files changed, 18 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/arm/versatile-sysreg.txt

-- 
2.1.0


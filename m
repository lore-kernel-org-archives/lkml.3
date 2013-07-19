Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451Ab3GSLNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 07:13:16 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:59755 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3GSLNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 07:13:15 -0400
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org, john.stultz@linaro.org,
        tglx@linutronix.de, u.kleine-koenig@pengutronix.de,
        tomasz.figa@gmail.com, linus.walleij@linaro.org,
        thomas.petazzoni@free-electrons.com, arnd@arndb.de,
        daniel.lezcano@linaro.org, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH] ARM: clocksource: moxart: documentation: update device tree bindings document
Date: Fri, 19 Jul 2013 13:12:59 +0200
Message-Id: <1374232379-20900-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1374048297-4321-1-git-send-email-jonas.jensen@gmail.com>
References: <1374048297-4321-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update device tree bindings document with the correct clock name.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Hi Daniel,
    
    I apologize in advance if this causes trouble..
    
    One of the device tree bindings files you merged
    git://git.linaro.org/people/dlezcano/clockevents.git timers/clockevents-next
    now needs an update.
    
    This patch can be applied directly to timers/clockevents-next.
    
    Best regards,
    Jonas

 Documentation/devicetree/bindings/timer/moxa,moxart-timer.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/timer/moxa,moxart-timer.txt b/Documentation/devicetree/bindings/timer/moxa,moxart-timer.txt
index 77c4cfa..ad0bf7f 100644
--- a/Documentation/devicetree/bindings/timer/moxa,moxart-timer.txt
+++ b/Documentation/devicetree/bindings/timer/moxa,moxart-timer.txt
@@ -5,7 +5,7 @@ Required properties:
 - compatible : Should be "moxa,moxart-timer"
 - reg : Should contain registers location and length
 - interrupts : Should contain the timer interrupt number
-- clocks : Should contain phandle for APB clock "clkapb"
+- clocks : Should contain phandle for the MOXA ART core clock "coreclk"
 
 Example:
 
@@ -13,5 +13,5 @@ Example:
 		compatible = "moxa,moxart-timer";
 		reg = <0x98400000 0x42>;
 		interrupts = <19 1>;
-		clocks = <&clkapb>;
+		clocks = <&coreclk>;
 	};
-- 
1.8.2.1


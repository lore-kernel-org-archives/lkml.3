Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaLEStu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 13:49:50 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:53959 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaLEStt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 13:49:49 -0500
From: Doug Anderson <dianders@chromium.org>
To: Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Shinya Kuribayashi <skuribay@pobox.com>
Cc: Christian Ruppert <christian.ruppert@abilis.com>,
        Addy Ke <addy.ke@rock-chips.com>,
        Doug Anderson <dianders@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: designware: Fix falling time bindings doc
Date: Fri,  5 Dec 2014 10:49:39 -0800
Message-Id: <1417805379-8999-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In (6468276 i2c: designware: make SCL and SDA falling time
configurable) new device tree properties were added for setting the
falling time of SDA and SCL.  The device tree bindings doc had a typo
in it: it forgot the "-ns" suffix for both properies in the prose of
the bindings.

I assume this is a typo because:
* The source code includes the "-ns"
* The example in the bindings includes the "-ns".

Fix the typo.

Signed-off-by: Doug Anderson <dianders@chromium.org>
Fixes: 6468276b2206 ("i2c: designware: make SCL and SDA falling time configurable")
---
 Documentation/devicetree/bindings/i2c/i2c-designware.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-designware.txt b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
index 5199b0c..fee26dc 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-designware.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-designware.txt
@@ -14,10 +14,10 @@ Optional properties :
  - i2c-sda-hold-time-ns : should contain the SDA hold time in nanoseconds.
    This option is only supported in hardware blocks version 1.11a or newer.
 
- - i2c-scl-falling-time : should contain the SCL falling time in nanoseconds.
+ - i2c-scl-falling-time-ns : should contain the SCL falling time in nanoseconds.
    This value which is by default 300ns is used to compute the tLOW period.
 
- - i2c-sda-falling-time : should contain the SDA falling time in nanoseconds.
+ - i2c-sda-falling-time-ns : should contain the SDA falling time in nanoseconds.
    This value which is by default 300ns is used to compute the tHIGH period.
 
 Example :
-- 
2.2.0.rc0.207.ga3a616c


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaFWBXL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:23:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35104 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbaFWBXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:23:08 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-samsung-soc@vger.kernel.org
Cc: Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/4] Documentation: devicetree: Fix s2mps11 and s5m8767 typos
Date: Mon, 23 Jun 2014 03:21:19 +0200
Message-Id: <1403486483-4063-2-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403486483-4063-1-git-send-email-afaerber@suse.de>
References: <1403486483-4063-1-git-send-email-afaerber@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's LDO2, not LD02.

Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 Documentation/devicetree/bindings/mfd/s2mps11.txt                 | 2 +-
 Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
index d81ba30..55ab4f4 100644
--- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
+++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
@@ -81,7 +81,7 @@ as per the datasheet of s2mps11.
 		  - valid values for n are:
 			- S2MPS11: 1 to 38
 			- S2MPS14: 1 to 25
-		  - Example: LDO1, LD02, LDO28
+		  - Example: LDO1, LDO2, LDO28
 	- BUCKn
 		  - valid values for n are:
 			- S2MPS11: 1 to 10
diff --git a/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt b/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
index d290988..2019131 100644
--- a/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/s5m8767-regulator.txt
@@ -86,7 +86,7 @@ as per the datasheet of s5m8767.
 
 	- LDOn
 		  - valid values for n are 1 to 28
-		  - Example: LDO1, LD02, LDO28
+		  - Example: LDO1, LDO2, LDO28
 	- BUCKn
 		  - valid values for n are 1 to 9.
 		  - Example: BUCK1, BUCK2, BUCK9
-- 
1.9.3


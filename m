Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794Ab3E1JcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 05:32:18 -0400
Received: from multi.imgtec.com ([194.200.65.239]:55911 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933724Ab3E1JcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 05:32:16 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>, Rob Landley <rob@landley.net>
Subject: [PATCH] Documentation/pinctrl.txt: fix typo "with with"
Date: Tue, 28 May 2013 10:31:48 +0100
Message-ID: <1369733508-21392-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_05_28_10_32_14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo in "communicate directly with with the pinctrl subsystem".

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Landley <rob@landley.net>
---
 Documentation/pinctrl.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index 447fd4c..f6e664b 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -1226,8 +1226,8 @@ setting up the config and muxing for the pins right before the device is
 probing, nevertheless orthogonal to the GPIO subsystem.
 
 But there are also situations where it makes sense for the GPIO subsystem
-to communicate directly with with the pinctrl subsystem, using the latter
-as a back-end. This is when the GPIO driver may call out to the functions
+to communicate directly with the pinctrl subsystem, using the latter as a
+back-end. This is when the GPIO driver may call out to the functions
 described in the section "Pin control interaction with the GPIO subsystem"
 above. This only involves per-pin multiplexing, and will be completely
 hidden behind the gpio_*() function namespace. In this case, the driver
-- 
1.8.1.2



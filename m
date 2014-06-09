Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbaFIIcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:32:24 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7599 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbaFIIcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:32:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Jun 2014 01:23:48 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <lee.jones@linaro.org>
CC: <swarren@nvidia.com>, <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dwillemsen@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] dt-binding: mfd: as3722: correct macro name
Date: Mon, 9 Jun 2014 14:01:59 +0530
Message-ID: <1402302719-9766-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro name for enable3 pin is named as AS3722_EXT_CONTROL_PIN_ENABLE2
which is conflict with the enable2 pin.

Correct this macro name to correctly reflect the enable pin i.e.
AS3722_EXT_CONTROL_PIN_ENABLE3.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reported-by: Dan Willemsen <dwillemsen@nvidia.com>
---
 include/dt-bindings/mfd/as3722.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/dt-bindings/mfd/as3722.h b/include/dt-bindings/mfd/as3722.h
index 0e69256..e66c089 100644
--- a/include/dt-bindings/mfd/as3722.h
+++ b/include/dt-bindings/mfd/as3722.h
@@ -13,7 +13,7 @@
 /* External control pins */
 #define AS3722_EXT_CONTROL_PIN_ENABLE1 1
 #define AS3722_EXT_CONTROL_PIN_ENABLE2 2
-#define AS3722_EXT_CONTROL_PIN_ENABLE2 3
+#define AS3722_EXT_CONTROL_PIN_ENABLE3 3
 
 /* Interrupt numbers for AS3722 */
 #define AS3722_IRQ_LID			0
-- 
1.8.1.5


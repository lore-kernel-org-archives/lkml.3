Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbaEGNDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:03:54 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:35083 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850AbaEGNDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:03:52 -0400
From: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
To: robh+dt@kernel.org
Cc: devicetree@vger.kernel.org,
        =?UTF-8?q?Ezequiel=20Garc=C3=ADa?= <ezequiel@vanguardiasur.com.ar>,
        dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>
Subject: [RFC/PATCH 2/3] DT: input: adp5589: add adp5589 include file
Date: Wed,  7 May 2014 10:00:43 -0300
Message-Id: <1399467644-27222-3-git-send-email-guido@vanguardiasur.com.ar>
X-Mailer: git-send-email 2.0.0.rc0
In-Reply-To: <1399467644-27222-1-git-send-email-guido@vanguardiasur.com.ar>
References: <1399467644-27222-1-git-send-email-guido@vanguardiasur.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add include file with macros ADP_COL and ADP_ROW, used to specify pull
configuration for the adp5589.

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
---
 include/dt-bindings/input/adp5589.h | 7 +++++++
 1 file changed, 7 insertions(+)
 create mode 100644 include/dt-bindings/input/adp5589.h

diff --git a/include/dt-bindings/input/adp5589.h b/include/dt-bindings/input/adp5589.h
new file mode 100644
index 0000000..5285003
--- /dev/null
+++ b/include/dt-bindings/input/adp5589.h
@@ -0,0 +1,7 @@
+#ifndef _DT_BINDINGS_INPUT_ADP5589_H
+#define _DT_BINDINGS_INPUT_ADP5589_H
+
+#define ADP_ROW(x)	(1 << (x))
+#define ADP_COL(x)	(1 << (8+(x)))
+
+#endif
-- 
2.0.0.rc0


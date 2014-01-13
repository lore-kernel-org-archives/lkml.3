Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbaAMROE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:14:04 -0500
Received: from smtp48.i.mail.ru ([94.100.177.108]:39723 "EHLO smtp48.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737AbaAMROA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:14:00 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-input@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] input: Add commonly used event types
Date: Mon, 13 Jan 2014 21:13:56 +0400
Message-Id: <1389633236-25917-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds commonly used event types (EV_KEY and EV_SW) to
devicetree bindings header for input subsystem.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 include/dt-bindings/input/input.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/dt-bindings/input/input.h b/include/dt-bindings/input/input.h
index 042e7b3..3a141d92 100644
--- a/include/dt-bindings/input/input.h
+++ b/include/dt-bindings/input/input.h
@@ -9,6 +9,9 @@
 #ifndef _DT_BINDINGS_INPUT_INPUT_H
 #define _DT_BINDINGS_INPUT_INPUT_H
 
+#define EV_KEY			0x01
+#define EV_SW			0x05
+
 #define KEY_RESERVED		0
 #define KEY_ESC			1
 #define KEY_1			2
-- 
1.8.3.2


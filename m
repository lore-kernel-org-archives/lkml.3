Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaLCVqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 16:46:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43451 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbaLCVqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 16:46:40 -0500
From: Borislav Petkov <bp@alien8.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] firmware: Correct function name in comment
Date: Wed,  3 Dec 2014 22:46:37 +0100
Message-Id: <1417643197-16986-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Use the correct function name in the kernel-doc comment above it.

Cc: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/base/firmware_class.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 3d785ebb48d3..23d19a680524 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -1195,7 +1195,7 @@ request_firmware(const struct firmware **firmware_p, const char *name,
 EXPORT_SYMBOL(request_firmware);
 
 /**
- * request_firmware: - load firmware directly without usermode helper
+ * request_firmware_direct: - load firmware directly without usermode helper
  * @firmware_p: pointer to firmware image
  * @name: name of firmware file
  * @device: device for which firmware is being loaded
-- 
2.0.0


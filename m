Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab3HPKqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 06:46:53 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:36167 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab3HPKqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 06:46:48 -0400
From: Jens Frederich <jfrederich@gmail.com>
To: gregkh@linuxfoundation.com
Cc: dsd@laptop.org, jon.nettleton@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jens Frederich <jfrederich@gmail.com>
Subject: [PATCH] Staging: olpc_dcon: fix typo in olpc_dcon.h
Date: Fri, 16 Aug 2013 12:46:32 +0200
Message-Id: <1376649992-6127-1-git-send-email-jfrederich@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The backlight brightness register (DCON_REG_BRIGHT) address is 0xa.

Signed-off-by: Jens Frederich <jfrederich@gmail.com>

diff --git a/drivers/staging/olpc_dcon/olpc_dcon.h b/drivers/staging/olpc_dcon/olpc_dcon.h
index 524ee49..e2663b1 100644
--- a/drivers/staging/olpc_dcon/olpc_dcon.h
+++ b/drivers/staging/olpc_dcon/olpc_dcon.h
@@ -30,7 +30,7 @@
 #define DCON_REG_VSYNC_WIDTH	0x7
 #define DCON_REG_TIMEOUT	0x8
 #define DCON_REG_SCAN_INT	0x9
-#define DCON_REG_BRIGHT		0x10
+#define DCON_REG_BRIGHT		0xa
 #define DCON_REG_MEM_OPT_A	0x41
 #define DCON_REG_MEM_OPT_B	0x42
 
-- 
1.7.9.5


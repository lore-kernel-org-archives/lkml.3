Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3JUFUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 01:20:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35564 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752094Ab3JUFT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 01:19:59 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: jon.mason@intel.com
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] NTB: remove duplicate defines
Date: Mon, 21 Oct 2013 07:19:42 +0200
Message-Id: <1382332782-5686-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate defines in drivers/ntb/ntb_regs.h

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/ntb/ntb_regs.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ntb/ntb_regs.h b/drivers/ntb/ntb_regs.h
index aa4bdd3..caa5975 100644
--- a/drivers/ntb/ntb_regs.h
+++ b/drivers/ntb/ntb_regs.h
@@ -75,9 +75,6 @@
 #define SNB_SBAR2XLAT_OFFSET	0x0030
 #define SNB_SBAR4XLAT_OFFSET	0x0038
 #define SNB_SBAR0BASE_OFFSET	0x0040
-#define SNB_SBAR0BASE_OFFSET	0x0040
-#define SNB_SBAR2BASE_OFFSET	0x0048
-#define SNB_SBAR4BASE_OFFSET	0x0050
 #define SNB_SBAR2BASE_OFFSET	0x0048
 #define SNB_SBAR4BASE_OFFSET	0x0050
 #define SNB_NTBCNTL_OFFSET	0x0058
-- 
1.8.1.2


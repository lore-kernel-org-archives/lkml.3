Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175AbaFLXFp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:05:45 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:64126 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaFLXFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:05:44 -0400
From: Nick <xerofoify@gmail.com>
X-Google-Original-From: Nick <nickkrause@sympatico.ca>
To: martyn.welch@ge.com
Cc: manohar.vanga@gmail.com, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nicholas Krause <xerofoify@gmail.com>
Subject: Patch[Fixes marco definition for if statements that use marco CA91CX42_LM_CTL_AS_A16 in header file,vme_ca91cx42.h]
Date: Thu, 12 Jun 2014 19:05:35 -0400
Message-Id: <1402614335-5708-1-git-send-email-nickkrause@sympatico.ca>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/vme/bridges/vme_ca91cx42.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vme/bridges/vme_ca91cx42.h b/drivers/vme/bridges/vme_ca91cx42.h
index 02a7c79..57e942f 100644
--- a/drivers/vme/bridges/vme_ca91cx42.h
+++ b/drivers/vme/bridges/vme_ca91cx42.h
@@ -549,7 +549,7 @@ static const int CA91CX42_LINT_LM[] = { CA91CX42_LINT_LM0, CA91CX42_LINT_LM1,
 #define CA91CX42_LM_CTL_SUPR		(1<<21)
 #define CA91CX42_LM_CTL_NPRIV		(1<<20)
 #define CA91CX42_LM_CTL_AS_M		(5<<16)
-#define CA91CX42_LM_CTL_AS_A16		0
+#define CA91CX42_LM_CTL_AS_A16		(3<<16)
 #define CA91CX42_LM_CTL_AS_A24		(1<<16)
 #define CA91CX42_LM_CTL_AS_A32		(1<<17)
 
-- 
1.9.1


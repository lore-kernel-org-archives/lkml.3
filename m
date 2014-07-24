Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbaGXDXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 23:23:14 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:49420 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463AbaGXDXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 23:23:12 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ashley@eclipso.ch, navinp@cdac.in, peter.p.waskiewicz.jr@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: Fix space issues for header of headers.h
Date: Wed, 23 Jul 2014 23:23:08 -0400
Message-Id: <1406172188-6103-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the space errors checkpatch gives on this file
for the header of this file.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/staging/bcm/headers.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/bcm/headers.h b/drivers/staging/bcm/headers.h
index 6f3270c..af5b6df 100644
--- a/drivers/staging/bcm/headers.h
+++ b/drivers/staging/bcm/headers.h
@@ -1,6 +1,6 @@
 
 /*******************************************************************
-* 		Headers.h
+* Headers.h
 *******************************************************************/
 #ifndef __HEADERS_H__
 #define __HEADERS_H__
-- 
1.9.1


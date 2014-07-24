Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935051AbaGXXHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:07:51 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:33662 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934936AbaGXXHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:07:11 -0400
X-Originating-IP: 109.10.215.15
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Guillaume Clement <gclement@baobob.org>
Subject: [PATCH 13/14] staging: vt6655: remove unused macro
Date: Fri, 25 Jul 2014 01:06:27 +0200
Message-Id: <1406243188-13413-14-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1406243188-13413-1-git-send-email-gclement@baobob.org>
References: <1406243188-13413-1-git-send-email-gclement@baobob.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MAC_MAX_CONTEXT_SIZE macro was not enclosed into parenthesis,
which might have caused hard to debug errors, and caused a sparse
warning.

Since it is unused, we might as well remove it.

Signed-off-by: Guillaume Clement <gclement@baobob.org>
---
 drivers/staging/vt6655/mac.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/vt6655/mac.h b/drivers/staging/vt6655/mac.h
index 98ade83..0bf9375 100644
--- a/drivers/staging/vt6655/mac.h
+++ b/drivers/staging/vt6655/mac.h
@@ -44,7 +44,6 @@
 //
 #define MAC_MAX_CONTEXT_SIZE_PAGE0  256
 #define MAC_MAX_CONTEXT_SIZE_PAGE1  128
-#define MAC_MAX_CONTEXT_SIZE        MAC_MAX_CONTEXT_SIZE_PAGE0 + MAC_MAX_CONTEXT_SIZE_PAGE1
 
 // Registers not related to 802.11b
 #define MAC_REG_BCFG0       0x00
-- 
1.8.5.5


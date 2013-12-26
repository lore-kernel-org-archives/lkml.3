Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab3LZMdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 07:33:14 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:62405 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab3LZMdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 07:33:13 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, sjenning@linux.vnet.ibm.com,
        linux-mm@kvack.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] mm: zswap: Add kernel parameters for zswap in kernel-parameters.txt
Date: Thu, 26 Dec 2013 21:32:59 +0900
Message-Id: <1388061179-26624-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds kernel parameters for zswap.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/kernel-parameters.txt | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 60a822b..209730af 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3549,6 +3549,19 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Format:
 			<irq>,<irq_mask>,<io>,<full_duplex>,<do_sound>,<lockup_hack>[,<irq2>[,<irq3>[,<irq4>]]]
 
+	zswap.compressor= [KNL]
+			Specify compressor algorithm.
+			By default, set to lzo.
+
+	zswap.enabled=	[KNL]
+			Format: <0|1>
+			0: Disable zswap (default)
+			1: Enable zswap
+			See more information, Documentations/vm/zswap.txt
+
+	zswap.max_pool_percent=	[KNL]
+			The maximum percentage of memory that the compressed
+			pool can occupy. By default, set to 20.
 ______________________________________________________________________
 
 TODO:
-- 
1.8.5.2.192.g7794a68


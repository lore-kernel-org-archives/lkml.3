Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750784AbaKVGFG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 01:05:06 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:34177 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaKVGFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 01:05:04 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH]  Staging:skein: Fix trailing  whitespace error
Date: Sat, 22 Nov 2014 11:34:29 +0530
Message-Id: <1416636269-3030-1-git-send-email-anjanasasindran123@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This patch fixes the checkpatch.pl error:

  ERROR: trailing whitespace

Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
---
 drivers/staging/skein/skein_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/skein/skein_generic.c b/drivers/staging/skein/skein_generic.c
index 7096d5a..8660509 100644
--- a/drivers/staging/skein/skein_generic.c
+++ b/drivers/staging/skein/skein_generic.c
@@ -190,6 +190,7 @@ static int __init skein_generic_init(void)
 		goto unreg512;
 
 	return 0;
+
 unreg512:
 	crypto_unregister_shash(&alg512);
 unreg256:
-- 
1.9.1


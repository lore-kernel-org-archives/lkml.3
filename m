Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbaKUAHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 19:07:22 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38765 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbaKUAHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 19:07:20 -0500
From: Anjana Sasindran <anjanasasindran123@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Anjana Sasindran <anjanasasindran123@gmail.com>
Subject: [PATCH]  Staging:skein: Fix trailing  whitespace error
Date: Fri, 21 Nov 2014 05:37:04 +0530
Message-Id: <1416528424-9151-1-git-send-email-anjanasasindran123@gmail.com>
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


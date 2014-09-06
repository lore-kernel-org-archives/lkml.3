Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbaIFJAB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 05:00:01 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49082 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaIFI74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 04:59:56 -0400
From: Omar Sandoval <osandov@osandov.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Omar Sandoval <osandov@osandov.com>
Subject: [PATCH] staging: bcm: sort.c: fix coding style
Date: Sat,  6 Sep 2014 01:59:37 -0700
Message-Id: <1409993977-4383-1-git-send-email-osandov@osandov.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl "Alignment should match open parenthesis".

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 drivers/staging/bcm/sort.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/bcm/sort.c b/drivers/staging/bcm/sort.c
index d518c42..ca0b179 100644
--- a/drivers/staging/bcm/sort.c
+++ b/drivers/staging/bcm/sort.c
@@ -28,7 +28,7 @@ VOID SortPackInfo(struct bcm_mini_adapter *Adapter)
 			DBG_LVL_ALL, "<=======");
 
 	sort(Adapter->PackInfo, NO_OF_QUEUES, sizeof(struct bcm_packet_info),
-		compare_packet_info, NULL);
+	     compare_packet_info, NULL);
 }
 
 static int compare_classifiers(void const *a, void const *b)
@@ -48,5 +48,5 @@ VOID SortClassifiers(struct bcm_mini_adapter *Adapter)
 			DBG_LVL_ALL, "<=======");
 
 	sort(Adapter->astClassifierTable, MAX_CLASSIFIERS,
-		sizeof(struct bcm_classifier_rule), compare_classifiers, NULL);
+	     sizeof(struct bcm_classifier_rule), compare_classifiers, NULL);
 }
-- 
2.1.0


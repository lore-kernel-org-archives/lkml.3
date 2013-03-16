Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab3CPNbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 09:31:18 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:37555 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab3CPNbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 09:31:17 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: konrad.wilk@oracle.com, gregkh@linuxfoundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: dan.magenheimer@oracle.com, sjenning@linux.vnet.ibm.com,
        minchan@kernel.org, liwanp@linux.vnet.ibm.com, bob.liu@oracle.com
Subject: [PATCH] zcache/TODO: Update on two items.
Date: Sat, 16 Mar 2013 09:31:10 -0400
Message-Id: <1363440670-7262-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two of them (zcache DebugFS cleanup) and the module loading
capability are now in linux-next for v3.10.

Also Bob Liu is full-time going to help on knocking these items
off the list.

CC: bob.liu@oracle.com
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/TODO | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/staging/zcache/TODO b/drivers/staging/zcache/TODO
index c1e26d4..ec9aa11 100644
--- a/drivers/staging/zcache/TODO
+++ b/drivers/staging/zcache/TODO
@@ -41,14 +41,10 @@ STATUS/OWNERSHIP
     for 3.9, see https://lkml.org/lkml/2013/2/6/437;
 7. PROTOTYPED as part of "new" zcache; in staging/zcache for 3.9;
     needs more review (plan to discuss at LSF/MM 2013)
-8. IN PROGRESS; owned by Konrad Wilk; v2 recently posted
-   http://lkml.org/lkml/2013/2/1/542
 9. IN PROGRESS; owned by Konrad Wilk; Mel Gorman provided
    great feedback in August 2012 (unfortunately of "old"
    zcache)
-10. Konrad posted series of fixes (that now need rebasing)
-    https://lkml.org/lkml/2013/2/1/566 
-11. NOT DONE; owned by Konrad Wilk
+11. NOT DONE; owned by Konrad Wilk and Bob Liu
 12. TBD (depends on quantity of feedback)
 13. PROPOSED; one suggestion proposed by Dan; needs more ideas/feedback
 14. TBD (depends on feedback)
-- 
1.7.11.7


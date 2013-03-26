Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab3CZReG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:34:06 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:53650 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022Ab3CZReC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:34:02 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: mmzone: correct "pags" to "pages" in comment.
Date: Tue, 26 Mar 2013 10:30:44 -0700
Message-Id: <1364319045-29973-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032617-7182-0000-0000-000005F47E7A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/mmzone.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c74092e..5c76737 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -450,7 +450,7 @@ struct zone {
 	 *
 	 * present_pages is physical pages existing within the zone, which
 	 * is calculated as:
-	 *	present_pages = spanned_pages - absent_pages(pags in holes);
+	 *	present_pages = spanned_pages - absent_pages(pages in holes);
 	 *
 	 * managed_pages is present pages managed by the buddy system, which
 	 * is calculated as (reserved_pages includes pages allocated by the
-- 
1.8.2


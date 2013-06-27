Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab3F0GEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 02:04:24 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42650 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab3F0GEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 02:04:23 -0400
Date: Thu, 27 Jun 2013 11:34:09 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: pjt@google.com, peterz@infradead.org, mingo@kernel.org,
        kamalesh@linux.vnet.ibm.com
Subject: [PATCH TRIVIAL] sched: Fix typo in struct sched_avg member
 description
Message-ID: <20130627060409.GB18582@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062706-5140-0000-0000-0000036FF861
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove extra 'for' from the description about member of
struct sched_avg.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 include/linux/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 178a8d9..a9a0ae5 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -924,7 +924,7 @@ struct load_weight {
 struct sched_avg {
 	/*
 	 * These sums represent an infinite geometric series and so are bound
-	 * above by 1024/(1-y).  Thus we only need a u32 to store them for for all
+	 * above by 1024/(1-y).  Thus we only need a u32 to store them for all
 	 * choices of y < 1-2^(-32)*1024.
 	 */
 	u32 runnable_avg_sum, runnable_avg_period;
-- 
1.7.11.6


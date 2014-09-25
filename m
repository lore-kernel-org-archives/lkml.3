Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaIYNmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:42:06 -0400
Received: from sessmg23.ericsson.net ([193.180.251.45]:54398 "EHLO
	sessmg23.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaIYNmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:42:04 -0400
X-AuditID: c1b4fb2d-f793d6d000005356-e9-54241ba9b011
From: <oscar@oscr.io>
To: <rdunlap@infradead.org>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oscar@oscr.io>
Subject: [PATCH 1/1] Changed "&" with "and" in Documentation/applying-patches.txt.
Date: Thu, 25 Sep 2014 15:41:35 +0200
Message-ID: <1411652495-100852-1-git-send-email-oscar@oscr.io>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsUyM+Jvje5KaZUQg6V7dS0Wti1hsbi8aw6b
	xZxfp9ks3t6ZzuLA4rF5hZbH8ZMb2D0+b5ILYI7isklJzcksSy3St0vgymj42MBeMJm9orVn
	JlsD4x/WLkZODgkBE4n1BzYyQ9hiEhfurWfrYuTiEBI4yiixdsttRghnF6PEqhvPGUGqhATO
	MkqcXJgFkWhglPi7aQrYKDYBUYnuzy9YQGwRAWmJ45/+s4PYzAJBEp+ffQZbIQxkX2udDmaz
	CKhKPO/qBuvlFbCTOP5nATvEGQoSp9/dZYGIC0qcnPmEBWKOhMTBFy+AejmAFqtJLDxdMIFR
	YBaSqllIqhYwMq1iFC1OLS7OTTcy1kstykwuLs7P08tLLdnECAzNg1t+6+5gXP3a8RCjAAej
	Eg+vQrlyiBBrYllxZe4hRmkOFiVx3kXn5gULCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYGQU
	dlRNOFcg+/CSQe1uxksL9IvXK7v3CwqFbjz459G3k27mgtm5DAvOnL9SJcaSoXXvoaFt17TO
	riMr7TMOWDsJSm/vZVleeknf7Zbzm0Ix17WBalskYiYZS6wo2svlHV+k73R89936ryHLledL
	2S9OuRlWKpL4TjLsSGhOXY3tW8N/fCYxSizFGYmGWsxFxYkAcPQitC4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oscar Utbult <oscar@oscr.io>

http://english.stackexchange.com/questions/3127/when-to-use-instead-of-and

Signed-off-by: Oscar Utbult <oscar@oscr.io>
---
 Documentation/applying-patches.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/applying-patches.txt b/Documentation/applying-patches.txt
index a083ba3..77df55b 100644
--- a/Documentation/applying-patches.txt
+++ b/Documentation/applying-patches.txt
@@ -94,7 +94,7 @@ Common errors when patching
 ---
  When patch applies a patch file it attempts to verify the sanity of the
 file in different ways.
-Checking that the file looks like a valid patch file & checking the code
+Checking that the file looks like a valid patch file and checking the code
 around the bits being modified matches the context provided in the patch are
 just two of the basic sanity checks patch does.
 
-- 
1.8.0.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab3C0PIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:08:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56448 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3C0PIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:08:49 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <joe@perches.com>
CC: <apw@canonical.com>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Mugunthan V N <mugunthanvnm@ti.com>
Subject: [PATCH 1/1] checkpatch: adding Suggested-by as standard signature
Date: Wed, 27 Mar 2013 20:38:22 +0530
Message-ID: <1364396902-16749-1-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 1.8.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As people started using Suggested-by as standard signature, adding
"Suggested-by" to the standard signature so that checkpatch won't
generate warning when Suggested-by is used in patch signature

Signed-off-by: Mugunthan V N <mugunthanvnm@ti.com>
---
 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b28cc38..6be4d27 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -281,6 +281,7 @@ our $signature_tags = qr{(?xi:
 	Tested-by:|
 	Reviewed-by:|
 	Reported-by:|
+	Suggested-by:|
 	To:|
 	Cc:
 )};
-- 
1.7.9.5


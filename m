Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab3ETGvI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:51:08 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:56483 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab3ETGvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:51:06 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/2] net/9p: Make 9P2000.L the default protocol for 9p file system
Date: Mon, 20 May 2013 12:20:54 +0530
Message-Id: <1369032655-22648-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.2
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052006-5564-0000-0000-000007FF8420
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

If we dont' specify a protocol version default to 9P2000.L. 9P2000.L
have better support for posix semantic and is where all the recent development
is happening.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 net/9p/client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 8eb7542..812a4cd 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -127,7 +127,7 @@ static int parse_opts(char *opts, struct p9_client *clnt)
 	char *s;
 	int ret = 0;
 
-	clnt->proto_version = p9_proto_2000u;
+	clnt->proto_version = p9_proto_2000L;
 	clnt->msize = 8192;
 
 	if (!opts)
-- 
1.8.1.2


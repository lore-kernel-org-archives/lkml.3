Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbaFRRgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:36:49 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:47173 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753310AbaFRRgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:36:48 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao0KACHNoVNbtAr8/2dsb2JhbABagw2rOgUBAQEBAQEFAZkogQsXdYQxLyOBAhg3iC4DFQHGZA2GNheFYoZwgT9kHYQtBJhKgXmNWIYAg0Q7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 1/1] fs/ubifs/compress.c: remove unnecessary return
Date: Wed, 18 Jun 2014 19:35:22 +0200
Message-Id: <1403112922-7233-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

return at the end of void function is not needed.

Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ubifs/compress.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ubifs/compress.c b/fs/ubifs/compress.c
index 2bfa095..ac077d2 100644
--- a/fs/ubifs/compress.c
+++ b/fs/ubifs/compress.c
@@ -211,7 +211,6 @@ static void compr_exit(struct ubifs_compressor *compr)
 {
 	if (compr->capi_name)
 		crypto_free_comp(compr->cc);
-	return;
 }
 
 /**
-- 
1.8.4.5


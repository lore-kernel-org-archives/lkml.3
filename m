Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaEVRhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:37:47 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:28105 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbaEVRhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:37:46 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYLAFQ1flNbsFZY/2dsb2JhbABZgweCRahFCgUBgzqXAYENF3SCUxMcIxiBAiQTiEUB1wKFVYh5hEcBA48/ijEBkyaDOjsw
Date: Thu, 22 May 2014 19:37:43 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Duan Jiong <duanj.fnst@cn.fujitsu.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] lib/digsig.c: kernel-doc warning fixes
Message-Id: <20140522193743.848a5c4d570e793be26951a0@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small typo and @return: -> Returns ...

Cc: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 lib/digsig.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/digsig.c b/lib/digsig.c
index 8793aed..ae05ea3 100644
--- a/lib/digsig.c
+++ b/lib/digsig.c
@@ -175,10 +175,11 @@ err1:
  * digsig_verify() - digital signature verification with public key
  * @keyring:	keyring to search key in
  * @sig:	digital signature
- * @sigen:	length of the signature
+ * @siglen:	length of the signature
  * @data:	data
  * @datalen:	length of the data
- * @return:	0 on success, -EINVAL otherwise
+ *
+ * Returns 0 on success, -EINVAL otherwise
  *
  * Verifies data integrity against digital signature.
  * Currently only RSA is supported.
-- 
1.8.4.5


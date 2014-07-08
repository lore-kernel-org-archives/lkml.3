Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbaGHQaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:30:12 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:22807 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754710AbaGHQaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:30:11 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At4OACwcvFNXQDwH/2dsb2JhbABZgw6tGgUBAQEBAQEFAW4BmVmBGBd1hQOBGjeIRgHJYBeFeohkZB2ELQWadpQMg0U7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Tyler Hicks <tyhicks@canonical.com>,
        ecryptfs@vger.kernel.org
Subject: [PATCH 1/1] ecryptfs: remove unnecessary break after goto
Date: Tue,  8 Jul 2014 18:30:07 +0200
Message-Id: <1404837007-7089-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Tyler Hicks <tyhicks@canonical.com>
Cc: ecryptfs@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ecryptfs/keystore.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 4725a07..8f0d619 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1846,7 +1846,6 @@ int ecryptfs_parse_packet_set(struct ecryptfs_crypt_stat *crypt_stat,
 					"(Tag 11 not allowed by itself)\n");
 			rc = -EIO;
 			goto out_wipe_list;
-			break;
 		default:
 			ecryptfs_printk(KERN_DEBUG, "No packet at offset [%zd] "
 					"of the file header; hex value of "
-- 
1.8.4.5


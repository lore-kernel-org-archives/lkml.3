Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbbA2KwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:52:07 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50584 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797AbbA2KwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:52:03 -0500
Date: Thu, 29 Jan 2015 19:49:14 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: mfasheh@suse.com
Cc: jlbec@evilplan.org, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ocfs2: remove unreachable code
Message-ID: <20150129104914.GA6074@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 fs/ocfs2/dir.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
index 319e786..940be6d 100644
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -3513,7 +3513,6 @@ next:
 		de = (struct ocfs2_dir_entry *)((char *) de + le16_to_cpu(de->rec_len));
 	}
 
-	status = 0;
 bail:
 	brelse(bh);
 	if (status)
-- 
1.7.1


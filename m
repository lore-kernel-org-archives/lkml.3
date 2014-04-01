Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaDAJZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:25:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbaDAJQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:16 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: David Teigland <teigland@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/29] GFS2: add missing newline
Date: Tue,  1 Apr 2014 10:15:19 +0100
Message-Id: <1396343741-1524-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

Log message is missing newline.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 2a6ba06..6b97d98 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -1102,7 +1102,7 @@ static void gdlm_recover_slot(void *arg, struct dlm_slot *slot)
 	}
 
 	if (ls->ls_recover_submit[jid]) {
-		fs_info(sdp, "recover_slot jid %d gen %u prev %u",
+		fs_info(sdp, "recover_slot jid %d gen %u prev %u\n",
 			jid, ls->ls_recover_block, ls->ls_recover_submit[jid]);
 	}
 	ls->ls_recover_submit[jid] = ls->ls_recover_block;
-- 
1.8.3.1


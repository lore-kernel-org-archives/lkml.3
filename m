Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab3CNK4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:56:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51864 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039Ab3CNKhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 34/88] dm snapshot: add missing module aliases
Date: Thu, 14 Mar 2013 10:35:27 +0000
Message-Id: <1363257381-15900-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 23cb21092eb9dcec9d3604b68d95192b79915890 upstream.

Add module aliases so that autoloading works correctly if the user
tries to activate "snapshot-origin" or "snapshot-merge" targets.

Reference: https://bugzilla.redhat.com/889973

Reported-by: Chao Yang <chyang@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-snap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 6f75887..5f4659e 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2327,3 +2327,5 @@ module_exit(dm_snapshot_exit);
 MODULE_DESCRIPTION(DM_NAME " snapshot target");
 MODULE_AUTHOR("Joe Thornber");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("dm-snapshot-origin");
+MODULE_ALIAS("dm-snapshot-merge");
-- 
1.8.1.2


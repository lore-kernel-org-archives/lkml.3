Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaFEEU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:20:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44004 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaFEEUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chao Yang <chyang@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 096/214] dm snapshot: add missing module aliases
Date: Wed,  4 Jun 2014 21:17:39 -0700
Message-Id: <20140605041652.593261151@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 23cb21092eb9dcec9d3604b68d95192b79915890 upstream.

Add module aliases so that autoloading works correctly if the user
tries to activate "snapshot-origin" or "snapshot-merge" targets.

Reference: https://bugzilla.redhat.com/889973

Reported-by: Chao Yang <chyang@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-snap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2323,3 +2323,5 @@ module_exit(dm_snapshot_exit);
 MODULE_DESCRIPTION(DM_NAME " snapshot target");
 MODULE_AUTHOR("Joe Thornber");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("dm-snapshot-origin");
+MODULE_ALIAS("dm-snapshot-merge");



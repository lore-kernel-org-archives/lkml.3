Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab3CREfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:35:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33710 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563Ab3CREbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:31:13 -0400
Message-Id: <20130318042146.162171116@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:03 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Mikulas Patocka <mpatocka@redhat.com>,
        Chao Yang <chyang@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 19/82] dm snapshot: add missing module aliases
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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



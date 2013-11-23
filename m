Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab3KWPga (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 10:36:30 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:43942 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab3KWPgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 10:36:23 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, tomas.winkler@intel.com
Cc: rdunlap@infradead.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 1/3] [trivial] mei: Fix typo in client.c
Date: Sun, 24 Nov 2013 00:36:12 +0900
Message-Id: <1385220974-3469-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.5.rc1.28.g7061504
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in comments within mei/client.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/misc/mei/client.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 87c96e4..3aa379f 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -263,10 +263,10 @@ struct mei_cl_cb *mei_cl_find_read_cb(struct mei_cl *cl)
 	return NULL;
 }
 
-/** mei_cl_link: allocte host id in the host map
+/** mei_cl_link: allocate host id in the host map
  *
  * @cl - host client
- * @id - fixed host id or -1 for genereting one
+ * @id - fixed host id or -1 for generating one
  *
  * returns 0 on success
  *	-EINVAL on incorrect values
@@ -282,7 +282,7 @@ int mei_cl_link(struct mei_cl *cl, int id)
 
 	dev = cl->dev;
 
-	/* If Id is not asigned get one*/
+	/* If Id is not assigned get one*/
 	if (id == MEI_HOST_CLIENT_ID_ANY)
 		id = find_first_zero_bit(dev->host_clients_map,
 					MEI_CLIENTS_MAX);
@@ -378,7 +378,7 @@ void mei_host_client_init(struct work_struct *work)
 
 
 /**
- * mei_cl_disconnect - disconnect host clinet form the me one
+ * mei_cl_disconnect - disconnect host client from the me one
  *
  * @cl: host client
  *
@@ -457,7 +457,7 @@ free:
  *
  * @cl: private data of the file object
  *
- * returns ture if other client is connected, 0 - otherwise.
+ * returns true if other client is connected, 0 - otherwise.
  */
 bool mei_cl_is_other_connecting(struct mei_cl *cl)
 {
@@ -481,7 +481,7 @@ bool mei_cl_is_other_connecting(struct mei_cl *cl)
 }
 
 /**
- * mei_cl_connect - connect host clinet to the me one
+ * mei_cl_connect - connect host client to the me one
  *
  * @cl: host client
  *
@@ -775,7 +775,7 @@ int mei_cl_irq_write_complete(struct mei_cl *cl, struct mei_cl_cb *cb,
  * @cl: host client
  * @cl: write callback with filled data
  *
- * returns numbe of bytes sent on success, <0 on failure.
+ * returns number of bytes sent on success, <0 on failure.
  */
 int mei_cl_write(struct mei_cl *cl, struct mei_cl_cb *cb, bool blocking)
 {
-- 
1.8.5.rc1.28.g7061504


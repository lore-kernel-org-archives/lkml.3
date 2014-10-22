Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784AbaJVJtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:49:01 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:33181 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbaJVJs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:48:58 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH/TRIVIAL 2/5] net: Spelling s/stucture/structure/
Date: Wed, 22 Oct 2014 11:49:00 +0200
Message-Id: <1413971343-27554-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413971343-27554-1-git-send-email-geert+renesas@glider.be>
References: <1413971343-27554-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/ti/tlan.c        | 2 +-
 drivers/net/wireless/ath/ath10k/wmi.h | 2 +-
 drivers/net/wireless/atmel.c          | 2 +-
 include/net/iw_handler.h              | 2 +-
 net/socket.c                          | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index f2ff0074aac9b272..f01779e31a5c1e32 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -1908,7 +1908,7 @@ ThunderLAN driver adapter related routines
  *		Nothing
  *	Parms:
  *		dev	The device structure with the list
- *			stuctures to be reset.
+ *			structures to be reset.
  *
  *	This routine sets the variables associated with managing
  *	the TLAN lists to their initial values.
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 86f5ebccfe79c26a..a6e497ae8a6bf681 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1894,7 +1894,7 @@ struct wmi_init_cmd {
 	struct host_memory_chunk host_mem_chunks[1];
 } __packed;
 
-/* _10x stucture is from 10.X FW API */
+/* _10x structure is from 10.X FW API */
 struct wmi_init_cmd_10x {
 	struct wmi_resource_config_10x resource_config;
 	__le32 num_host_mem_chunks;
diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 9183f1cf89a76d9c..7dc66b3ebe87dce7 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -3880,7 +3880,7 @@ static int reset_atmel_card(struct net_device *dev)
 
 	   set all the Mib values which matter in the card to match
 	   their settings in the atmel_private structure. Some of these
-	   can be altered on the fly, but many (WEP, infrastucture or ad-hoc)
+	   can be altered on the fly, but many (WEP, infrastructure or ad-hoc)
 	   can only be changed by tearing down the world and coming back through
 	   here.
 
diff --git a/include/net/iw_handler.h b/include/net/iw_handler.h
index a830b01baba4b08a..df0dac32789e12e9 100644
--- a/include/net/iw_handler.h
+++ b/include/net/iw_handler.h
@@ -363,7 +363,7 @@ struct iw_handler_def {
  * defined in struct iw_priv_args.
  *
  * For standard IOCTLs, things are quite different and we need to
- * use the stuctures below. Actually, this struct is also more
+ * use the structures below. Actually, this struct is also more
  * efficient, but that's another story...
  */
 
diff --git a/net/socket.c b/net/socket.c
index fe20c319a0bb37dd..bcbc2a824e4b4378 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1583,7 +1583,7 @@ SYSCALL_DEFINE2(listen, int, fd, int, backlog)
  *
  *	1003.1g adds the ability to recvmsg() to query connection pending
  *	status to recvmsg. We need to add that support in a way thats
- *	clean when we restucture accept also.
+ *	clean when we restructure accept also.
  */
 
 SYSCALL_DEFINE4(accept4, int, fd, struct sockaddr __user *, upeer_sockaddr,
-- 
1.9.1


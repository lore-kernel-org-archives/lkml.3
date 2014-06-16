Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbaFPQHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 12:07:23 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:39408 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319AbaFPQHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 12:07:19 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 8/9] staging: rtl8188eu: Remove unused members of struct adapter
Date: Mon, 16 Jun 2014 21:35:45 +0530
Message-Id: <1402934746-29422-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402934746-29422-1-git-send-email-navin.patidar@gmail.com>
References: <1402934746-29422-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/drv_types.h |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index 71b4af7..baafe33 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -255,14 +255,6 @@ struct adapter {
 	struct mutex hw_init_mutex;
 
 	spinlock_t br_ext_lock;
-	struct nat25_network_db_entry	*nethash[NAT25_HASH_SIZE];
-	unsigned char			pppoe_addr[MACADDRLEN];
-	unsigned char			scdb_mac[MACADDRLEN];
-	unsigned char			scdb_ip[4];
-	struct nat25_network_db_entry	*scdb_entry;
-	unsigned char			br_mac[MACADDRLEN];
-	unsigned char			br_ip[4];
-	struct br_ext_info		ethBrExtInfo;
 
 	u8	fix_rate;
 
-- 
1.7.10.4


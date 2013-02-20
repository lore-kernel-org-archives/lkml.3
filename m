Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934687Ab3BTLBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:01:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933396Ab3BTLBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:01:17 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC] edac: remove proc_name from mci structure
Date: Wed, 20 Feb 2013 08:01:11 -0300
Message-Id: <0c9e49d29b61441c50e04192cf9dc76053c9e890.1361358053.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_name isn't used anywhere. Remove it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 include/linux/edac.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/edac.h b/include/linux/edac.h
index 28232a0..bd14f5c 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -48,7 +48,6 @@ static inline void opstate_init(void)
 }
 
 #define EDAC_MC_LABEL_LEN	31
-#define MC_PROC_NAME_MAX_LEN	7
 
 /**
  * enum dev_type - describe the type of memory DRAM chips used at the stick
@@ -634,7 +633,6 @@ struct mem_ctl_info {
 	const char *mod_ver;
 	const char *ctl_name;
 	const char *dev_name;
-	char proc_name[MC_PROC_NAME_MAX_LEN + 1];
 	void *pvt_info;
 	unsigned long start_time;	/* mci load start time (in jiffies) */
 
-- 
1.8.1.2


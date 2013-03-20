Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab3CTP0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:26:04 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:41644 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933Ab3CTP0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:26:03 -0400
MIME-Version: 1.0
Date: Wed, 20 Mar 2013 23:25:59 +0800
Message-ID: <CAPgLHd_Fys=dh9JVkcdUxTccM4srA=3dGfyFj132V1Nw2Dub4A@mail.gmail.com>
Subject: [PATCH -next] Drivers: hv: balloon: make local functions static
From: Wei Yongjun <weiyj.lk@gmail.com>
To: kys@microsoft.com, haiyangz@microsoft.com
Cc: yongjun_wei@trendmicro.com.cn, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

local functions that could be static.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/hv/hv_balloon.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 2cf7d4e..d522526 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -537,7 +537,7 @@ static struct hv_dynmem_device dm_device;
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 
-void hv_bring_pgs_online(unsigned long start_pfn, unsigned long size)
+static void hv_bring_pgs_online(unsigned long start_pfn, unsigned long size)
 {
 	int i;
 
@@ -876,7 +876,7 @@ static void process_info(struct hv_dynmem_device *dm, struct dm_info_msg *msg)
 	}
 }
 
-unsigned long compute_balloon_floor(void)
+static unsigned long compute_balloon_floor(void)
 {
 	unsigned long min_pages;
 #define MB2PAGES(mb) ((mb) << (20 - PAGE_SHIFT))



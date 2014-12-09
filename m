Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbaLIBIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 20:08:48 -0500
Received: from m12-12.163.com ([220.181.12.12]:36181 "EHLO m12-12.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbaLIBIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 20:08:47 -0500
X-Coremail-DSSMTP: 114.221.144.142
From: weiyj_lk@163.com
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-kernel@vger.kernel.org
Subject: [PATCH -next] extcon: Remove duplicated include from extcon-class.c
Date: Tue,  9 Dec 2014 09:08:39 +0800
Message-Id: <1418087319-14416-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: DMCowEB5QnGYS4ZUDmaFAw--.816S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrAFWrWFyrKFyfCryrJF43ZFb_yoWxGFc_Ca
	srXrZ3GrWIyrWxtas3tr90yw1F9F18Zr15Z3ZYk34fWF1DXw43Ka97ArnrJr4UuwsYq3WS
	kr4jqr48Cr97XjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnSD73UUUUU==
X-Originating-IP: [114.221.144.142]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiMBxd1lEAQVU2twAAsj
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/extcon/extcon-class.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 043dcd9..8319f25 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -32,7 +32,6 @@
 #include <linux/of.h>
 #include <linux/slab.h>
 #include <linux/sysfs.h>
-#include <linux/of.h>
 
 /*
  * extcon_cable_name suggests the standard cable names for commonly used


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaIAPsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:48:30 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:39979 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaIAPs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:48:29 -0400
From: sunwxg <sun.wxg@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Chi Pham <fempsci@gmail.com>, Oleg Drokin <green@linuxhacker.ru>
Cc: Sun Wang <sun.wxg@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: 
Date: Mon,  1 Sep 2014 23:47:38 +0800
Message-Id: <1409586458-723-2-git-send-email-sun.wxg@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sun Wang <sun.wxg@gmail.com>

Subject: [PATCH] staging: lustre: lov_pack: fix coding style issue

Fix the style error checking by checkpatch.pl
ERROR: space required after that ','

Signed-off-by: Sun Wang <sun.wxg@gmail.com>

---
 drivers/staging/lustre/lustre/lov/lov_pack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/lov/lov_pack.c b/drivers/staging/lustre/lustre/lov/lov_pack.c
index 20e5870..62ea223 100644
--- a/drivers/staging/lustre/lustre/lov/lov_pack.c
+++ b/drivers/staging/lustre/lustre/lov/lov_pack.c
@@ -95,7 +95,7 @@ void lov_dump_lmm_v1(int level, struct lov_mds_md_v1 *lmm)
 void lov_dump_lmm_v3(int level, struct lov_mds_md_v3 *lmm)
 {
 	lov_dump_lmm_common(level, lmm);
-	CDEBUG(level,"pool_name "LOV_POOLNAMEF"\n", lmm->lmm_pool_name);
+	CDEBUG(level, "pool_name "LOV_POOLNAMEF"\n", lmm->lmm_pool_name);
 	lov_dump_lmm_objects(level, lmm->lmm_objects,
 			     le16_to_cpu(lmm->lmm_stripe_count));
 }

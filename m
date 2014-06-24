Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaFXKVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:21:51 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:13335 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752190AbaFXKVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:21:50 -0400
X-IronPort-AV: E=Sophos;i="5.00,768,1396972800"; 
   d="scan'208";a="32348540"
Message-ID: <53A94E92.9090105@cn.fujitsu.com>
Date: Tue, 24 Jun 2014 18:10:26 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Jens <axboe@kernel.dk>, Kent <kmo@daterainc.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] bio: remove unused macro bip_vec_idx()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macro bip_vec_idx() was used by bio integrity originally, but no longer
used now. So remove it.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 include/linux/bio.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 5a64576..f91decb 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -644,10 +644,6 @@ struct biovec_slab {
 
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 
-
-
-#define bip_vec_idx(bip, idx)	(&(bip->bip_vec[(idx)]))
-
 #define bip_for_each_vec(bvl, bip, iter)				\
 	for_each_bvec(bvl, (bip)->bip_vec, iter, (bip)->bip_iter)
 
-- 
1.7.7


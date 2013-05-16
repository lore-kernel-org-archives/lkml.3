Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab3EPB0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 21:26:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:48274 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992Ab3EPB0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 21:26:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="338029622"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
        David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH] cachefiles: remove unused macro list_to_page()
Date: Thu, 16 May 2013 09:25:29 +0800
Message-Id: <1368667529-31456-1-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/cachefiles/interface.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
index 746ce53..847ba6a 100644
--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -13,8 +13,6 @@
 #include <linux/mount.h>
 #include "internal.h"
 
-#define list_to_page(head) (list_entry((head)->prev, struct page, lru))
-
 struct cachefiles_lookup_data {
 	struct cachefiles_xattr	*auxdata;	/* auxiliary data */
 	char			*key;		/* key path */
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab3JUIBl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:01:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35910 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752367Ab3JUIBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:01:40 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] hfs: remove duplicate includes
Date: Mon, 21 Oct 2013 10:01:37 +0200
Message-Id: <1382342497-3132-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes duplicate includes from fs/hfs/btree.h

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 fs/hfs/btree.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/fs/hfs/btree.h b/fs/hfs/btree.h
index 2a1d712..f6bd266 100644
--- a/fs/hfs/btree.h
+++ b/fs/hfs/btree.h
@@ -153,11 +153,6 @@ struct hfs_btree_header_rec {
 	u32 reserved3[16];
 } __packed;
 
-#define HFS_NODE_INDEX	0x00	/* An internal (index) node */
-#define HFS_NODE_HEADER	0x01	/* The tree header node (node 0) */
-#define HFS_NODE_MAP		0x02	/* Holds part of the bitmap of used nodes */
-#define HFS_NODE_LEAF		0xFF	/* A leaf (ndNHeight==1) node */
-
 #define BTREE_ATTR_BADCLOSE	0x00000001	/* b-tree not closed properly. not
 						   used by hfsplus. */
 #define HFS_TREE_BIGKEYS	0x00000002	/* key length is u16 instead of u8.
-- 
1.8.1.2


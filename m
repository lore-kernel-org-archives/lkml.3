Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaHNHUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 03:20:13 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:43645 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaHNHUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 03:20:12 -0400
Date: Thu, 14 Aug 2014 12:50:04 +0530
From: Hema Prathaban <hemaklnce@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        andreas.dilger@intel.com, oleg.drokin@intel.com
Subject: [PATCH] staging: lustre: lustre: ptlrpc: Donot initialise null
Message-ID: <20140814072003.GA3246@hema-Inspiron-3520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following error using checkpatch.pl
Error: Do not initialise statics to 0 or NULL

Signed-off-by: Hema Prathaban <hemaklnce@gmail.com>
---
 drivers/staging/lustre/lustre/ptlrpc/connection.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/connection.c b/drivers/staging/lustre/lustre/ptlrpc/connection.c
index adff1ab..62154c4 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/connection.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/connection.c
@@ -41,7 +41,7 @@
 
 #include "ptlrpc_internal.h"
 
-static struct cfs_hash *conn_hash = NULL;
+static struct cfs_hash *conn_hash;
 static cfs_hash_ops_t conn_hash_ops;
 
 struct ptlrpc_connection *
-- 
1.9.1


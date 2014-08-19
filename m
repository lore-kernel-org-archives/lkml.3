Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbaHST0m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 15:26:42 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51532 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbaHST0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 15:26:41 -0400
Date: Wed, 20 Aug 2014 00:56:28 +0530
From: Hema Prathaban <hemaklnce@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        andreas.dilger@intel.com, oleg.drokin@intel.com
Subject: [PATCH] staging: lustre: lustre: ptlrpc: Placing inline keyword
Message-ID: <20140819192628.GA10369@hema-Inspiron-3520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following error using checkpatch.pl
ERROR: inline keyword should sit between storage class and type

Signed-off-by: Hema Prathaban <hemaklnce@gmail.com>
---
 drivers/staging/lustre/lustre/ptlrpc/sec_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c b/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
index 01f8b0d..8ef666b 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_config.c
@@ -815,7 +815,7 @@ void sptlrpc_conf_log_stop(const char *logname)
 }
 EXPORT_SYMBOL(sptlrpc_conf_log_stop);
 
-static void inline flavor_set_flags(struct sptlrpc_flavor *sf,
+static inline void flavor_set_flags(struct sptlrpc_flavor *sf,
 				    enum lustre_sec_part from,
 				    enum lustre_sec_part to,
 				    unsigned int fl_udesc)
-- 
1.9.1


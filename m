Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103Ab3JTFKJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 01:10:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33481 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750824Ab3JTFKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 01:10:06 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: dm@chelsio.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] cgxb4: remove duplicate include in cxgb4.h
Date: Sun, 20 Oct 2013 07:10:01 +0200
Message-Id: <1382245801-19192-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported by "make includecheck"

Tested that C sources including this file still compile well on x86

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index dfd1e36..ecd2fb3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -48,7 +48,6 @@
 #include <linux/vmalloc.h>
 #include <asm/io.h>
 #include "cxgb4_uld.h"
-#include "t4_hw.h"
 
 #define FW_VERSION_MAJOR 1
 #define FW_VERSION_MINOR 4
-- 
1.8.1.2


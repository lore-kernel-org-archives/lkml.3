Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbbAFPpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:45:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754114AbbAFPpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:45:50 -0500
Date: Tue, 6 Jan 2015 17:45:42 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: [PATCH v2 39/40] sh: macro whitespace fixes
Message-ID: <1420558883-10131-40-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on arch/sh/include/asm/uaccess.h, I noticed
that one macro within this header is made harder to read because it
violates a coding style rule: space is missing after comma.

Fix it up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/sh/include/asm/segment.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/include/asm/segment.h b/arch/sh/include/asm/segment.h
index 5e2725f..ff795d3 100644
--- a/arch/sh/include/asm/segment.h
+++ b/arch/sh/include/asm/segment.h
@@ -23,7 +23,7 @@ typedef struct {
 #define USER_DS		KERNEL_DS
 #endif
 
-#define segment_eq(a,b)	((a).seg == (b).seg)
+#define segment_eq(a, b) ((a).seg == (b).seg)
 
 #define get_ds()	(KERNEL_DS)
 
-- 
MST


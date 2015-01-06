Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbbAFPpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:45:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014AbbAFPpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:45:33 -0500
Date: Tue, 6 Jan 2015 17:45:25 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: [PATCH v2 34/40] frv: macro whitespace fixes
Message-ID: <1420558883-10131-35-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While working on arch/frv/include/asm/uaccess.h, I noticed
that one macro within this header is made harder to read because it
violates a coding style rule: space is missing after comma.

Fix it up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/frv/include/asm/segment.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/frv/include/asm/segment.h b/arch/frv/include/asm/segment.h
index a2320a4..4377c89 100644
--- a/arch/frv/include/asm/segment.h
+++ b/arch/frv/include/asm/segment.h
@@ -31,7 +31,7 @@ typedef struct {
 
 #define get_ds()		(KERNEL_DS)
 #define get_fs()		(__current_thread_info->addr_limit)
-#define segment_eq(a,b)		((a).seg == (b).seg)
+#define segment_eq(a, b)	((a).seg == (b).seg)
 #define __kernel_ds_p()		segment_eq(get_fs(), KERNEL_DS)
 #define get_addr_limit()	(get_fs().seg)
 
-- 
MST


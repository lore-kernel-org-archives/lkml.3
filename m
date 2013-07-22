Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105Ab3GVI62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:58:28 -0400
Received: from multi.imgtec.com ([194.200.65.239]:24966 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756678Ab3GVI60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:58:26 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>, <linux-metag@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: add linux-metag mailing list
Date: Mon, 22 Jul 2013 09:57:40 +0100
Message-ID: <1374483460-4236-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_07_22_09_58_23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new linux-metag@vger.kernel.org mailing list to METAG
ARCHITECTURE entry in MAINTAINERS.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: linux-metag@vger.kernel.org
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index bf61e04..a195098 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5395,6 +5395,7 @@ F:	drivers/watchdog/mena21_wdt.c
 
 METAG ARCHITECTURE
 M:	James Hogan <james.hogan@imgtec.com>
+L:	linux-metag@vger.kernel.org
 S:	Supported
 F:	arch/metag/
 F:	Documentation/metag/
-- 
1.8.1.2



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaJQXUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 19:20:30 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:60001 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaJQXU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 19:20:29 -0400
From: Dan Streetman <ddstreet@ieee.org>
To: Michael Ellerman <mpe@ellerman.id.au>, benh@kernel.crashing.org,
        nfont@linux.vnet.ibm.com
Cc: Dan Streetman <ddstreet@ieee.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: nx-842 driver maintainer change
Date: Fri, 17 Oct 2014 19:19:59 -0400
Message-Id: <1413587999-12684-1-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change maintainer of nx-842 compression coprocessor driver
to Dan Streetman.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b0f17d5..3cc3e41 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4605,7 +4605,7 @@ S:	Supported
 F:	drivers/crypto/nx/
 
 IBM Power 842 compression accelerator
-M:	Nathan Fontenot <nfont@linux.vnet.ibm.com>
+M:	Dan Streetman <ddstreet@us.ibm.com>
 S:	Supported
 F:	drivers/crypto/nx/nx-842.c
 F:	include/linux/nx842.h
-- 
1.8.3.1


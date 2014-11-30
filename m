Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaK3MXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:23:42 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14387 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbaK3MWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:22:46 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/4] Add drivers/mtd/ubi/fastmap-wl.c to MAINTAINERS file
Date: Sun, 30 Nov 2014 13:22:35 +0100
Message-Id: <1417350157-9373-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417350157-9373-1-git-send-email-richard@nod.at>
References: <1417350157-9373-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ea4d005..87d4d36 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9631,6 +9631,7 @@ M:	Richard Weinberger <richard@nod.at>
 L:	linux-mtd@lists.infradead.org
 S:	Maintained
 F:	drivers/mtd/ubi/fastmap.c
+F:	drivers/mtd/ubi/fastmap-wl.c
 
 USB ACM DRIVER
 M:	Oliver Neukum <oliver@neukum.org>
-- 
1.8.4.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187AbaKMOsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:48:37 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:60942 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933079AbaKMOsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:48:36 -0500
X-CheckPoint: {5464C4C3-0-2100090A-C0000000}
Message-ID: <201411131448.sADEmYsX027347@farm-0002.internal.tilera.com>
From: Chris Metcalf <cmetcalf@ezchip.com>
Date: Thu, 13 Nov 2014 09:41:58 -0500
Subject: [PATCH] arch/tile: update MAINTAINERS email to EZchip
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EZchip Semiconductor closed the acquisition of Tilera Corp
last week, and tilera.com email addresses are now ezchip.com.

http://www.ezchip.com/pr_141106.htm

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3c6427190be2..81764acd163d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9362,7 +9362,7 @@ F:	include/uapi/linux/tipc*.h
 F:	net/tipc/
 
 TILE ARCHITECTURE
-M:	Chris Metcalf <cmetcalf@tilera.com>
+M:	Chris Metcalf <cmetcalf@ezchip.com>
 W:	http://www.tilera.com/scm/
 S:	Supported
 F:	arch/tile/
-- 
2.1.2


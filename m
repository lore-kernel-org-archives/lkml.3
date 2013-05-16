Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3EPDST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 23:18:19 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:28890 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab3EPDQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 23:16:36 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: torvalds@linux-foundation.org
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v4 9/9] liblockdep: Add a MAINTAINERS entry
Date: Wed, 15 May 2013 23:15:41 -0400
Message-Id: <1368674141-10796-10-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com>
References: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5f5c895..0c822ef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4856,6 +4856,11 @@ F:	drivers/lguest/
 F:	include/linux/lguest*.h
 F:	tools/lguest/
 
+LIBLOCK
+M:	Sasha Levin <sasha.levin@oracle.com>
+S:	Maintained
+F:	tools/lib/lockdep/
+
 LINUX FOR IBM pSERIES (RS/6000)
 M:	Paul Mackerras <paulus@au.ibm.com>
 W:	http://www.ibm.com/linux/ltc/projects/ppc
-- 
1.8.2.1


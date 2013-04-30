Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344Ab3D3S4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:56:39 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49102 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253Ab3D3S4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:56:31 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: torvalds@linux-foundation.org
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 9/9] liblockdep: Add a MAINTAINERS entry
Date: Tue, 30 Apr 2013 14:54:40 -0400
Message-Id: <1367348080-4680-10-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367348080-4680-1-git-send-email-sasha.levin@oracle.com>
References: <1367348080-4680-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8bdd7a7..e39345e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4784,6 +4784,11 @@ F:	drivers/lguest/
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


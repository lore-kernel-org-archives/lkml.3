Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab3BAQtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 11:49:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:47387 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab3BAQsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 11:48:11 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: paulus@samba.org, acme@ghostprotocols.net, penberg@kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v2 6/7] liblockdep: add a MAINTAINERS entry
Date: Fri,  1 Feb 2013 11:47:10 -0500
Message-Id: <1359737231-26127-6-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1359737231-26127-1-git-send-email-sasha.levin@oracle.com>
References: <1359737231-26127-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 212c255..a64abfb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4637,6 +4637,11 @@ F:	drivers/lguest/
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
1.8.1.2


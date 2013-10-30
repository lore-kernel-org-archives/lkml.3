Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab3J3LHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:07:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab3J3LHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:07:53 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr
Subject: [PATCH] MAINTAINERS: New kconfig maintainer
Date: Wed, 30 Oct 2013 12:07:44 +0100
Message-Id: <1383131264-19233-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yann has been the de facto maintainer of kconfig for some time. Update
the KCONFIG entry with his emails address and git tree.

Cc: "Yann E. MORIN" <yann.morin.1998@free.fr>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 MAINTAINERS |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e61c2e8..d083982 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4723,9 +4723,10 @@ F:	Documentation/hwmon/k8temp
 F:	drivers/hwmon/k8temp.c
 
 KCONFIG
-M:	Michal Marek <mmarek@suse.cz>
+M:	"Yann E. MORIN" <yann.morin.1998@free.fr>
 L:	linux-kbuild@vger.kernel.org
-S:	Odd Fixes
+T:	git://gitorious.org/linux-kconfig/linux-kconfig
+S:	Maintained
 F:	Documentation/kbuild/kconfig-language.txt
 F:	scripts/kconfig/
 
-- 
1.7.3.1


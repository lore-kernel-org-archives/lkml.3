Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab3GVAQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:16:37 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:45108 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753611Ab3GVAQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:16:35 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/18] MAINTAINERS: ARM: spear: Consolidate sections
Date: Sun, 21 Jul 2013 17:15:32 -0700
Message-Id: <f7c9193e244c95122ceb47d65cd52993c040c7a4.1374451988.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a7ed099ffc8 ("ARM: spear: move all files to mach-spear")
moved all the files into a single directory, delete the now
unnecessary duplicate sections and update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Arnd Bergmann <arnd@arndb.de>
cc: Viresh Kumar <viresh.kumar@linaro.org>
---
 MAINTAINERS | 30 +-----------------------------
 1 file changed, 1 insertion(+), 29 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fbd5a67..5e90164 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7701,35 +7701,7 @@ L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
 S:	Maintained
-F:	arch/arm/plat-spear/
-
-SPEAR13XX MACHINE SUPPORT
-M:	Viresh Kumar <viresh.linux@gmail.com>
-M:	Shiraz Hashim <shiraz.hashim@st.com>
-L:	spear-devel@list.st.com
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-W:	http://www.st.com/spear
-S:	Maintained
-F:	arch/arm/mach-spear13xx/
-
-SPEAR3XX MACHINE SUPPORT
-M:	Viresh Kumar <viresh.linux@gmail.com>
-M:	Shiraz Hashim <shiraz.hashim@st.com>
-L:	spear-devel@list.st.com
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-W:	http://www.st.com/spear
-S:	Maintained
-F:	arch/arm/mach-spear3xx/
-
-SPEAR6XX MACHINE SUPPORT
-M:	Rajeev Kumar <rajeev-dlh.kumar@st.com>
-M:	Shiraz Hashim <shiraz.hashim@st.com>
-M:	Viresh Kumar <viresh.linux@gmail.com>
-L:	spear-devel@list.st.com
-L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-W:	http://www.st.com/spear
-S:	Maintained
-F:	arch/arm/mach-spear6xx/
+F:	arch/arm/mach-spear/
 
 SPEAR CLOCK FRAMEWORK SUPPORT
 M:	Viresh Kumar <viresh.linux@gmail.com>
-- 
1.8.1.2.459.gbcd45b4.dirty


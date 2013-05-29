Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965276Ab3E2Iut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:50:49 -0400
Received: from 13.mo4.mail-out.ovh.net ([178.33.251.8]:57344 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965254Ab3E2IuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:50:19 -0400
From: <plagnioj@jcrosoft.com>
To: linux-kernel@vger.kernel.org
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Olof Johansson <olof@lixom.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH 1/1] MAINTAINERS: Framebuffer Layer maintainers update
Date: Wed, 29 May 2013 10:46:02 +0200
Message-Id: <1369817162-6362-1-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: git-send-email 1.7.10.4
X-Ovh-Tracer-Id: 13939203796900752152
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -51
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrudehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenmhhishhsihhnghcuhfftqffouchfihgvlhguucdlgeelmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -51
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrudehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenmhhishhsihhnghcuhfftqffouchfihgvlhguucdlgeelmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Tomi and I will now take care of the Framebuffer Layer

The git tree is now on kernel.org

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org
---
 MAINTAINERS |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fd3a495..7714c3c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3322,11 +3322,12 @@ F:	drivers/net/wan/dlci.c
 F:	drivers/net/wan/sdla.c
 
 FRAMEBUFFER LAYER
-M:	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
+M:	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
+M:	Tomi Valkeinen <tomi.valkeinen@ti.com>
 L:	linux-fbdev@vger.kernel.org
 W:	http://linux-fbdev.sourceforge.net/
 Q:	http://patchwork.kernel.org/project/linux-fbdev/list/
-T:	git git://github.com/schandinat/linux-2.6.git fbdev-next
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/plagnioj/linux-fbdev.git
 S:	Maintained
 F:	Documentation/fb/
 F:	Documentation/devicetree/bindings/fb/
-- 
1.7.10.4


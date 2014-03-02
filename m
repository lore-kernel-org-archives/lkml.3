Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbaCBVj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 16:39:26 -0500
Received: from mout.gmx.net ([212.227.15.15]:59308 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbaCBVjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 16:39:22 -0500
From: xypron.glpk@gmx.de
To: grant.likely@linaro.org, robh+dt@kernel.org
Cc: devicetree@vger.kernel.org, devicetree-compiler@vger.kernel.org,
        linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] Update source code location for dtc in manual.txt
Date: Sun,  2 Mar 2014 22:39:14 +0100
Message-Id: <1393796354-29704-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.7.10.4
X-Provags-ID: V03:K0:9eaeH34MJfhZaeTTDw0qyc/wkUpJT5uiABJdAPwwpypMbJnQXxL
 +o9U8gO25EVHAP5mpiq+SlLp0G3IPxZsp2zxgfLVC2Tnk0Jce3FkrSckNSmtwBJEsY5vrNX
 qa48ZceNUhDpYV8+JLiUJnhPW2OSpXQ5U3SGxImc96kyFLI08EoQ6XTZrep+YFb+f2OHo2o
 Lh3ySD6+z9Hy3QbnxW5ow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

The information about the location of the source code of the
device tree compiler was inaccurate.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 Documentation/manual.txt |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/Documentation/manual.txt b/Documentation/manual.txt
index 65c8540..0a8e6d5 100644
--- a/Documentation/manual.txt
+++ b/Documentation/manual.txt
@@ -30,25 +30,22 @@ I - "dtc", the device tree compiler
 
 1) Sources
 
-Source code for the Device Tree Compiler can be found at jdl.com.
-The gitweb interface is:
+Source code for the Device Tree Compiler can be found at git.kernel.org.
 
-    http://git.jdl.com/gitweb/
+The upstream repository is here:
 
-The repository is here:
+    git://git.kernel.org/pub/scm/utils/dtc/dtc.git
+    https://git.kernel.org/pub/scm/utils/dtc/dtc.git
 
-    git://www.jdl.com/software/dtc.git
-    http://www.jdl.com/software/dtc.git
+The gitweb interface for the upstream respository is:
 
-Tarballs of the 1.0.0 and latest releases are here:
-
-    http://www.jdl.com/software/dtc-v1.2.0.tgz
-    http://www.jdl.com/software/dtc-latest.tgz
+    https://git.kernel.org/cgit/utils/dtc/dtc.git/ 
 
 1.1) Submitting Patches
 
-Patches should be sent to jdl@jdl.com, and CC'ed to
-devicetree-discuss@lists.ozlabs.org.
+Patches should be sent to the maintainers as determined with
+scripts/get_maintainer.pl of the Linux Kernel source and CC'ed to
+devicetree-compiler@vger.kernel.org.
 
 2) Description
 
-- 
1.7.10.4


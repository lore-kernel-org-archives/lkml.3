Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaCBUqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 15:46:22 -0500
Received: from mout.gmx.net ([212.227.17.20]:65281 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbaCBUqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 15:46:20 -0500
From: xypron.glpk@gmx.de
To: grant.likely@linaro.org, robh+dt@kernel.org
Cc: devicetree@vger.kernel.org, devicetree-compiler@vger.kernel.org,
        linux-kernel@vger.kernel.org, Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] Remove duplicate assignment
Date: Sun,  2 Mar 2014 21:45:57 +0100
Message-Id: <1393793157-29233-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.7.10.4
X-Provags-ID: V03:K0:xSrW+55fKKCkIWb0CgoZ/tNBnjRZRV43AS3wmFtvo2n+qw3g0iJ
 /pnCwnqHq96r4h1i6CyQ8s2oCqC5CLPHskNfVSFE/cMoVi9lxhgHmJ/CYBSvTvZYlX3U4fD
 SHjLaYOA0Xb2W93qMEE/T7tY+V30NqmphD1wS1UyljHIBQ6r8grkJe0qgQCDmKBQC+TKzGY
 A31FEd1TmnALU/0CLbOcg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 tests/testutils.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/tests/testutils.c b/tests/testutils.c
index f185133..521f4f1 100644
--- a/tests/testutils.c
+++ b/tests/testutils.c
@@ -144,7 +144,6 @@ int nodename_eq(const char *s1, const char *s2)
 {
 	int len = strlen(s2);
 
-	len = strlen(s2);
 	if (strncmp(s1, s2, len) != 0)
 		return 0;
 	if (s1[len] == '\0')
-- 
1.7.10.4


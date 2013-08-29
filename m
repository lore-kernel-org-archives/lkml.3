Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab3H2KXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:23:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58030 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab3H2KXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:23:38 -0400
From: Mark Brown <broonie@kernel.org>
To: Steven Miao <realmz6@gmail.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Date: Thu, 29 Aug 2013 11:23:08 +0100
Message-Id: <1377771788-16747-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] blackfin: Ignore generated uImages
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

We have the build infrastructure to generate uImages so we should ignore
the resulting generated files.

Signed-off-by: Mark Brown <broonie@linaro.org>
Acked-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/boot/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/blackfin/boot/.gitignore b/arch/blackfin/boot/.gitignore
index 229e508..1287a54 100644
--- a/arch/blackfin/boot/.gitignore
+++ b/arch/blackfin/boot/.gitignore
@@ -1,2 +1,3 @@
 vmImage*
 vmlinux*
+uImage*
-- 
1.8.4.rc3


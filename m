Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab3HTJjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:39:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52443 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3HTJje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:39:34 -0400
From: Mark Brown <broonie@kernel.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>
Date: Tue, 20 Aug 2013 10:39:22 +0100
Message-Id: <1376991562-26109-1-git-send-email-broonie@kernel.org>
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab3F1OOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:14:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40131 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab3F1OOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:14:37 -0400
From: Mark Brown <broonie@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@linaro.org>
Date: Fri, 28 Jun 2013 15:14:11 +0100
Message-Id: <1372428851-31767-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.1
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] MAINTAINERS: Add include directory to MFD file patterns
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Ensure that get_maintainer.pl does the right thing for header only
changes.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index bd30092..3e56bde 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5506,6 +5506,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-fixes.git
 S:	Supported
 F:	drivers/mfd/
+F:	include/linux/mfd/
 
 MULTIMEDIA CARD (MMC), SECURE DIGITAL (SD) AND SDIO SUBSYSTEM
 M:	Chris Ball <cjb@laptop.org>
-- 
1.8.3.1


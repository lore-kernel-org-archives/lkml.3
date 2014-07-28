Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaG1RbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:31:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbaG1RbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:31:00 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: linux-tegra@vger.kernel.org
Cc: swarren@wwwdotorg.org, thierry.reding@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] MAINTAINERS: Update Tegra Git URL
Date: Mon, 28 Jul 2014 19:30:42 +0200
Message-Id: <1406568643-2047-1-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 2.0.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swarren/linux-tegra.git does not exist, it's tegra/linux.git.

Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 86efa7e..dcda974 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8922,7 +8922,7 @@ M:	Stephen Warren <swarren@wwwdotorg.org>
 M:	Thierry Reding <thierry.reding@gmail.com>
 L:	linux-tegra@vger.kernel.org
 Q:	http://patchwork.ozlabs.org/project/linux-tegra/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tegra/linux.git
 S:	Supported
 N:	[^a-z]tegra
 
-- 
2.0.1


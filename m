Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbaG1SGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:06:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42949 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaG1SGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:06:31 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: arm@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] MAINTAINERS: Update Tegra Git URL
Date: Mon, 28 Jul 2014 12:06:26 -0600
Message-Id: <1406570786-10432-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Färber <afaerber@suse.de>

swarren/linux-tegra.git is a stale location; it has moved to
tegra/linux.git.

While the git protocol re-directs to the new location, HTTP does not.
Besides, MAINTAINERS should contain the canonical URL.

Signed-off-by: Andreas Färber <afaerber@suse.de>
[swarren, updated commit message]
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 86efa7e213c2..dcda974bd7ec 100644
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
1.9.1


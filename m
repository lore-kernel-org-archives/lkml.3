Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967330Ab3DRJdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:33:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40074 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784Ab3DRJRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Robert Tivy <rtivy@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 19/72] remoteproc: fix FW_CONFIG typo
Date: Thu, 18 Apr 2013 10:16:04 +0100
Message-Id: <1366276617-3553-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Tivy <rtivy@ti.com>

commit c7426bce5933d16b492a34e42ae77e26fceddff6 upstream.

Fix obvious typo introduced in commit e121aefa7d9f10eee5cf26ed47129237a05d940b
("remoteproc: fix missing CONFIG_FW_LOADER configurations").

Signed-off-by: Robert Tivy <rtivy@ti.com>
[cc stable, slight subject change]
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
[ luis: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/remoteproc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
index 811ff72..324d84e 100644
--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -4,7 +4,7 @@ menu "Remoteproc drivers (EXPERIMENTAL)"
 config REMOTEPROC
 	tristate
 	depends on EXPERIMENTAL
-	select FW_CONFIG
+	select FW_LOADER
 	select VIRTIO
 
 config OMAP_REMOTEPROC
-- 
1.8.1.2


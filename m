Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734Ab3EGEGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:06:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3816 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760088Ab3EGD6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:50 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=U_DIjI_h8TMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=TKL5J2pauvUA:10 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8 a=2LjLHKtCAAAA:8 a=FaKLYAJVeHm0sZ5W9RoA:9 a=x2szoZtqnggA:10 a=C3PaYh0q9tsA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035845.085077595@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Robert Tivy <rtivy@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [025/126] remoteproc: fix FW_CONFIG typo
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0025-remoteproc-fix-FW_CONFIG-typo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Robert Tivy <rtivy@ti.com>

[ Upstream commit c7426bce5933d16b492a34e42ae77e26fceddff6 ]

Fix obvious typo introduced in commit e121aefa7d9f10eee5cf26ed47129237a05d940b
("remoteproc: fix missing CONFIG_FW_LOADER configurations").

Cc: stable@vger.kernel.org
Signed-off-by: Robert Tivy <rtivy@ti.com>
[cc stable, slight subject change]
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/remoteproc/Kconfig |    2 +-
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
1.7.10.4



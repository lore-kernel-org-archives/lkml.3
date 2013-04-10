Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937374Ab3DJWro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:47:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937332Ab3DJWrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Robert Tivy <rtivy@ti.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [ 40/64] remoteproc: fix FW_CONFIG typo
Date: Wed, 10 Apr 2013 15:46:37 -0700
Message-Id: <20130410224342.535842450@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Tivy <rtivy@ti.com>

commit c7426bce5933d16b492a34e42ae77e26fceddff6 upstream.

Fix obvious typo introduced in commit e121aefa7d9f10eee5cf26ed47129237a05d940b
("remoteproc: fix missing CONFIG_FW_LOADER configurations").

Signed-off-by: Robert Tivy <rtivy@ti.com>
[cc stable, slight subject change]
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/remoteproc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/remoteproc/Kconfig
+++ b/drivers/remoteproc/Kconfig
@@ -5,7 +5,7 @@ config REMOTEPROC
 	tristate
 	depends on EXPERIMENTAL
 	depends on HAS_DMA
-	select FW_CONFIG
+	select FW_LOADER
 	select VIRTIO
 
 config OMAP_REMOTEPROC



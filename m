Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3EaG4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 02:56:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:51270 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab3EaGzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 02:55:50 -0400
From: Ying Xue <ying.xue@windriver.com>
To: <thierry.reding@avionic-design.de>, <tbergstrom@nvidia.com>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] MAINTAINERS: update path for drm tegra driver
Date: Fri, 31 May 2013 14:55:37 +0800
Message-ID: <1369983337-19571-1-git-send-email-ying.xue@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 4231c6b01af9f0f3eeca4b8d0d87125d78233b41 commit, drm tegra
driver was moved to host1x, however, its correspding entry in
MAINTAINERS is not updated in time.

Signed-off-by: Ying Xue <ying.xue@windriver.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7714c3c..d672968 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2702,7 +2702,7 @@ L:	dri-devel@lists.freedesktop.org
 L:	linux-tegra@vger.kernel.org
 T:	git git://gitorious.org/thierryreding/linux.git
 S:	Maintained
-F:	drivers/gpu/drm/tegra/
+F:	drivers/gpu/host1x/drm/
 F:	Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
 
 DSBR100 USB FM RADIO DRIVER
-- 
1.7.9.5


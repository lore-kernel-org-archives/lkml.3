Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaLaM11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 07:27:27 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:57607 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaLaM1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 07:27:23 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        Sudip Mukherjee <sudip@vectorindia.org>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fbdev@vger.kernel.org
Subject: [PATCH 3/3] MAINTAINERS: update for SM7XX driver
Date: Wed, 31 Dec 2014 17:56:45 +0530
Message-Id: <1420028805-30488-3-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1420028805-30488-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1420028805-30488-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add myself and Teddy Wang as the Maintainer of the
SM7XX FRAME BUFFER DRIVER.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6e18e65..4ffe882 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9178,6 +9178,14 @@ L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/staging/rtl8723au/
 
+STAGING - SILICON MOTION SM7XX FRAME BUFFER DRIVER
+M:	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
+M:	Teddy Wang <teddy.wang@siliconmotion.com>
+M:	Sudip Mukherjee <sudip@vectorindia.org>
+L:	linux-fbdev@vger.kernel.org
+S:	Maintained
+F:	drivers/staging/sm7xxfb/
+
 STAGING - SLICOSS
 M:	Lior Dotan <liodot@gmail.com>
 M:	Christopher Harrer <charrer@alacritech.com>
-- 
1.9.1


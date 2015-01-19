Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbbASIMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 03:12:45 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:48065 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbbASIL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 03:11:28 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-fbdev@vger.kernel.org
Subject: [PATCH v2 3/7] MAINTAINERS: update for SM7XX driver
Date: Mon, 19 Jan 2015 13:41:02 +0530
Message-Id: <1421655067-7490-3-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1421655067-7490-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1421655067-7490-1-git-send-email-sudipm.mukherjee@gmail.com>
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
index dbc17b3..4fd647e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9220,6 +9220,14 @@ L:	linux-wireless@vger.kernel.org
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
1.8.1.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaJFJKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:10:31 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:49229 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157AbaJFJK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:10:29 -0400
Message-ID: <1412586626.4054.42.camel@x220>
Subject: [PATCH 3/4] [media] Remove optional dependency on PLAT_S5P
From: Paul Bolle <pebolle@tiscali.nl>
To: Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 06 Oct 2014 11:10:26 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2014 09:10:26.0880 (UTC) FILETIME=[5E573400:01CFE145]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d78c16ccde96 ("ARM: SAMSUNG: Remove remaining legacy code")
removed the Kconfig symbol PLAT_S5P. Remove an optional dependency on
that symbol from this Kconfig file too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/media/platform/s5p-tv/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-tv/Kconfig b/drivers/media/platform/s5p-tv/Kconfig
index a9d56f8936b4..3d11fea5cc92 100644
--- a/drivers/media/platform/s5p-tv/Kconfig
+++ b/drivers/media/platform/s5p-tv/Kconfig
@@ -9,7 +9,7 @@
 config VIDEO_SAMSUNG_S5P_TV
 	bool "Samsung TV driver for S5P platform"
 	depends on PM_RUNTIME
-	depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
+	depends on ARCH_EXYNOS || COMPILE_TEST
 	default n
 	---help---
 	  Say Y here to enable selecting the TV output devices for
-- 
1.9.3


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab3ELWKQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 18:10:16 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:57636 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859Ab3ELWKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 18:10:15 -0400
Message-ID: <1368396610.1350.22.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] [media] exynos4-is: Fix Kconfig comment
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 13 May 2013 00:10:10 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 May 2013 22:10:11.0417 (UTC) FILETIME=[78990490:01CE4F5D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) I did track down the commit that actually introduced this copy/paste
error. But since the error and its fix are obvious it's better to not
bore people with that detail.

 drivers/media/platform/exynos4-is/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
index 6ff99b5..d6d950e3 100644
--- a/drivers/media/platform/exynos4-is/Kconfig
+++ b/drivers/media/platform/exynos4-is/Kconfig
@@ -58,4 +58,4 @@ config VIDEO_EXYNOS4_FIMC_IS
 	  To compile this driver as a module, choose M here: the
 	  module will be called exynos4-fimc-is.
 
-endif # VIDEO_SAMSUNG_S5P_FIMC
+endif # VIDEO_SAMSUNG_EXYNOS4_IS
-- 
1.7.11.7


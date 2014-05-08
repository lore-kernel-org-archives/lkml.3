Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554AbaEHJZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:25:06 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:64583 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850AbaEHJZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:25:03 -0400
From: Ulf Hansson <ulf.hansson@linaro.org>
To: linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>
Cc: linux-kernel@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Ian Molton <ian.molton@codethink.co.uk>
Subject: [PATCH] MAINTAINERS: mmc: Update email for host driver maintainer
Date: Thu,  8 May 2014 11:24:58 +0200
Message-Id: <1399541098-5104-1-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update Ian Molton's email, the maintainer for tmio/sh_mobile_sdhci.

Cc: Ian Molton <ian.molton@codethink.co.uk>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e67ea24..c2803c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9000,7 +9000,7 @@ F:	include/linux/toshiba.h
 F:	include/uapi/linux/toshiba.h
 
 TMIO MMC DRIVER
-M:	Ian Molton <ian@mnementh.co.uk>
+M:	Ian Molton <ian.molton@codethink.co.uk>
 L:	linux-mmc@vger.kernel.org
 S:	Maintained
 F:	drivers/mmc/host/tmio_mmc*
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaBISus (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:50:48 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62422 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaBISsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:40 -0500
From: Richard Weinberger <richard@nod.at>
To: Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 20/28] Remove OMAP_PM_SRF
Date: Sun,  9 Feb 2014 19:47:58 +0100
Message-Id: <1391971686-9517-21-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/staging/tidspbridge/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/tidspbridge/Kconfig b/drivers/staging/tidspbridge/Kconfig
index 1b6d581..b5e74e9 100644
--- a/drivers/staging/tidspbridge/Kconfig
+++ b/drivers/staging/tidspbridge/Kconfig
@@ -17,7 +17,7 @@ menuconfig TIDSPBRIDGE
 
 config TIDSPBRIDGE_DVFS
 	bool "Enable Bridge Dynamic Voltage and Frequency Scaling (DVFS)"
-	depends on TIDSPBRIDGE && OMAP_PM_SRF && CPU_FREQ
+	depends on TIDSPBRIDGE && CPU_FREQ
 	help
 	  DVFS allows DSP Bridge to initiate the operating point change to
 	  scale the chip voltage and frequency in order to match the
-- 
1.8.4.2


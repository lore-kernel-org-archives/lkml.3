Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab3JIIuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:50:08 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:35394 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3JIIuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:50:05 -0400
From: Abelardo Ricart <aricart@gmail.com>
To: linux-pm@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Abelardo Ricart <aricart@gmail.com>
Subject: [PATCH] Thermal: Fix Step-wise governor Kconfig help text
Date: Wed,  9 Oct 2013 17:49:47 +0900
Message-Id: <1381308587-25460-1-git-send-email-aricart@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial fix for the help text of THERMAL_GOV_STEP_WISE.

Signed-off-by: Abelardo Ricart <aricart@gmail.com>
---
 drivers/thermal/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index dbfc390..29007bd 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -69,6 +69,7 @@ config THERMAL_GOV_STEP_WISE
 	bool "Step_wise thermal governor"
 	help
 	  Enable this to manage platform thermals using a simple linear
+	  throttling algorithm.
 
 config THERMAL_GOV_USER_SPACE
 	bool "User_space thermal governor"
-- 
1.8.4


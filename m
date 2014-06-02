Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbaFBI7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 04:59:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38662 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753036AbaFBI6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:58:19 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] mfd: arizona: Lower ARIZONA_MAX_CORE_SUPPLIES to 2
Date: Mon,  2 Jun 2014 09:50:43 +0100
Message-Id: <1401699043-16835-6-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1401699043-16835-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1401699043-16835-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are no Arizona devices with 3 core supplies but we define a fix
array with space for 3 core supplies. Lower the ARIZONA_MAX_CORE_SUPPLIES
define to 2, to save a few bytes.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 include/linux/mfd/arizona/core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mfd/arizona/core.h b/include/linux/mfd/arizona/core.h
index 6acb058..2bf1d74 100644
--- a/include/linux/mfd/arizona/core.h
+++ b/include/linux/mfd/arizona/core.h
@@ -18,7 +18,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/mfd/arizona/pdata.h>
 
-#define ARIZONA_MAX_CORE_SUPPLIES 3
+#define ARIZONA_MAX_CORE_SUPPLIES 2
 
 enum arizona_type {
 	WM5102 = 1,
-- 
1.7.2.5


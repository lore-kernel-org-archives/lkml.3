Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbaCTLMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:12:54 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:64643 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296AbaCTLMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:12:07 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Cc: lee.jones@linaro.org, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        dwmw2@infradead.org, angus.clark@st.com
Subject: [PATCH 3/5] mtd: st_spi_fsm: Correct vendor name spelling issue - missing "M"
Date: Thu, 20 Mar 2014 11:11:45 +0000
Message-Id: <1395313907-25318-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395313907-25318-1-git-send-email-lee.jones@linaro.org>
References: <1395313907-25318-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index 27f9ec9..9de753d 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -3,7 +3,7 @@
  *
  * Author: Angus Clark <angus.clark@st.com>
  *
- * Copyright (C) 2010-2014 STicroelectronics Limited
+ * Copyright (C) 2010-2014 STMicroelectronics Limited
  *
  * JEDEC probe based on drivers/mtd/devices/m25p80.c
  *
-- 
1.8.3.2


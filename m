Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbaBGNXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:23:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41446 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbaBGLr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:47:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 016/233] clk: samsung: exynos4: Correct SRC_MFC register
Date: Fri,  7 Feb 2014 11:43:55 +0000
Message-Id: <1391773652-25214-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seung-Woo Kim <sw0312.kim@samsung.com>

commit 5fdd1b56be51b1ec4dbde5b213d649ac717442da upstream.

The SRC_MFC register offset was incorrect, which could cause have caused
wrong calculation of rate of sclk_mfc clock, that could in turn lead to
incorrect operation of MFC. This patch corrects it.

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Mike Turquette <mturquette@linaro.org>
[t.figa: Updated patch description]
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/clk/samsung/clk-exynos4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index 4e57397..d068ae5 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -40,7 +40,7 @@
 #define SRC_TOP1		0xc214
 #define SRC_CAM			0xc220
 #define SRC_TV			0xc224
-#define SRC_MFC			0xcc28
+#define SRC_MFC			0xc228
 #define SRC_G3D			0xc22c
 #define E4210_SRC_IMAGE		0xc230
 #define SRC_LCD0		0xc234
-- 
1.8.3.2


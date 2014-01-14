Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbaANAgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:36:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbaANA26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 3.12 59/77] clk: samsung: exynos4: Correct SRC_MFC register
Date: Mon, 13 Jan 2014 16:28:20 -0800
Message-Id: <20140114002754.174593835@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/samsung/clk-exynos4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -39,7 +39,7 @@
 #define SRC_TOP1		0xc214
 #define SRC_CAM			0xc220
 #define SRC_TV			0xc224
-#define SRC_MFC			0xcc28
+#define SRC_MFC			0xc228
 #define SRC_G3D			0xc22c
 #define E4210_SRC_IMAGE		0xc230
 #define SRC_LCD0		0xc234



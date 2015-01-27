Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763AbbA0Mdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:33:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35259 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbbA0MTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Voytik <voytikd@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 079/126] ARM: imx6q: drop unnecessary semicolon
Date: Tue, 27 Jan 2015 12:16:24 +0000
Message-Id: <1422361031-19364-80-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Voytik <voytikd@gmail.com>

commit d2a10a1727b3948019128e83162f22c65859f1fd upstream.

Drop unnecessary semicolon after closing curly bracket.

Signed-off-by: Dmitry Voytik <voytikd@gmail.com>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
[ luis: 3.16-stable prereq for:
  9351c09fb16f "usb: gadget: udc: atmel: fix possible IN hang issue" ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-imx/clk-imx6q.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index 8556c787e59c..e9f8dbc360f6 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -164,7 +164,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 		post_div_table[2].div = 1;
 		video_div_table[1].div = 1;
 		video_div_table[2].div = 1;
-	};
+	}
 
 	/*                   type                               name         parent_name  base     div_mask */
 	clk[pll1_sys]      = imx_clk_pllv3(IMX_PLLV3_SYS,	"pll1_sys",	"osc", base,        0x7f);
-- 
2.1.4


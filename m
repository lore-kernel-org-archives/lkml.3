Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762203AbbA2KRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:17:55 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757063AbbA2JBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:01:11 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Voytik <voytikd@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 122/176] ARM: imx6q: drop unnecessary semicolon
Date: Wed, 28 Jan 2015 15:29:12 +0100
Message-Id: <1e3c8f6ce16af79a5308b756e929dee6c289c266.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Voytik <voytikd@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d2a10a1727b3948019128e83162f22c65859f1fd upstream.

Drop unnecessary semicolon after closing curly bracket.

Signed-off-by: Dmitry Voytik <voytikd@gmail.com>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mach-imx/clk-imx6q.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-imx6q.c b/arch/arm/mach-imx/clk-imx6q.c
index ef85ac49d9ac..689f0cfd9795 100644
--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -305,7 +305,7 @@ static void __init imx6q_clocks_init(struct device_node *ccm_node)
 		post_div_table[2].div = 1;
 		video_div_table[1].div = 1;
 		video_div_table[2].div = 1;
-	};
+	}
 
 	/*                   type                               name         parent_name  base     div_mask */
 	clk[pll1_sys]      = imx_clk_pllv3(IMX_PLLV3_SYS,	"pll1_sys",	"osc", base,        0x7f);
-- 
2.2.2


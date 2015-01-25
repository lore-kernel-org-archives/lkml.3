Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbbAYSKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:10:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57208 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387AbbAYSIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:08:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Voytik <voytikd@gmail.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 3.10 38/50] ARM: imx6q: drop unnecessary semicolon
Date: Sun, 25 Jan 2015 10:07:28 -0800
Message-Id: <20150125180704.803049951@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180702.521559311@linuxfoundation.org>
References: <20150125180702.521559311@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Voytik <voytikd@gmail.com>

commit d2a10a1727b3948019128e83162f22c65859f1fd upstream.

Drop unnecessary semicolon after closing curly bracket.

Signed-off-by: Dmitry Voytik <voytikd@gmail.com>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/clk-imx6q.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -302,7 +302,7 @@ int __init mx6q_clocks_init(void)
 		post_div_table[2].div = 1;
 		video_div_table[1].div = 1;
 		video_div_table[2].div = 1;
-	};
+	}
 
 	/*                   type                               name         parent_name  base     div_mask */
 	clk[pll1_sys]      = imx_clk_pllv3(IMX_PLLV3_SYS,	"pll1_sys",	"osc", base,        0x7f);



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaGTOVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:21:46 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:46999 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752415AbaGTOVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:21:43 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIKAO7Py1NXQ0aj/2dsb2JhbABZgw6BKa4jAQEBAQEFAW6dSAGBBBd2hAQBBVYjEFE5HhmIRgGwNJBwF4V7iGxkBxaEMAWbJZQvg0Y7L4ED
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 09/30] rtlwifi: rtl8723be: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:16:17 +0200
Message-Id: <1405865801-18806-10-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405865801-18806-1-git-send-email-fabf@skynet.be>
References: <1405865801-18806-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.c b/drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.c
index e4a507a..4573310 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723be/pwrseqcmd.c
@@ -124,7 +124,6 @@ bool rtlbe_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
 					 "rtlbe_hal_pwrseqcmdparsing(): "
 					 "PWR_CMD_END\n");
 				return true;
-				break;
 			default:
 				RT_ASSERT(false,
 					  "rtlbe_hal_pwrseqcmdparsing(): "
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbaGTOcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:32:17 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:37955 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979AbaGTO0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:26:43 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIKAEfRy1NXQ0aj/2dsb2JhbABZgw6BKa4jAQEBAQEFAW6dSAGBBBd2hAQBBVYjEFE5HhmIRgGwNJBxF4V7iGxkBxaEMAWbJZQvg0Y7L4ED
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 14/30] ath6kl: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:25:15 +0200
Message-Id: <1405866332-24652-5-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405866332-24652-1-git-send-email-fabf@skynet.be>
References: <1405866332-24652-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/ath/ath6kl/init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index d5ef211..8ee7097 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1187,7 +1187,6 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 	default:
 		WARN_ON(1);
 		return -EINVAL;
-		break;
 	}
 
 	if (board_ext_address &&
-- 
1.9.1


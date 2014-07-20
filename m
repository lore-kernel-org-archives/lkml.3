Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbaGTOcy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 10:32:54 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:37955 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752849AbaGTO0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 10:26:40 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIKAEfRy1NXQ0aj/2dsb2JhbABZgw6BKa4jAQEBAQEFAW6dSAGBBBd2hAQBBVYjEFE5HhmIRgGwNJBxF4V7iGxkBxaEMAWbJZQvg0Y7L4ED
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, joe@perches.com, Fabian Frederick <fabf@skynet.be>,
        Solomon Peachy <pizza@shaftnet.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 12/30] cw1200: remove unnecessary break after return
Date: Sun, 20 Jul 2014 16:25:13 +0200
Message-Id: <1405866332-24652-3-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405866332-24652-1-git-send-email-fabf@skynet.be>
References: <1405866332-24652-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/net/wireless/cw1200/fwio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/cw1200/fwio.c b/drivers/net/wireless/cw1200/fwio.c
index e23d67e..6f1b9aa 100644
--- a/drivers/net/wireless/cw1200/fwio.c
+++ b/drivers/net/wireless/cw1200/fwio.c
@@ -290,7 +290,6 @@ static int config_reg_write(struct cw1200_common *priv, u32 val)
 	case HIF_8601_SILICON:
 	default:
 		return cw1200_reg_write_32(priv, ST90TDS_CONFIG_REG_ID, val);
-		break;
 	}
 	return 0;
 }
-- 
1.9.1


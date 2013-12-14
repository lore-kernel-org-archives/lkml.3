Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab3LNMZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 07:25:57 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:55552 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3LNMZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 07:25:55 -0500
Date: Sat, 14 Dec 2013 17:55:42 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, netdev@vger.kernel.org,
        josh@joshtriplett.org
Subject: [PATCH v2 5/9] drivers: net: Put prototype declaration for function
 sbni_probe() in sbni.c
Message-ID: <dd984c99d43214c39b23f95e9a58f3a675147e69.1386911124.git.rashika.kheria@gmail.com>
References: <a610f6ee6bb992b91e43bdc851f3db62fc3decd5.1386911123.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a610f6ee6bb992b91e43bdc851f3db62fc3decd5.1386911123.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch declares the prototype for the function sbni_probe() in file sbni.c.

Thus, it also removes the following warning in wan/sbni.c:
drivers/net/wan/sbni.c:224:12: warning: no previous prototype for ‘sbni_probe’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---

This revision fixes the following issues of the previous revision:
Incorrect fix

 drivers/net/wan/sbni.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
index 388ddf6..5061ffd 100644
--- a/drivers/net/wan/sbni.c
+++ b/drivers/net/wan/sbni.c
@@ -221,6 +221,7 @@ static void __init sbni_devsetup(struct net_device *dev)
 	dev->netdev_ops = &sbni_netdev_ops;
 }
 
+int __init sbni_probe(int unit);
 int __init sbni_probe(int unit)
 {
 	struct net_device *dev;
-- 
1.7.9.5


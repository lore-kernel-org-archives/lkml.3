Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaJSNL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 09:11:29 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64606 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaJSNLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 09:11:10 -0400
From: Chen Weixiang <weixiangchen@gmail.com>
X-Google-Original-From: Chen Weixiang <weixiang.chen@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen Weixiang <weixiang.chen@gmail.com>,
        Greg Donald <gdonald@gmail.com>, Chen Gang <gang.chen.5i5j@gmail.com>,
        Artem Fetishev <wwctrsrx@gmail.com>,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] staging: ft1000: "foo * bar" should be "foo *bar"
Date: Sun, 19 Oct 2014 20:59:50 +0800
Message-Id: <1413723590-19690-8-git-send-email-weixiang.chen@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413723590-19690-1-git-send-email-weixiang.chen@gmail.com>
References: <1413723590-19690-1-git-send-email-weixiang.chen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove code style error form ft1000/ft1000-pcmcia/ft1000_hw.c:
ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Chen Weixiang <weixiang.chen@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 3280a3c..48c1ef2 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -1753,7 +1753,7 @@ static int ft1000_copy_up_pkt(struct net_device *dev)
                 SUCCESS
 
   -------------------------------------------------------------------------*/
-static int ft1000_copy_down_pkt(struct net_device *dev, u16 * packet, u16 len)
+static int ft1000_copy_down_pkt(struct net_device *dev, u16 *packet, u16 len)
 {
 	struct ft1000_info *info = netdev_priv(dev);
 	struct ft1000_pcmcia *pcmcia = info->priv;
-- 
2.1.1


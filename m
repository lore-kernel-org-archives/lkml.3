Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbaKACsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 22:48:03 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:40819 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758102AbaKACr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 22:47:58 -0400
From: Chen Weixiang <weixiangchen@gmail.com>
X-Google-Original-From: Chen Weixiang <weixiang.chen@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen Weixiang <weixiang.chen@gmail.com>,
        Aybuke Ozdemir <aybuke.147@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Nicolas Thery <nthery@gmail.com>, Greg Donald <gdonald@gmail.com>,
        Daniel Dodge <danieldodgese@gmail.com>,
        Wilfried Klaebe <w-lkml@lebenslange-mailadresse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] staging: ft1000: "foo * bar" should be "foo *bar"
Date: Sat,  1 Nov 2014 10:47:25 +0800
Message-Id: <1414810047-6975-5-git-send-email-weixiang.chen@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1414810047-6975-1-git-send-email-weixiang.chen@gmail.com>
References: <1414810047-6975-1-git-send-email-weixiang.chen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove following code style error from ft1000/ft1000-pcmcia/ft1000_hw.c:
ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: Chen Weixiang <weixiang.chen@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 9ef7817..db194bc 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -1758,7 +1758,7 @@ static int ft1000_copy_up_pkt(struct net_device *dev)
                 SUCCESS
 
   -------------------------------------------------------------------------*/
-static int ft1000_copy_down_pkt(struct net_device *dev, u16 * packet, u16 len)
+static int ft1000_copy_down_pkt(struct net_device *dev, u16 *packet, u16 len)
 {
 	struct ft1000_info *info = netdev_priv(dev);
 	struct ft1000_pcmcia *pcmcia = info->priv;
-- 
2.1.2


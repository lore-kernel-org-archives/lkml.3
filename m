Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbaGHQ1b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:27:31 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:4814 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbaGHQ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:27:28 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At4OALAavFNXQDwH/2dsb2JhbABZgw6tGgUBAQEBAQEFAW4BmVmBGBd1hDFSgRo3iEYByXeFeohkZB2ELQWEaQOWCpQMg0U7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH 1/1] video: vermilion: remove unnecessary break after goto
Date: Tue,  8 Jul 2014 18:27:18 +0200
Message-Id: <1404836838-6953-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: linux-fbdev@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/video/fbdev/vermilion/vermilion.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/fbdev/vermilion/vermilion.c b/drivers/video/fbdev/vermilion/vermilion.c
index 048a666..5f930ae 100644
--- a/drivers/video/fbdev/vermilion/vermilion.c
+++ b/drivers/video/fbdev/vermilion/vermilion.c
@@ -481,7 +481,6 @@ static int vml_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	default:
 		err = -ENODEV;
 		goto out_err_1;
-		break;
 	}
 
 	info = &vinfo->info;
-- 
1.8.4.5


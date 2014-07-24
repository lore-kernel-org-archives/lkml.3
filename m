Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934344AbaGXISW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:18:22 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:17892 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934120AbaGXIST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:18:19 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoJAFjA0FNXQzwl/2dsb2JhbABZgw6BKa8XAQEBAQEBBQFuAaA5AYEJF3eEBAEFViMQUTkeGYhGAcAOF4V7iGxkBxaEMAWbM5RCg0o7L4ED
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, gregkh@linuxfoundation.org,
        Fabian Frederick <fabf@skynet.be>, linux-usb@vger.kernel.org
Subject: [PATCH 02/10 linux-next] USB: usblcd: remove unnecessary break after return
Date: Thu, 24 Jul 2014 10:18:50 +0200
Message-Id: <1406189939-6433-3-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1406189939-6433-1-git-send-email-fabf@skynet.be>
References: <1406189939-6433-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/usb/misc/usblcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/misc/usblcd.c b/drivers/usb/misc/usblcd.c
index 1184390..5085d69 100644
--- a/drivers/usb/misc/usblcd.c
+++ b/drivers/usb/misc/usblcd.c
@@ -190,7 +190,6 @@ static long lcd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		break;
 	default:
 		return -ENOTTY;
-		break;
 	}
 
 	return 0;
-- 
1.8.4.5


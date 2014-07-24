Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934403AbaGXIXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:23:21 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:38971 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934120AbaGXIXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:23:19 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoJAEPB0FNXQzwl/2dsb2JhbABZgw6BKa8XAQEBAQEBBQFuAaA5AYEJF3eEBAEFJy8jEFE5HhmIRgHAAReFe4hsZAcWhDAFmzOUQoNKOy+BAw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, gregkh@linuxfoundation.org,
        Fabian Frederick <fabf@skynet.be>, Oliver Neukum <oliver@neukum.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 10/10 linux-next] USB: microtek: remove unnecessary break after goto
Date: Thu, 24 Jul 2014 10:24:34 +0200
Message-Id: <1406190274-6539-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1406189939-6433-1-git-send-email-fabf@skynet.be>
References: <1406189939-6433-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/usb/image/microtek.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 37b44b0..5cf2111 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -294,7 +294,6 @@ static inline void mts_show_command(struct scsi_cmnd *srb)
 	default:
 		MTS_DEBUG("can't decode command\n");
 		goto out;
-		break;
 	}
 	MTS_DEBUG( "Command %s (%d bytes)\n", what, srb->cmd_len);
 
-- 
1.8.4.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934441AbaGXIUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:20:00 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:52587 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934350AbaGXIS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:18:26 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoJAFjA0FNXQzwl/2dsb2JhbABZgw6BKa8XAQEBAQEBBQFuAaA5AYEJF3eEBAEFJy8jEFE5HhmIRgHADheFe4hsG0kHFoQwAQSbM5RCg0o7L4EDAR8
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, gregkh@linuxfoundation.org,
        Fabian Frederick <fabf@skynet.be>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 07/10 linux-next] usb: storage: remove unnecessary break after return
Date: Thu, 24 Jul 2014 10:18:55 +0200
Message-Id: <1406189939-6433-8-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1406189939-6433-1-git-send-email-fabf@skynet.be>
References: <1406189939-6433-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/usb/storage/freecom.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/storage/freecom.c b/drivers/usb/storage/freecom.c
index ef16068..e6f8c1f 100644
--- a/drivers/usb/storage/freecom.c
+++ b/drivers/usb/storage/freecom.c
@@ -417,7 +417,6 @@ static int freecom_transport(struct scsi_cmnd *srb, struct us_data *us)
 			     us->srb->sc_data_direction);
 		/* Return fail, SCSI seems to handle this better. */
 		return USB_STOR_TRANSPORT_FAILED;
-		break;
 	}
 
 	return USB_STOR_TRANSPORT_GOOD;
-- 
1.8.4.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934407AbaGXISu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:18:50 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:52587 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934346AbaGXIS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:18:29 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoJAFjA0FNXQzwl/2dsb2JhbABZgw6BKa8XAQEBAQEBBQFuAaA5AYEJF3eEBAEFViMQUTkeGYhGAcAOF4V7iGxkBxaEMAWbM4tuiFSDSjsvgQM
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, gregkh@linuxfoundation.org,
        Fabian Frederick <fabf@skynet.be>, Johan Hovold <johan@kernel.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 09/10 linux-next] USB: ftdi_sio: remove unnecessary break after return
Date: Thu, 24 Jul 2014 10:18:57 +0200
Message-Id: <1406189939-6433-10-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1406189939-6433-1-git-send-email-fabf@skynet.be>
References: <1406189939-6433-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/usb/serial/ftdi_sio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index b9035c3..bb45c71 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2414,7 +2414,6 @@ static int ftdi_ioctl(struct tty_struct *tty,
 					(struct serial_struct __user *) arg);
 	case TIOCSERGETLSR:
 		return get_lsr_info(port, (struct serial_struct __user *)arg);
-		break;
 	default:
 		break;
 	}
-- 
1.8.4.5


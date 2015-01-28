Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965009AbbA1EXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:23:50 -0500
Received: from mail.kernel.org ([198.145.29.136]:40458 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964977AbbA1EXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:23:45 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Cyril Brulebois <kibi@debian.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 117/177] wireless: rt2x00: add new rt2800usb device
Date: Wed, 28 Jan 2015 12:09:35 +0800
Message-Id: <1422418236-12852-208-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyril Brulebois <kibi@debian.org>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 664d6a792785cc677c2091038ce10322c8d04ae1 upstream.

0x1b75 0xa200 AirLive WN-200USB wireless 11b/g/n dongle

References: https://bugs.debian.org/766802
Reported-by: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Signed-off-by: Cyril Brulebois <kibi@debian.org>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 664e93d..49baf0c 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1081,6 +1081,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Ovislink */
 	{ USB_DEVICE(0x1b75, 0x3071) },
 	{ USB_DEVICE(0x1b75, 0x3072) },
+	{ USB_DEVICE(0x1b75, 0xa200) },
 	/* Para */
 	{ USB_DEVICE(0x20b8, 0x8888) },
 	/* Pegatron */
-- 
1.9.1


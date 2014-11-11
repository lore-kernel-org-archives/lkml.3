Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648AbaKKLNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:13:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57942 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbaKKLLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Cyril Brulebois <kibi@debian.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 164/170] wireless: rt2x00: add new rt2800usb device
Date: Tue, 11 Nov 2014 11:08:43 +0000
Message-Id: <1415704129-12709-165-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyril Brulebois <kibi@debian.org>

commit 664d6a792785cc677c2091038ce10322c8d04ae1 upstream.

0x1b75 0xa200 AirLive WN-200USB wireless 11b/g/n dongle

References: https://bugs.debian.org/766802
Reported-by: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Signed-off-by: Cyril Brulebois <kibi@debian.org>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 573897b8e878..8444313eabe2 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1111,6 +1111,7 @@ static struct usb_device_id rt2800usb_device_table[] = {
 	/* Ovislink */
 	{ USB_DEVICE(0x1b75, 0x3071) },
 	{ USB_DEVICE(0x1b75, 0x3072) },
+	{ USB_DEVICE(0x1b75, 0xa200) },
 	/* Para */
 	{ USB_DEVICE(0x20b8, 0x8888) },
 	/* Pegatron */
-- 
2.1.0


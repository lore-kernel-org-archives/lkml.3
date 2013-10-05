Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3JEQLr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 12:11:47 -0400
Received: from libra.uberspace.de ([95.143.172.171]:45249 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752559Ab3JEQLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 12:11:25 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH 4/5] drivers: usb: core: hcd: removed braces for return statements
Date: Sat,  5 Oct 2013 18:02:09 +0200
Message-Id: <9bf587e8b1031f3187f1123c4b546eb8d72cfe86.1380986962.git.mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1380986962.git.mail@beyermatthias.de>
References: <cover.1380986962.git.mail@beyermatthias.de>
In-Reply-To: <cover.1380986962.git.mail@beyermatthias.de>
References: <cover.1380986962.git.mail@beyermatthias.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
---
 drivers/usb/core/hcd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 3a2667c..5d13d6c 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1120,18 +1120,18 @@ long usb_calc_bus_time (int speed, int is_input, int isoc, int bytecount)
 	case USB_SPEED_LOW: 	/* INTR only */
 		if (is_input) {
 			tmp = (67667L * (31L + 10L * BitTime (bytecount))) / 1000L;
-			return (64060L + (2 * BW_HUB_LS_SETUP) + BW_HOST_DELAY + tmp);
+			return 64060L + (2 * BW_HUB_LS_SETUP) + BW_HOST_DELAY + tmp;
 		} else {
 			tmp = (66700L * (31L + 10L * BitTime (bytecount))) / 1000L;
-			return (64107L + (2 * BW_HUB_LS_SETUP) + BW_HOST_DELAY + tmp);
+			return 64107L + (2 * BW_HUB_LS_SETUP) + BW_HOST_DELAY + tmp;
 		}
 	case USB_SPEED_FULL:	/* ISOC or INTR */
 		if (isoc) {
 			tmp = (8354L * (31L + 10L * BitTime (bytecount))) / 1000L;
-			return (((is_input) ? 7268L : 6265L) + BW_HOST_DELAY + tmp);
+			return ((is_input) ? 7268L : 6265L) + BW_HOST_DELAY + tmp;
 		} else {
 			tmp = (8354L * (31L + 10L * BitTime (bytecount))) / 1000L;
-			return (9107L + BW_HOST_DELAY + tmp);
+			return 9107L + BW_HOST_DELAY + tmp;
 		}
 	case USB_SPEED_HIGH:	/* ISOC or INTR */
 		/* FIXME adjust for input vs output */
-- 
1.8.4


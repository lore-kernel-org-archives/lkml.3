Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904Ab3CYTwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 15:52:04 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:61506 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758884Ab3CYTwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 15:52:03 -0400
Message-ID: <1364241121.1390.292.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] fix comment typo "CONFIG_HID_PICOLCD_LIRC"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 20:52:01 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2013 19:52:01.0531 (UTC) FILETIME=[379CCCB0:01CE2992]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 drivers/hid/hid-picolcd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-picolcd.h b/drivers/hid/hid-picolcd.h
index 020cef6..88c7c93 100644
--- a/drivers/hid/hid-picolcd.h
+++ b/drivers/hid/hid-picolcd.h
@@ -302,7 +302,7 @@ static inline int picolcd_init_cir(struct picolcd_data *data, struct hid_report
 static inline void picolcd_exit_cir(struct picolcd_data *data)
 {
 }
-#endif /* CONFIG_HID_PICOLCD_LIRC */
+#endif /* CONFIG_HID_PICOLCD_CIR */
 
 int picolcd_reset(struct hid_device *hdev);
 struct picolcd_pending *picolcd_send_and_wait(struct hid_device *hdev,
-- 
1.7.11.7


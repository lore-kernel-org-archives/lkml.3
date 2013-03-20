Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab3CTM1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:27:52 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:65180 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab3CTM1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:27:51 -0400
From: Alice Ferrazzi <alice.ferrazzi@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Alice Ferrazzi <alice.ferrazzi@gmail.com>
Subject: [PATCH] Staging: comedi: serial2002: fixed consistent spacing issue
Date: Wed, 20 Mar 2013 21:26:51 +0900
Message-Id: <1363782411-11729-1-git-send-email-alice.ferrazzi@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed consistent spacing around '*'.

Signed-off-by: Alice Ferrazzi <alice.ferrazzi@gmail.com>
---
 drivers/staging/comedi/drivers/serial2002.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index e6177b4..858d364 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -604,7 +604,7 @@ static int serial_2002_open(struct comedi_device *dev)
 							    c[j].max;
 							range_table_list[chan] =
 							    (const struct
-							     comedi_lrange *)
+							     comedi_lrange*)
 							    &range[j];
 						}
 						maxdata_list[chan] =
-- 
1.7.10.4


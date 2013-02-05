Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab3BEWN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:13:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48297 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758080Ab3BEWN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:13:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jacob Schloss <jacob.schloss@unlimitedautomata.com>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 92/93] gspca_kinect: add Kinect for Windows USB id
Date: Tue,  5 Feb 2013 20:07:21 -0200
Message-Id: <1360102042-10732-93-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Schloss <jacob.schloss@unlimitedautomata.com>

commit 98fd485795db064d0885150e2c0c7f296d8fe06e upstream.

Add the USB ID for the Kinect for Windows RGB camera so it can be used
with the gspca_kinect driver.

Signed-off-by: Jacob Schloss <jacob.schloss@unlimitedautomata.com>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
[ herton: drivers/media/usb/gspca/kinect.c ->
  drivers/media/video/gspca/kinect.c ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/media/video/gspca/kinect.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/video/gspca/kinect.c b/drivers/media/video/gspca/kinect.c
index e8e8f2f..bfbc228 100644
--- a/drivers/media/video/gspca/kinect.c
+++ b/drivers/media/video/gspca/kinect.c
@@ -390,6 +390,7 @@ static const struct sd_desc sd_desc = {
 /* -- module initialisation -- */
 static const struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x045e, 0x02ae)},
+	{USB_DEVICE(0x045e, 0x02bf)},
 	{}
 };
 
-- 
1.7.9.5


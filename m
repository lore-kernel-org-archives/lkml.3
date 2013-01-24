Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946030Ab3AXVbm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:31:42 -0500
Received: from mail.kernel.org ([198.145.19.201]:40238 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756813Ab3AXVO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:14:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jacob Schloss <jacob.schloss@unlimitedautomata.com>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 26/46] media: gspca_kinect: add Kinect for Windows USB id
Date: Thu, 24 Jan 2013 13:13:04 -0800
Message-Id: <20130124211145.630454354@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211135.862755794@linuxfoundation.org>
References: <20130124211135.862755794@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Schloss <jacob.schloss@unlimitedautomata.com>

commit 98fd485795db064d0885150e2c0c7f296d8fe06e upstream.

Add the USB ID for the Kinect for Windows RGB camera so it can be used
with the gspca_kinect driver.

Signed-off-by: Jacob Schloss <jacob.schloss@unlimitedautomata.com>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/gspca/kinect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/usb/gspca/kinect.c
+++ b/drivers/media/usb/gspca/kinect.c
@@ -381,6 +381,7 @@ static const struct sd_desc sd_desc = {
 /* -- module initialisation -- */
 static const struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x045e, 0x02ae)},
+	{USB_DEVICE(0x045e, 0x02bf)},
 	{}
 };
 



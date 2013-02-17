Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab3BQWzu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:55:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45803 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756349Ab3BQWzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:43 -0500
Message-Id: <20130217225005.139593911@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:31 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        Jacob Schloss <jacob.schloss@unlimitedautomata.com>,
        Antonio Ospite <ospite@studenti.unina.it>,
        Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [ 30/66] [media] gspca_kinect: add Kinect for Windows USB id
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Schloss <jacob.schloss@unlimitedautomata.com>

commit 98fd485795db064d0885150e2c0c7f296d8fe06e upstream.

Add the USB ID for the Kinect for Windows RGB camera so it can be used
with the gspca_kinect driver.

Signed-off-by: Jacob Schloss <jacob.schloss@unlimitedautomata.com>
Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/usb/gspca/kinect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/video/gspca/kinect.c
+++ b/drivers/media/video/gspca/kinect.c
@@ -390,6 +390,7 @@ static const struct sd_desc sd_desc = {
 /* -- module initialisation -- */
 static const struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x045e, 0x02ae)},
+	{USB_DEVICE(0x045e, 0x02bf)},
 	{}
 };
 



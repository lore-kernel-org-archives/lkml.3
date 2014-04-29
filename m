Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaD2CMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 22:12:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53499 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537AbaD2CMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 22:12:00 -0400
X-Sasl-enc: h0ORccvxQtEJH5YE2lAhDxd4mAy3Uz/VGSS9ym0fCsS/ 1398737519
Message-ID: <535F0A4D.6080408@fastmail.fm>
Date: Tue, 29 Apr 2014 10:11:25 +0800
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/10] staging: gdm72xx: Moved logical continuation to previous
 line to conform to coding style
References: <532BF9B0.2080008@fastmail.fm> <20140418225229.GA28077@kroah.com> <53534051.2020504@fastmail.fm> <53534116.3040705@fastmail.fm> <20140422093743.GC26890@mwanda> <53570BAA.3080709@fastmail.fm> <20140423080447.GS26890@mwanda> <53577E96.10106@fastmail.fm> <20140423090557.GU26890@mwanda> <20140423090904.GV26890@mwanda> <535F0866.2060207@fastmail.fm>
In-Reply-To: <535F0866.2060207@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Moved logical continuation to previous line to conform to coding style

---
 drivers/staging/gdm72xx/gdm_usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index 9ddf8f5..b9d7643 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -518,8 +518,8 @@ static void do_pm_control(struct work_struct *work)
 		usb_autopm_put_interface(udev->intf);
 
 	spin_lock_irqsave(&tx->lock, flags);
-	if (!(udev->usbdev->state & USB_STATE_SUSPENDED)
-		&& (!list_empty(&tx->hci_list) || !list_empty(&tx->sdu_list))) {
+	if (!(udev->usbdev->state & USB_STATE_SUSPENDED) &&
+	     (!list_empty(&tx->hci_list) || !list_empty(&tx->sdu_list))) {
 		struct usb_tx *t, *temp;
 
 		list_for_each_entry_safe(t, temp, &tx->pending_list, p_list) {
-- 
1.8.4


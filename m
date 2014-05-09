Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbaEIKJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 06:09:28 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53691 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551AbaEIKJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 06:09:26 -0400
X-Sasl-enc: Y+OmVBODTvWg8ZgkwFs51j5Cb/u3suTY+woRxgVG/OFb 1399630160
From: Michalis Pappas <mpappas@fastmail.fm>
To: gregkh@linuxfoundation.org, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Michalis Pappas <mpappas@fastmail.fm>
Subject: [PATCH v5 04/10] staging: gdm72xx: Move logical continuation to previous line to conform to coding style
Date: Fri,  9 May 2014 18:08:23 +0800
Message-Id: <1399630109-18701-4-git-send-email-mpappas@fastmail.fm>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <536CA86B.7000109@fastmail.fm>
References: <536CA86B.7000109@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the following checkpatch.pl issue:

CHECK: Logical continuations should be on the previous line

Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
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


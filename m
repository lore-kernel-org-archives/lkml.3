Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934469AbaGXIVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 04:21:11 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:39407 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934305AbaGXISV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 04:18:21 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoJAFjA0FNXQzwl/2dsb2JhbABZgw6BKa8XAQEBAQEBBQFuAaA5AYEJF3eEBAEFViMQUTkeGYhGAcAOF4V7iVAHFoQwBZszlEKDSjsv
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: joe@perches.com, gregkh@linuxfoundation.org,
        Fabian Frederick <fabf@skynet.be>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH 03/10 linux-next] usb: dcw3: remove unnecessary break after return
Date: Thu, 24 Jul 2014 10:18:51 +0200
Message-Id: <1406189939-6433-4-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1406189939-6433-1-git-send-email-fabf@skynet.be>
References: <1406189939-6433-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/usb/dwc3/ep0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/dwc3/ep0.c b/drivers/usb/dwc3/ep0.c
index 21a3520..927dad3 100644
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@ -422,7 +422,6 @@ static int dwc3_ep0_handle_feature(struct dwc3 *dwc,
 
 		case USB_DEVICE_LTM_ENABLE:
 			return -EINVAL;
-			break;
 
 		case USB_DEVICE_TEST_MODE:
 			if ((wIndex & 0xff) != 0)
@@ -530,7 +529,6 @@ static int dwc3_ep0_set_config(struct dwc3 *dwc, struct usb_ctrlrequest *ctrl)
 	switch (state) {
 	case USB_STATE_DEFAULT:
 		return -EINVAL;
-		break;
 
 	case USB_STATE_ADDRESS:
 		ret = dwc3_ep0_delegate_req(dwc, ctrl);
-- 
1.8.4.5


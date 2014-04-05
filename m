Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbaDEVfY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 17:35:24 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:57933 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaDEVfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 17:35:20 -0400
From: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        silentquote@gmail.com,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
Subject: [PATCH 10/10] driver: staging: wlan-ng: Removed unnecessary spaces after cast from hfa384x_usb.c
Date: Sat,  5 Apr 2014 23:35:15 +0200
Message-Id: <1396733715-16083-1-git-send-email-shehabaldin.sherif@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed: No space is necessary after a cast

Signed-off-by: Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 867edb4..f0ab5a2 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -673,7 +673,7 @@ static inline int usbctlx_cmd_completor_fn(struct usbctlx_completor *head)
 {
 	struct usbctlx_cmd_completor *complete;
 
-	complete = (struct usbctlx_cmd_completor *) head;
+	complete = (struct usbctlx_cmd_completor *)head;
 	return usbctlx_get_status(complete->cmdresp, complete->result);
 }
 
@@ -708,7 +708,7 @@ static int usbctlx_rrid_completor_fn(struct usbctlx_completor *head)
 	struct usbctlx_rrid_completor *complete;
 	hfa384x_rridresult_t rridresult;
 
-	complete = (struct usbctlx_rrid_completor *) head;
+	complete = (struct usbctlx_rrid_completor *)head;
 	usbctlx_get_rridresult(complete->rridresp, &rridresult);
 
 	/* Validate the length, note body len calculation in bytes */
@@ -2819,7 +2819,7 @@ void hfa384x_tx_timeout(wlandevice_t *wlandev)
 ----------------------------------------------------------------*/
 static void hfa384x_usbctlx_reaper_task(unsigned long data)
 {
-	hfa384x_t *hw = (hfa384x_t *) data;
+	hfa384x_t *hw = (hfa384x_t *)data;
 	struct list_head *entry;
 	struct list_head *temp;
 	unsigned long flags;
@@ -2856,7 +2856,7 @@ static void hfa384x_usbctlx_reaper_task(unsigned long data)
 ----------------------------------------------------------------*/
 static void hfa384x_usbctlx_completion_task(unsigned long data)
 {
-	hfa384x_t *hw = (hfa384x_t *) data;
+	hfa384x_t *hw = (hfa384x_t *)data;
 	struct list_head *entry;
 	struct list_head *temp;
 	unsigned long flags;
@@ -3128,7 +3128,7 @@ static void hfa384x_usbin_callback(struct urb *urb)
 {
 	wlandevice_t *wlandev = urb->context;
 	hfa384x_t *hw;
-	hfa384x_usbin_t *usbin = (hfa384x_usbin_t *) urb->transfer_buffer;
+	hfa384x_usbin_t *usbin = (hfa384x_usbin_t *)urb->transfer_buffer;
 	struct sk_buff *skb = NULL;
 	int result;
 	int urb_status;
@@ -3456,7 +3456,7 @@ static void hfa384x_usbin_txcompl(wlandevice_t *wlandev,
 ----------------------------------------------------------------*/
 static void hfa384x_usbin_rx(wlandevice_t *wlandev, struct sk_buff *skb)
 {
-	hfa384x_usbin_t *usbin = (hfa384x_usbin_t *) skb->data;
+	hfa384x_usbin_t *usbin = (hfa384x_usbin_t *)skb->data;
 	hfa384x_t *hw = wlandev->priv;
 	int hdrlen;
 	struct p80211_rxmeta *rxmeta;
@@ -3601,7 +3601,7 @@ static void hfa384x_int_rxmonitor(wlandevice_t *wlandev,
 		struct p80211_caphdr *caphdr;
 		/* The NEW header format! */
 		datap = skb_put(skb, sizeof(struct p80211_caphdr));
-		caphdr = (struct p80211_caphdr *) datap;
+		caphdr = (struct p80211_caphdr *)datap;
 
 		caphdr->version = htonl(P80211CAPTURE_VERSION);
 		caphdr->length = htonl(sizeof(struct p80211_caphdr));
@@ -3896,7 +3896,7 @@ delresp:
 ----------------------------------------------------------------*/
 static void hfa384x_usbctlx_reqtimerfn(unsigned long data)
 {
-	hfa384x_t *hw = (hfa384x_t *) data;
+	hfa384x_t *hw = (hfa384x_t *)data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hw->ctlxq.lock, flags);
@@ -3954,7 +3954,7 @@ static void hfa384x_usbctlx_reqtimerfn(unsigned long data)
 ----------------------------------------------------------------*/
 static void hfa384x_usbctlx_resptimerfn(unsigned long data)
 {
-	hfa384x_t *hw = (hfa384x_t *) data;
+	hfa384x_t *hw = (hfa384x_t *)data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hw->ctlxq.lock, flags);
@@ -3993,7 +3993,7 @@ static void hfa384x_usbctlx_resptimerfn(unsigned long data)
 ----------------------------------------------------------------*/
 static void hfa384x_usb_throttlefn(unsigned long data)
 {
-	hfa384x_t *hw = (hfa384x_t *) data;
+	hfa384x_t *hw = (hfa384x_t *)data;
 	unsigned long flags;
 
 	spin_lock_irqsave(&hw->ctlxq.lock, flags);
-- 
1.7.9.5


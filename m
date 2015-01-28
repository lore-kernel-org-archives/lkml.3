Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbbA1Uxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:53:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbbA1Uxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:53:41 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] Input - synaptics: Remove X1 Carbon 3rd gen from the topbuttonpad list
Date: Wed, 28 Jan 2015 15:10:07 -0500
Message-Id: <1422475807-15033-5-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1422475807-15033-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1422475807-15033-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lenovo decided to switch back to physical buttons for the trackstick
on their latest series. The PNPId list was provided before they reverted
back to physical buttons, so it contains the new models too.
We can know from the touchpad capabilities that the touchpad has physical
buttons, so removing the ids from the list is not mandatory. It is still
nicer to remove the wrong ids, so start by removing the X1 Carbon 3rd gen,
with the PNPId of LEN0048.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/mouse/synaptics.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 4f05c9f..b2944ee 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -173,7 +173,6 @@ static const char * const topbuttonpad_pnp_ids[] = {
 	"LEN0045",
 	"LEN0046",
 	"LEN0047",
-	"LEN0048",
 	"LEN0049",
 	"LEN2000",
 	"LEN2001", /* Edge E431 */
-- 
2.1.0


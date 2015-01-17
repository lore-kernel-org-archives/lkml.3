Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbbAQR2f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 12:28:35 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:35107 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbbAQR2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 12:28:34 -0500
From: Jason Lee Cragg <jcragg@gmail.com>
X-Google-Original-From: Jason Lee Cragg < jcragg@gmail.com >
To: perex@perex.cz, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Jason Lee Cragg <jcragg@gmail.com>
Subject: [PATCH] Add Logitech Webcam C210 to list of Logitech webcams that require mic volume fix
Date: Sat, 17 Jan 2015 12:28:29 -0500
Message-Id: <1421515709-9923-1-git-send-email-jcragg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Lee Cragg <jcragg@gmail.com>

Signed-off-by: Jason Lee Cragg <jcragg@gmail.com>
---
 sound/usb/mixer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 41650d5..3e2ef61 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -913,6 +913,7 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
 	case USB_ID(0x046d, 0x0807): /* Logitech Webcam C500 */
 	case USB_ID(0x046d, 0x0808):
 	case USB_ID(0x046d, 0x0809):
+	case USB_ID(0x046d, 0x0819): /* Logitech Webcam C210 */
 	case USB_ID(0x046d, 0x081b): /* HD Webcam c310 */
 	case USB_ID(0x046d, 0x081d): /* HD Webcam c510 */
 	case USB_ID(0x046d, 0x0825): /* HD Webcam c270 */
-- 
1.9.1


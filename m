Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbbA2JA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:00:56 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756668AbbA2JAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:48 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jason Lee Cragg <jcragg@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 143/176] ALSA: usb-audio: Add mic volume fix quirk for Logitech Webcam C210
Date: Wed, 28 Jan 2015 15:29:33 +0100
Message-Id: <2b53c0d413ab66c4a27a8b91306e45387970c5bd.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Lee Cragg <jcragg@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6455931186bff407493135e74c5f32efd30860e2 upstream.

Signed-off-by: Jason Lee Cragg <jcragg@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/usb/mixer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index be4db47cb2d9..061be0e5fa5a 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -886,6 +886,7 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
 	case USB_ID(0x046d, 0x0807): /* Logitech Webcam C500 */
 	case USB_ID(0x046d, 0x0808):
 	case USB_ID(0x046d, 0x0809):
+	case USB_ID(0x046d, 0x0819): /* Logitech Webcam C210 */
 	case USB_ID(0x046d, 0x081b): /* HD Webcam c310 */
 	case USB_ID(0x046d, 0x081d): /* HD Webcam c510 */
 	case USB_ID(0x046d, 0x0825): /* HD Webcam c270 */
-- 
2.2.2


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab3LBUpV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:45:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3LBTN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 112/173] ALSA: hda/realtek - Set pcbeep amp for ALC668
Date: Mon,  2 Dec 2013 11:11:35 -0800
Message-Id: <20131202191156.739378475@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 9ad54547cf6f4410eba83bb95dfd2a0966718d6d upstream.

Set the missing pcbeep default amp for ALC668.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4494,6 +4494,7 @@ static int patch_alc662(struct hda_codec
 		case 0x10ec0272:
 		case 0x10ec0663:
 		case 0x10ec0665:
+		case 0x10ec0668:
 			set_beep_amp(spec, 0x0b, 0x04, HDA_INPUT);
 			break;
 		case 0x10ec0273:



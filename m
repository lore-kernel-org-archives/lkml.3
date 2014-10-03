Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbaJCVnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:43:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbaJCVcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Huacai Chen <chenhc@lemote.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.16 062/357] ALSA: hda - Add fixup model name lookup for Lemote A1205
Date: Fri,  3 Oct 2014 14:27:28 -0700
Message-Id: <20141003212935.319587449@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhc@lemote.com>

commit 8245b3634516e6b7eb1c94594c0fd41d233502aa upstream.

Lemote A1004 is already added in commit a2dd933d01f (ALSA: hda - Add
fixup name lookup for CX5051 and 5066 codecs), but Lemote A1205 has
missing.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -3382,6 +3382,7 @@ static const struct hda_model_fixup cxt5
 	{ .id = CXT_PINCFG_LENOVO_TP410, .name = "tp410" },
 	{ .id = CXT_FIXUP_THINKPAD_ACPI, .name = "thinkpad" },
 	{ .id = CXT_PINCFG_LEMOTE_A1004, .name = "lemote-a1004" },
+	{ .id = CXT_PINCFG_LEMOTE_A1205, .name = "lemote-a1205" },
 	{ .id = CXT_FIXUP_OLPC_XO, .name = "olpc-xo" },
 	{}
 };



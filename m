Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab3L2CLX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:11:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55713 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689Ab3L2CLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:11:21 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.866403094@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 032/185] ALSA: hda - Add support for CX20952
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8f42d7698751a45cd9f7134a5da49bc5b6206179 upstream.

It's a superset of the existing CX2075x codecs, so we can reuse the
existing parser code.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/patch_conexant.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -4610,6 +4610,8 @@ static const struct hda_codec_preset snd
 	  .patch = patch_conexant_auto },
 	{ .id = 0x14f15115, .name = "CX20757",
 	  .patch = patch_conexant_auto },
+	{ .id = 0x14f151d7, .name = "CX20952",
+	  .patch = patch_conexant_auto },
 	{} /* terminator */
 };
 
@@ -4636,6 +4638,7 @@ MODULE_ALIAS("snd-hda-codec-id:14f15111"
 MODULE_ALIAS("snd-hda-codec-id:14f15113");
 MODULE_ALIAS("snd-hda-codec-id:14f15114");
 MODULE_ALIAS("snd-hda-codec-id:14f15115");
+MODULE_ALIAS("snd-hda-codec-id:14f151d7");
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Conexant HD-audio codec");


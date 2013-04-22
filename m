Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3DVOrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:47:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51479 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754654Ab3DVO3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:49 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "David Henningsson" <david.henningsson@canonical.com>,
        "Takashi Iwai" <tiwai@suse.de>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.2569738@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [65/75] ALSA: hda - fix typo in proc output
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit aeb3a97222832e5457c4b72d72235098ce4bfe8d upstream.

Rename "Digitial In" to "Digital In". This function is only used for
proc output, so should not cause any problems to change.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/hda_codec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -163,7 +163,7 @@ const char *snd_hda_get_jack_type(u32 cf
 		"Line Out", "Speaker", "HP Out", "CD",
 		"SPDIF Out", "Digital Out", "Modem Line", "Modem Hand",
 		"Line In", "Aux", "Mic", "Telephony",
-		"SPDIF In", "Digitial In", "Reserved", "Other"
+		"SPDIF In", "Digital In", "Reserved", "Other"
 	};
 
 	return jack_types[(cfg & AC_DEFCFG_DEVICE)


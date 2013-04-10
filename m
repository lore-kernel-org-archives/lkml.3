Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937544Ab3DJW4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:56:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937470Ab3DJWur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:50:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 05/19] ALSA: hda - fix typo in proc output
Date: Wed, 10 Apr 2013 15:50:28 -0700
Message-Id: <20130410225027.371703168@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410225026.833809117@linuxfoundation.org>
References: <20130410225026.833809117@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

commit aeb3a97222832e5457c4b72d72235098ce4bfe8d upstream.

Rename "Digitial In" to "Digital In". This function is only used for
proc output, so should not cause any problems to change.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_codec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -157,7 +157,7 @@ const char *snd_hda_get_jack_type(u32 cf
 		"Line Out", "Speaker", "HP Out", "CD",
 		"SPDIF Out", "Digital Out", "Modem Line", "Modem Hand",
 		"Line In", "Aux", "Mic", "Telephony",
-		"SPDIF In", "Digitial In", "Reserved", "Other"
+		"SPDIF In", "Digital In", "Reserved", "Other"
 	};
 
 	return jack_types[(cfg & AC_DEFCFG_DEVICE)



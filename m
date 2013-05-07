Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759212Ab3EGEPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:15:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21552 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578Ab3EGD6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:43 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=UPgyCRZ8kasA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=dJI0pMwu_ysA:10 a=DfNHnWVPAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=lBRciGGoxdUA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035842.419723811@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Henningsson <david.henningsson@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [009/126] ALSA: hda - fix typo in proc output
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0009-ALSA-hda-fix-typo-in-proc-output.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: David Henningsson <david.henningsson@canonical.com>

[ Upstream commit aeb3a97222832e5457c4b72d72235098ce4bfe8d ]

Rename "Digitial In" to "Digital In". This function is only used for
proc output, so should not cause any problems to change.

Signed-off-by: David Henningsson <david.henningsson@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/pci/hda/hda_codec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index f60254d..558b6b0 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -165,7 +165,7 @@ const char *snd_hda_get_jack_type(u32 cfg)
 		"Line Out", "Speaker", "HP Out", "CD",
 		"SPDIF Out", "Digital Out", "Modem Line", "Modem Hand",
 		"Line In", "Aux", "Mic", "Telephony",
-		"SPDIF In", "Digitial In", "Reserved", "Other"
+		"SPDIF In", "Digital In", "Reserved", "Other"
 	};
 
 	return jack_types[(cfg & AC_DEFCFG_DEVICE)
-- 
1.7.10.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaE0GzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 02:55:00 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:2324 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474AbaE0Gy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 02:54:58 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMNAJY2hFNXQ2ut/2dsb2JhbABZgweCRahfBQEBAQEBBQGDPJRQgQsXdIJTExwjGIECJBOIRgHUKYVViBlkhEcBA48/ijMBkyeDOjuBMA
Date: Tue, 27 May 2014 08:54:52 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] sound/aoa/codecs/onyx.c: use static const for texts
Message-Id: <20140527085452.5fc3f193971c47e6bac295d8@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'texts' is only used as source in strcpy

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
This is untested.

 sound/aoa/codecs/onyx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/aoa/codecs/onyx.c b/sound/aoa/codecs/onyx.c
index f01bffb..401107b 100644
--- a/sound/aoa/codecs/onyx.c
+++ b/sound/aoa/codecs/onyx.c
@@ -241,7 +241,7 @@ static struct snd_kcontrol_new inputgain_control = {
 static int onyx_snd_capture_source_info(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_info *uinfo)
 {
-	static char *texts[] = { "Line-In", "Microphone" };
+	static const char * const texts[] = { "Line-In", "Microphone" };
 
 	uinfo->type = SNDRV_CTL_ELEM_TYPE_ENUMERATED;
 	uinfo->count = 1;
-- 
1.9.1


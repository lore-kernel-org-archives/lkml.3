Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaE0G6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 02:58:23 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:3951 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751472AbaE0G6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 02:58:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlUJABA3hFNXQ2ut/2dsb2JhbABZgweCRaheBQEBAQEHgzyUUIELF3SCZhwjGGoYJBOILgMVAc1sDYYaF4VVhW55gTIWToRHAQOXfYF1AY01hXKDOjuBMA
Date: Tue, 27 May 2014 08:57:55 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH 1/1] sound/soc/codecs/wm0010.c: add static to local variable
Message-Id: <20140527085755.4eab635574991c688f980685@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add const to array

 text	   data	    bss	    dec	    hex	filename
 10946	   2904	   3528	  17378	   43e2	sound/soc/codecs/wm0010.o-before
 10891	   2840	   3512	  17243	   435b	sound/soc/codecs/wm0010.o-after

Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 sound/soc/codecs/wm0010.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm0010.c b/sound/soc/codecs/wm0010.c
index 71ce315..65d7c79 100644
--- a/sound/soc/codecs/wm0010.c
+++ b/sound/soc/codecs/wm0010.c
@@ -144,7 +144,7 @@ static const struct snd_soc_dapm_route wm0010_dapm_routes[] = {
 
 static const char *wm0010_state_to_str(enum wm0010_state state)
 {
-	const char *state_to_str[] = {
+	static const char * const state_to_str[] = {
 		"Power off",
 		"Out of reset",
 		"Boot ROM",
-- 
1.9.1

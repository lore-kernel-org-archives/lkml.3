Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384Ab3KIH14 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:27:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274Ab3KIGvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.10 42/74] ASoC: dapm: Fix source list debugfs outputs
Date: Fri,  8 Nov 2013 22:51:47 -0800
Message-Id: <20131109065116.480117171@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ff18620c2157671a8ee21ebb8e6a3520ea209b1f upstream.

... due to a copy & paste error.

Spotted by coverity CID 710923.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-dapm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1797,7 +1797,7 @@ static ssize_t dapm_widget_power_read_fi
 				w->active ? "active" : "inactive");
 
 	list_for_each_entry(p, &w->sources, list_sink) {
-		if (p->connected && !p->connected(w, p->sink))
+		if (p->connected && !p->connected(w, p->source))
 			continue;
 
 		if (p->connect)



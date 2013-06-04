Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab3FDRAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:00:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48356 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757696Ab3FDRAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:00:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicolas Schichan <nschichan@freebox.fr>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 64/75] ASoC: cs42l52: fix default value for MASTERA_VOL.
Date: Tue,  4 Jun 2013 09:55:48 -0700
Message-Id: <1370364959-9475-65-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Schichan <nschichan@freebox.fr>

commit 04d245b7899c020559402841d2f70ddd740a7704 upstream.

The default register value for MASTERA_VOL is 0x00, the same as
MASTERB_VOL.

Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
Acked-by: Brian Austin <brian.austin@cirrus.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/cs42l52.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index 9811a54..bbd8c11 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -86,7 +86,7 @@ static const struct reg_default cs42l52_reg_defaults[] = {
 	{ CS42L52_BEEP_VOL, 0x00 },	/* r1D Beep Volume off Time */
 	{ CS42L52_BEEP_TONE_CTL, 0x00 },	/* r1E Beep Tone Cfg. */
 	{ CS42L52_TONE_CTL, 0x00 },	/* r1F Tone Ctl */
-	{ CS42L52_MASTERA_VOL, 0x88 },	/* r20 Master A Volume */
+	{ CS42L52_MASTERA_VOL, 0x00 },	/* r20 Master A Volume */
 	{ CS42L52_MASTERB_VOL, 0x00 },	/* r21 Master B Volume */
 	{ CS42L52_HPA_VOL, 0x00 },	/* r22 Headphone A Volume */
 	{ CS42L52_HPB_VOL, 0x00 },	/* r23 Headphone B Volume */
-- 
1.8.1.2


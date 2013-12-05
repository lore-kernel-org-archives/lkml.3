Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab3LERyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:54:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38218 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933247Ab3LERhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian Austin <brian.austin@cirrus.com>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 38/90] ASoC: cs42l52: Correct MIC CTL mask
Date: Thu,  5 Dec 2013 17:35:20 +0000
Message-Id: <1386264972-5399-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Austin <brian.austin@cirrus.com>

commit 3d800c6d75b8c92fa928a0bcaf95cd7ac5fd1ce5 upstream.

The mask for CS42L52_MIC_CTL_TYPE_MASK was wrong keeping the mic config
from being set correctly.

Signed-off-by: Brian Austin <brian.austin@cirrus.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/cs42l52.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l52.h b/sound/soc/codecs/cs42l52.h
index 60985c0..647a693 100644
--- a/sound/soc/codecs/cs42l52.h
+++ b/sound/soc/codecs/cs42l52.h
@@ -179,7 +179,7 @@
 #define CS42L52_MICB_CTL			0x11
 #define	CS42L52_MIC_CTL_MIC_SEL_MASK		0xBF
 #define	CS42L52_MIC_CTL_MIC_SEL_SHIFT		6
-#define CS42L52_MIC_CTL_TYPE_MASK		0xDF
+#define CS42L52_MIC_CTL_TYPE_MASK		0x20
 #define CS42L52_MIC_CTL_TYPE_SHIFT		5
 
 
-- 
1.8.3.2


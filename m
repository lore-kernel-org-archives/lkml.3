Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab3LFOBd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:01:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43908 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161458Ab3LFNBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:01:18 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brian Austin <brian.austin@cirrus.com>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 080/272] ASoC: cs42l52: Correct MIC CTL mask
Date: Fri,  6 Dec 2013 12:56:09 +0000
Message-Id: <1386334761-25517-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
index 4277012..a935d73 100644
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


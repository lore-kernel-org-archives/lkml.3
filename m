Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaBGLlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:41:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41018 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaBGLY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:24:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 44/88] ASoC: adau1701: Fix ADAU1701_SEROCTL_WORD_LEN_16 constant
Date: Fri,  7 Feb 2014 11:22:41 +0000
Message-Id: <1391772205-22239-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit e20970ada3f699c113fe64b04492af083d11a7d8 upstream.

The driver defines ADAU1701_SEROCTL_WORD_LEN_16 as 0x10 while it should be b10,
so 0x2. This patch fixes it.

Reported-by: Magnus Reftel <magnus.reftel@lockless.no>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/soc/codecs/adau1701.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/adau1701.c b/sound/soc/codecs/adau1701.c
index 3d50fc8..347f455 100644
--- a/sound/soc/codecs/adau1701.c
+++ b/sound/soc/codecs/adau1701.c
@@ -64,7 +64,7 @@
 
 #define ADAU1701_SEROCTL_WORD_LEN_24	0x0000
 #define ADAU1701_SEROCTL_WORD_LEN_20	0x0001
-#define ADAU1701_SEROCTL_WORD_LEN_16	0x0010
+#define ADAU1701_SEROCTL_WORD_LEN_16	0x0002
 #define ADAU1701_SEROCTL_WORD_LEN_MASK	0x0003
 
 #define ADAU1701_AUXNPOW_VBPD		0x40
-- 
1.8.3.2


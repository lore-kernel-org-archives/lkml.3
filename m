Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbaBJTmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:42:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34636 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbaBJTml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:42:41 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 042/124] ASoC: adau1701: Fix ADAU1701_SEROCTL_WORD_LEN_16 constant
Date: Mon, 10 Feb 2014 11:39:42 -0800
Message-Id: <1392061264-28124-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit e20970ada3f699c113fe64b04492af083d11a7d8 upstream.

The driver defines ADAU1701_SEROCTL_WORD_LEN_16 as 0x10 while it should be b10,
so 0x2. This patch fixes it.

Reported-by: Magnus Reftel <magnus.reftel@lockless.no>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/soc/codecs/adau1701.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/adau1701.c b/sound/soc/codecs/adau1701.c
index dafdbe8..0c499c6 100644
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


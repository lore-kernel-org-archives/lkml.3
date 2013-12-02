Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab3LBTRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:17:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535Ab3LBTRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brian Austin <brian.austin@cirrus.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.12 020/212] ASoC: cs42l52: Correct MIC CTL mask
Date: Mon,  2 Dec 2013 11:13:31 -0800
Message-Id: <20131202191250.939308511@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Austin <brian.austin@cirrus.com>

commit 3d800c6d75b8c92fa928a0bcaf95cd7ac5fd1ce5 upstream.

The mask for CS42L52_MIC_CTL_TYPE_MASK was wrong keeping the mic config
from being set correctly.

Signed-off-by: Brian Austin <brian.austin@cirrus.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/cs42l52.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/cs42l52.h
+++ b/sound/soc/codecs/cs42l52.h
@@ -179,7 +179,7 @@
 #define CS42L52_MICB_CTL			0x11
 #define	CS42L52_MIC_CTL_MIC_SEL_MASK		0xBF
 #define	CS42L52_MIC_CTL_MIC_SEL_SHIFT		6
-#define CS42L52_MIC_CTL_TYPE_MASK		0xDF
+#define CS42L52_MIC_CTL_TYPE_MASK		0x20
 #define CS42L52_MIC_CTL_TYPE_SHIFT		5
 
 



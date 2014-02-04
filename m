Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406AbaBDVCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:02:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933327AbaBDVC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:02:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Magnus Reftel <magnus.reftel@lockless.no>,
        Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.10 059/104] ASoC: adau1701: Fix ADAU1701_SEROCTL_WORD_LEN_16 constant
Date: Tue,  4 Feb 2014 13:02:02 -0800
Message-Id: <20140204210224.394236218@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
References: <20140204210222.731641778@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit e20970ada3f699c113fe64b04492af083d11a7d8 upstream.

The driver defines ADAU1701_SEROCTL_WORD_LEN_16 as 0x10 while it should be b10,
so 0x2. This patch fixes it.

Reported-by: Magnus Reftel <magnus.reftel@lockless.no>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/codecs/adau1701.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/adau1701.c
+++ b/sound/soc/codecs/adau1701.c
@@ -64,7 +64,7 @@
 
 #define ADAU1701_SEROCTL_WORD_LEN_24	0x0000
 #define ADAU1701_SEROCTL_WORD_LEN_20	0x0001
-#define ADAU1701_SEROCTL_WORD_LEN_16	0x0010
+#define ADAU1701_SEROCTL_WORD_LEN_16	0x0002
 #define ADAU1701_SEROCTL_WORD_LEN_MASK	0x0003
 
 #define ADAU1701_AUXNPOW_VBPD		0x40



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaI1B5l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 21:57:41 -0400
Received: from nasmtp01.atmel.com ([192.199.1.246]:25697 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752015AbaI1B5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 21:57:40 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>, <nicolas.ferre@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 1/2] MAINTAINERS: add atmel ssc driver maintainer entry
Date: Sun, 28 Sep 2014 09:57:18 +0800
Message-ID: <1411869439-2719-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 2.1.0.24.g4109c28
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3705430..c004e6f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1703,6 +1703,13 @@ M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 S:	Supported
 F:	drivers/spi/spi-atmel.*
 
+ATMEL SSC DRIVER
+M:	Bo Shen <voice.shen@atmel.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Supported
+F:	drivers/misc/atmel-ssc.c
+F:	include/linux/atmel-ssc.h
+
 ATMEL Timer Counter (TC) AND CLOCKSOURCE DRIVERS
 M:	Nicolas Ferre <nicolas.ferre@atmel.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-- 
2.1.0.24.g4109c28


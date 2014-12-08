Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbaLHUkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:40:10 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:4165 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990AbaLHUj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:39:57 -0500
X-IronPort-AV: E=Sophos;i="5.07,540,1413270000"; 
   d="scan'208";a="52393751"
From: Ray Jui <rjui@broadcom.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        "Arnd Bergmann" <arnd@arndb.de>
CC: Scott Branden <sbranden@broadcom.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-gpio@vger.kernel.org>,
        <bcm-kernel-feedback-list@broadcom.com>, <devicetree@vger.kernel.org>,
        "Ray Jui" <rjui@broadcom.com>
Subject: [PATCH v4 5/5] MAINTAINERS: Entry for Cygnus GPIO driver
Date: Mon, 8 Dec 2014 12:41:59 -0800
Message-ID: <1418071319-11779-6-git-send-email-rjui@broadcom.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418071319-11779-1-git-send-email-rjui@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
 <1418071319-11779-1-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ray Jui <rjui@broadcom.com>
---
 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e6bff3a..8473422 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2202,6 +2202,13 @@ N:	bcm9583*
 N:	bcm583*
 N:	bcm113*
 
+BROADCOM CYGNUS GPIO DRIVER
+M:	Ray Jui <rjui@broadcom.com>
+L:	bcm-kernel-feedback-list@broadcom.com
+S:	Supported
+F:	drivers/gpio/gpio-bcm-cygnus.c
+F:	Documentation/devicetree/bindings/gpio/brcm,cygnus-gpio.txt
+
 BROADCOM KONA GPIO DRIVER
 M:	Ray Jui <rjui@broadcom.com>
 L:	bcm-kernel-feedback-list@broadcom.com
-- 
1.7.9.5


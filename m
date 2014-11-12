Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008AbaKLEdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 23:33:16 -0500
Received: from mail.eperm.de ([89.247.134.16]:54452 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009AbaKLEcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 23:32:55 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Marek Vasut <marex@denx.de>, "David S. Miller" <davem@davemloft.net>,
        Jason Cooper <cryptography@lakedaemon.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "Joy M. Latten" <jmlatten@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 02/13] crypto: Documentation - compile crypto API spec
Date: Wed, 12 Nov 2014 05:24:12 +0100
Message-ID: <1603144.FhPLRRlDmc@tachyon.chronox.de>
User-Agent: KMail/4.14.2 (Linux/3.17.2-300.fc21.x86_64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1800066.efQ8hkST4U@tachyon.chronox.de>
References: <1800066.efQ8hkST4U@tachyon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the crypto API documentation into the DocBook Makefile to allow it
being compiled

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/DocBook/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index bec0665..9c7d92d 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -15,7 +15,7 @@ DOCBOOKS := z8530book.xml device-drivers.xml \
 	    80211.xml debugobjects.xml sh.xml regulator.xml \
 	    alsa-driver-api.xml writing-an-alsa-driver.xml \
 	    tracepoint.xml drm.xml media_api.xml w1.xml \
-	    writing_musb_glue_layer.xml
+	    writing_musb_glue_layer.xml crypto-API.xml
 
 include Documentation/DocBook/media/Makefile
 
-- 
2.1.0



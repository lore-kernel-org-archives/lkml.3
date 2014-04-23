Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbaDWKYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:24:53 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:62583 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442AbaDWKYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:24:51 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        linux-doc@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] doc: make clean does not remove some xml files
Date: Wed, 23 Apr 2014 19:24:33 +0900
Message-Id: <1398248673-28450-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.0.0.rc0.26.g779792a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"make clean" does not remove following files in
Documentations/Docbook.

audio.h.xml, ca.h.xml, dmx.h.xml, frontend.h.xml
net.h.xml, videodev2.h.xml vide.h.xml.

These files are generated when "make xmldocs".

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/DocBook/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index b444f2e..ec91911 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -14,7 +14,9 @@ DOCBOOKS := z8530book.xml device-drivers.xml \
 	    genericirq.xml s390-drivers.xml uio-howto.xml scsi.xml \
 	    80211.xml debugobjects.xml sh.xml regulator.xml \
 	    alsa-driver-api.xml writing-an-alsa-driver.xml \
-	    tracepoint.xml drm.xml media_api.xml w1.xml
+	    tracepoint.xml drm.xml media_api.xml w1.xml \
+	    audio.h.xml ca.h.xml dmx.h.xml frontend.h.xml \
+	    net.h.xml videodev2.h.xml video.h.xml
 
 include Documentation/DocBook/media/Makefile
 
-- 
2.0.0.rc0.26.g779792a


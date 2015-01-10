Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbbAJFhE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:37:04 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:44997 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbbAJFg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:58 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org,
        Fabian Mewes <architekt@coding4coffee.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Jerry Snitselaar <dev@snitselaar.org>,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>,
        linux-kernel@vger.kernel.org, Mikhail Boiko <mm.boiko@yandex.ru>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Stefan Hajnoczi <stefanha@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 19/25] staging: line6: Remove stale Pocket POD PCM endpoints
Date: Fri,  9 Jan 2015 23:36:05 -0600
Message-Id: <1420868171-2031-20-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1027f476f507 (staging: line6: sync with upstream) removed PCM
from the Pocket POD capabilities but left the endpoint configuration.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/pcm.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index d8450af..19aa927 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -448,11 +448,6 @@ int line6_init_pcm(struct usb_line6 *line6,
 		ep_write = 0x02;
 		break;
 
-	case LINE6_POCKETPOD:
-		ep_read = 0x82;
-		ep_write = 0x02;
-		break;
-
 	case LINE6_GUITARPORT:
 	case LINE6_PODSTUDIO_GX:
 	case LINE6_PODSTUDIO_UX1:
-- 
2.1.0


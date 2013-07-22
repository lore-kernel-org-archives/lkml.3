Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3GVARW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:17:22 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47884 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753502Ab3GVARU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:17:20 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/18] MAINTAINERS: Update SIANO drivers
Date: Sun, 21 Jul 2013 17:15:37 -0700
Message-Id: <507be0a45c0a1f6a34f5b06299fe4ed8a609de06.1374451989.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 786baecfe78 ("[media] dvb-usb: move it to drivers/media/usb/dvb-usb")
moved the files, update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b206920..81d68ae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7403,7 +7403,7 @@ W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Odd fixes
 F:	drivers/media/common/siano/
-F:	drivers/media/dvb/siano/
+F:	drivers/media/usb/siano/
 F:	drivers/media/usb/siano/
 F:	drivers/media/mmc/siano
 
-- 
1.8.1.2.459.gbcd45b4.dirty


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3GVARl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 20:17:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49508 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754113Ab3GVARj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 20:17:39 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Antti Palosaari <crope@iki.fi>, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/18] MAINTAINERS: Update it913x patterns
Date: Sun, 21 Jul 2013 17:15:39 -0700
Message-Id: <170209027bb96e454ee499671598aaca0f414df5.1374451989.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d7104bffcfb ("[media] MAINTAINERS: add drivers/media/tuners/it913x*")
used the incorrect file patterns.  Fix it.

Signed-off-by: Joe Perches <joe@perches.com>
cc: Antti Palosaari <crope@iki.fi>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index aa5ccd0..7622b04 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4566,7 +4566,7 @@ W:	http://palosaari.fi/linux/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
 T:	git git://linuxtv.org/anttip/media_tree.git
 S:	Maintained
-F:	drivers/media/tuners/it913x*
+F:	drivers/media/tuners/tuner_it913x*
 
 IVTV VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
-- 
1.8.1.2.459.gbcd45b4.dirty


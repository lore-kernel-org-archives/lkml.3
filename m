Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3GBQXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 12:23:51 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:60863 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776Ab3GBQXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 12:23:46 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Cc: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH] MAINTAINERS: xfs@oss.sgi.com is a list
Date: Tue,  2 Jul 2013 17:00:47 +0200
Message-Id: <1372777248-4114-1-git-send-email-ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes type of xfs@oss.sgi.com

The output of ./scripts/get_maintainer.pl is
modified to report xfs@oss.sgi.com as a list:

 Ben Myers <bpm@sgi.com> (supporter:XFS FILESYSTEM)
 Alex Elder <elder@kernel.org> (supporter:XFS FILESYSTEM)
-xfs@oss.sgi.com (supporter:XFS FILESYSTEM)
+xfs@oss.sgi.com (open list:XFS FILESYSTEM)
 linux-kernel@vger.kernel.org (open list)

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ad7e322..7b6ab51 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9139,7 +9139,6 @@ XFS FILESYSTEM
 P:	Silicon Graphics Inc
 M:	Ben Myers <bpm@sgi.com>
 M:	Alex Elder <elder@kernel.org>
-M:	xfs@oss.sgi.com
 L:	xfs@oss.sgi.com
 W:	http://oss.sgi.com/projects/xfs
 T:	git git://oss.sgi.com/xfs/xfs.git
-- 
1.8.3.1


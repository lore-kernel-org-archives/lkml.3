Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab3GBQXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 12:23:53 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:32825 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998Ab3GBQXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 12:23:48 -0400
From: Yann Droneaud <ydroneaud@opteya.com>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH] MAINTAINERS: dm-devel@redhat.com is a list
Date: Tue,  2 Jul 2013 17:01:47 +0200
Message-Id: <1372777307-4259-1-git-send-email-ydroneaud@opteya.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes type of dm-devel@redhat.com

The output of ./scripts/get_maintainer.pl is
modified to report dm-devel@redhat.com as a list:

 Alasdair Kergon <agk@redhat.com> (maintainer:DEVICE-MAPPER  (LVM))
-dm-devel@redhat.com (maintainer:DEVICE-MAPPER  (LVM))
 Neil Brown <neilb@suse.de> (supporter:SOFTWARE RAID (Mu...)
+dm-devel@redhat.com (open list:DEVICE-MAPPER  (LVM))
 linux-raid@vger.kernel.org (open list:SOFTWARE RAID (Mu...)
 linux-kernel@vger.kernel.org (open list)

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7b6ab51..fefd17f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2527,7 +2527,6 @@ S:	Maintained
 
 DEVICE-MAPPER  (LVM)
 M:	Alasdair Kergon <agk@redhat.com>
-M:	dm-devel@redhat.com
 L:	dm-devel@redhat.com
 W:	http://sources.redhat.com/dm
 Q:	http://patchwork.kernel.org/project/dm-devel/list/
-- 
1.8.3.1


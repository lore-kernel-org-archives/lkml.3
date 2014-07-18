Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762733AbaGRPbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:31:08 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:39877 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762058AbaGRPbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:31:04 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: dcb314@hotmail.com, rafael.j.wysocki@intel.com, trenn@suse.de,
        linux@dominikbrodowski.net,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 1/5] tools/power/cpupower/utils/helpers/sysfs.c: drop negativity check on unsigned value
Date: Fri, 18 Jul 2014 18:30:45 +0300
Message-Id: <1405697445-23620-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80621
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 tools/power/cpupower/utils/helpers/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/cpupower/utils/helpers/sysfs.c b/tools/power/cpupower/utils/helpers/sysfs.c
index 851c7a1..09afe5d 100644
--- a/tools/power/cpupower/utils/helpers/sysfs.c
+++ b/tools/power/cpupower/utils/helpers/sysfs.c
@@ -81,7 +81,7 @@ int sysfs_is_cpu_online(unsigned int cpu)
 	close(fd);
 
 	value = strtoull(linebuf, &endp, 0);
-	if (value > 1 || value < 0)
+	if (value > 1)
 		return -EINVAL;
 
 	return value;
-- 
1.8.5.5


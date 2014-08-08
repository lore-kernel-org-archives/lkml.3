Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbaHHWbJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:31:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40170 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbaHHUlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 132/259] hwmon: (da9052) Don't use dash in the name attribute
Date: Fri,  8 Aug 2014 13:39:15 -0700
Message-Id: <1407530482-4483-133-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit ee14b644daaa58afe1e91bb9ebd9cf1b18d1f5fa upstream.

Dashes are not allowed in hwmon name attributes.
Use "da9052" instead of "da9052-hwmon".

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hwmon/da9052-hwmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/da9052-hwmon.c b/drivers/hwmon/da9052-hwmon.c
index 960fac3..48044b0 100644
--- a/drivers/hwmon/da9052-hwmon.c
+++ b/drivers/hwmon/da9052-hwmon.c
@@ -194,7 +194,7 @@ static ssize_t da9052_hwmon_show_name(struct device *dev,
 				      struct device_attribute *devattr,
 				      char *buf)
 {
-	return sprintf(buf, "da9052-hwmon\n");
+	return sprintf(buf, "da9052\n");
 }
 
 static ssize_t show_label(struct device *dev,
-- 
1.9.1


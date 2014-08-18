Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaHRKH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:07:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42455 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbaHRJdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:33:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 013/137] hwmon: (da9052) Don't use dash in the name attribute
Date: Mon, 18 Aug 2014 10:31:14 +0100
Message-Id: <1408354398-10226-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit ee14b644daaa58afe1e91bb9ebd9cf1b18d1f5fa upstream.

Dashes are not allowed in hwmon name attributes.
Use "da9052" instead of "da9052-hwmon".

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/da9052-hwmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/da9052-hwmon.c b/drivers/hwmon/da9052-hwmon.c
index 960fac3fb166..48044b044b7a 100644
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


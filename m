Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbaG3MlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:41:13 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36651 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752772AbaG3MP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Guenter Roeck <linux@roeck-us.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 23/94] hwmon: (da9055) Don't use dash in the name attribute
Date: Wed, 30 Jul 2014 14:14:12 +0200
Message-Id: <6687e93389416e0e02af6f1435e9aa02b27b29f2.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6b00f440dd678d786389a7100a2e03fe44478431 upstream.

Dashes are not allowed in hwmon name attributes.
Use "da9055" instead of "da9055-hwmon".

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hwmon/da9055-hwmon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/da9055-hwmon.c b/drivers/hwmon/da9055-hwmon.c
index 029ecabc4380..1b275a2881d6 100644
--- a/drivers/hwmon/da9055-hwmon.c
+++ b/drivers/hwmon/da9055-hwmon.c
@@ -204,7 +204,7 @@ static ssize_t da9055_hwmon_show_name(struct device *dev,
 				      struct device_attribute *devattr,
 				      char *buf)
 {
-	return sprintf(buf, "da9055-hwmon\n");
+	return sprintf(buf, "da9055\n");
 }
 
 static ssize_t show_label(struct device *dev,
-- 
2.0.1


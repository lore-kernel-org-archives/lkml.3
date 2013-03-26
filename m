Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965014Ab3CZQTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:19:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53540 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934641Ab3CZPVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:21:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 017/150] hwmon: (lineage-pem) Add missing terminating entry for pem_[input|fan]_attributes
Date: Tue, 26 Mar 2013 15:18:36 +0000
Message-Id: <1364311249-14454-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit df069079c153d22adf6c28dcc0b1cf62bba75167 upstream.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/lineage-pem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/lineage-pem.c b/drivers/hwmon/lineage-pem.c
index bd75d24..3a6caa3 100644
--- a/drivers/hwmon/lineage-pem.c
+++ b/drivers/hwmon/lineage-pem.c
@@ -421,6 +421,7 @@ static struct attribute *pem_input_attributes[] = {
 	&sensor_dev_attr_in2_input.dev_attr.attr,
 	&sensor_dev_attr_curr1_input.dev_attr.attr,
 	&sensor_dev_attr_power1_input.dev_attr.attr,
+	NULL
 };
 
 static const struct attribute_group pem_input_group = {
@@ -431,6 +432,7 @@ static struct attribute *pem_fan_attributes[] = {
 	&sensor_dev_attr_fan1_input.dev_attr.attr,
 	&sensor_dev_attr_fan2_input.dev_attr.attr,
 	&sensor_dev_attr_fan3_input.dev_attr.attr,
+	NULL
 };
 
 static const struct attribute_group pem_fan_group = {
-- 
1.8.1.2


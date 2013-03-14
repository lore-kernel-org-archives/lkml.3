Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab3CNI1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:27:32 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33113 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab3CNI1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:27:30 -0400
Message-ID: <1363249638.15861.1.camel@phoenix>
Subject: [PATCH] hwmon: lineage-pem: Add missing terminating entry for
 pem_[input|fan]_attributes
From: Axel Lin <axel.lin@ingics.com>
To: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Mar 2013 16:27:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/hwmon/lineage-pem.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/lineage-pem.c b/drivers/hwmon/lineage-pem.c
index 41df29f..ebbb9f4 100644
--- a/drivers/hwmon/lineage-pem.c
+++ b/drivers/hwmon/lineage-pem.c
@@ -422,6 +422,7 @@ static struct attribute *pem_input_attributes[] = {
 	&sensor_dev_attr_in2_input.dev_attr.attr,
 	&sensor_dev_attr_curr1_input.dev_attr.attr,
 	&sensor_dev_attr_power1_input.dev_attr.attr,
+	NULL
 };
 
 static const struct attribute_group pem_input_group = {
@@ -432,6 +433,7 @@ static struct attribute *pem_fan_attributes[] = {
 	&sensor_dev_attr_fan1_input.dev_attr.attr,
 	&sensor_dev_attr_fan2_input.dev_attr.attr,
 	&sensor_dev_attr_fan3_input.dev_attr.attr,
+	NULL
 };
 
 static const struct attribute_group pem_fan_group = {
-- 
1.7.9.5




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab3CRErO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:47:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33458 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669Ab3CREaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:20 -0400
Message-Id: <20130318042150.664870332@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:50 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Axel Lin <axel.lin@ingics.com>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>
Subject: [ 66/82] hwmon: (lineage-pem) Add missing terminating entry for
 pem_[input|fan]_attributes
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit df069079c153d22adf6c28dcc0b1cf62bba75167 upstream.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/lineage-pem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/hwmon/lineage-pem.c
+++ b/drivers/hwmon/lineage-pem.c
@@ -421,6 +421,7 @@ static struct attribute *pem_input_attri
 	&sensor_dev_attr_in2_input.dev_attr.attr,
 	&sensor_dev_attr_curr1_input.dev_attr.attr,
 	&sensor_dev_attr_power1_input.dev_attr.attr,
+	NULL
 };
 
 static const struct attribute_group pem_input_group = {
@@ -431,6 +432,7 @@ static struct attribute *pem_fan_attribu
 	&sensor_dev_attr_fan1_input.dev_attr.attr,
 	&sensor_dev_attr_fan2_input.dev_attr.attr,
 	&sensor_dev_attr_fan3_input.dev_attr.attr,
+	NULL
 };
 
 static const struct attribute_group pem_fan_group = {



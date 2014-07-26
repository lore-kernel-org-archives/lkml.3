Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbaGZTjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:39:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbaGZTNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.15 021/109] hwmon: (da9055) Dont use dash in the name attribute
Date: Sat, 26 Jul 2014 12:01:43 -0700
Message-Id: <20140726190224.475507776@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 6b00f440dd678d786389a7100a2e03fe44478431 upstream.

Dashes are not allowed in hwmon name attributes.
Use "da9055" instead of "da9055-hwmon".

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/da9055-hwmon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/da9055-hwmon.c
+++ b/drivers/hwmon/da9055-hwmon.c
@@ -204,7 +204,7 @@ static ssize_t da9055_hwmon_show_name(st
 				      struct device_attribute *devattr,
 				      char *buf)
 {
-	return sprintf(buf, "da9055-hwmon\n");
+	return sprintf(buf, "da9055\n");
 }
 
 static ssize_t show_label(struct device *dev,



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbaGZTi7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:38:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbaGZTNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.15 022/109] hwmon: (da9052) Dont use dash in the name attribute
Date: Sat, 26 Jul 2014 12:01:44 -0700
Message-Id: <20140726190224.504055917@linuxfoundation.org>
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

commit ee14b644daaa58afe1e91bb9ebd9cf1b18d1f5fa upstream.

Dashes are not allowed in hwmon name attributes.
Use "da9052" instead of "da9052-hwmon".

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/da9052-hwmon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/da9052-hwmon.c
+++ b/drivers/hwmon/da9052-hwmon.c
@@ -194,7 +194,7 @@ static ssize_t da9052_hwmon_show_name(st
 				      struct device_attribute *devattr,
 				      char *buf)
 {
-	return sprintf(buf, "da9052-hwmon\n");
+	return sprintf(buf, "da9052\n");
 }
 
 static ssize_t show_label(struct device *dev,



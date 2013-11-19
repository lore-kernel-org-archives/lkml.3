Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab3KSKiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 05:38:14 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:53822 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab3KSKiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 05:38:13 -0500
From: Andre Richter <andre.o.richter@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andre Richter <andre.o.richter@gmail.com>
Subject: [PATCH 1/1] Documentation/filesystems/sysfs.txt: fix device_attribute declaration
Date: Tue, 19 Nov 2013 11:38:04 +0100
Message-Id: <1384857484-5596-1-git-send-email-andre.o.richter@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a wrong device_attribute declaration example.

Signed-off-by: Andre Richter <andre.o.richter@gmail.com>
---
 Documentation/filesystems/sysfs.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/sysfs.txt b/Documentation/filesystems/sysfs.txt
index a6619b7..317d673 100644
--- a/Documentation/filesystems/sysfs.txt
+++ b/Documentation/filesystems/sysfs.txt
@@ -108,12 +108,12 @@ static DEVICE_ATTR(foo, S_IWUSR | S_IRUGO, show_foo, store_foo);
 is equivalent to doing:
 
 static struct device_attribute dev_attr_foo = {
-       .attr	= {
+	.attr = {
 		.name = "foo",
-		.mode = S_IWUSR | S_IRUGO,
-		.show = show_foo,
-		.store = store_foo,
+		.mode = S_IWUSR | S_IRUGO,
 	},
+	.show = show_foo,
+	.store = store_foo,
 };
 
 
-- 
1.8.3.2


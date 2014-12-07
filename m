Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaLGJhk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 04:37:40 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44931 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbaLGJhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 04:37:37 -0500
From: Athira Lekshmi <andnlnbn18@gmail.com>
To: bhelgaas@google.com
Cc: levex@linux.com, linux-kernel@vger.kernel.org,
        Athira Lekshmi <andnlnbn18@gmail.com>
Subject: [PATCH] Eisa: Fixed missing a blank line warning
Date: Sun,  7 Dec 2014 15:07:36 +0530
Message-Id: <1417945056-4561-1-git-send-email-andnlnbn18@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a new line after declarations to remove the warning:
'Missing a blank line after declarations'

Signed-off-by: Athira Lekshmi <andnlnbn18@gmail.com>
---
 drivers/eisa/eisa-bus.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/eisa/eisa-bus.c b/drivers/eisa/eisa-bus.c
index 612afea..9712962 100644
--- a/drivers/eisa/eisa-bus.c
+++ b/drivers/eisa/eisa-bus.c
@@ -59,6 +59,7 @@ static void __init eisa_name_device(struct eisa_device *edev)
 {
 #ifdef CONFIG_EISA_NAMES
 	int i;
+
 	for (i = 0; i < EISA_INFOS; i++) {
 		if (!strcmp(edev->id.sig, eisa_table[i].id.sig)) {
 			strlcpy(edev->pretty_name,
@@ -160,6 +161,7 @@ static ssize_t eisa_show_sig(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
 	struct eisa_device *edev = to_eisa_device(dev);
+
 	return sprintf(buf, "%s\n", edev->id.sig);
 }
 
@@ -170,6 +172,7 @@ static ssize_t eisa_show_state(struct device *dev,
 			       char *buf)
 {
 	struct eisa_device *edev = to_eisa_device(dev);
+
 	return sprintf(buf, "%d\n", edev->state & EISA_CONFIG_ENABLED);
 }
 
-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbbAKX6h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 18:58:37 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:47192 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbbAKX6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 18:58:19 -0500
From: Julian Brost <linux-kernel@0x4a42.net>
To: linux-doc@vger.kernel.org
Cc: Julian Brost <linux-kernel@0x4a42.net>, linux-kernel@vger.kernel.org,
        corbet@lwn.net, tomas.winkler@intel.com, linux-mei@linux.intel.com,
        linux-kernel@i4.cs.fau.de, fabian.hofmann@fau.de
Subject: [PATCH 4/4] Documentation/misc-devices/mei: Fix indentation of embedded code.
Date: Mon, 12 Jan 2015 00:58:09 +0100
Message-Id: <1421020689-28332-5-git-send-email-linux-kernel@0x4a42.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421020689-28332-1-git-send-email-linux-kernel@0x4a42.net>
References: <1421020689-28332-1-git-send-email-linux-kernel@0x4a42.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the source code embedded in mei-client-bus.txt was indented
using spaces. This properly indents it with tabs and also removes a
single space that was placed in front of a closing curly brace.

Signed-off-by: Julian Brost <linux-kernel@0x4a42.net>
Signed-off-by: Fabian Hofmann <fabian.hofmann@fau.de>
---
 Documentation/misc-devices/mei/mei-client-bus.txt | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/misc-devices/mei/mei-client-bus.txt b/Documentation/misc-devices/mei/mei-client-bus.txt
index 6ca486b..743be4e 100644
--- a/Documentation/misc-devices/mei/mei-client-bus.txt
+++ b/Documentation/misc-devices/mei/mei-client-bus.txt
@@ -72,11 +72,11 @@ static struct mei_cl_device_id contact_mei_cl_tbl[] = {
 MODULE_DEVICE_TABLE(mei_cl, contact_mei_cl_tbl);
 
 static struct mei_cl_driver contact_driver = {
-       .id_table = contact_mei_tbl,
-       .name = CONTACT_DRIVER_NAME,
+	.id_table = contact_mei_tbl,
+	.name = CONTACT_DRIVER_NAME,
 
-       .probe = contact_probe,
-       .remove = contact_remove,
+	.probe = contact_probe,
+	.remove = contact_remove,
 };
 
 static int contact_init(void)
@@ -112,7 +112,7 @@ int contact_probe(struct mei_cl_device *dev, struct mei_cl_device_id *id)
 	mei_cl_register_event_cb(dev, contact_event_cb, contact);
 
 	return 0;
- }
+}
 
 In the probe routine the driver first enable the MEI device and then registers
 an ME bus event handler which is as close as it can get to registering a
-- 
2.2.1


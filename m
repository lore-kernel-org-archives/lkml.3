Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab3DOJTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 05:19:04 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:51507 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab3DOJTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 05:19:03 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Federico Vaga <federico.vaga@gmail.com>
Subject: [PATCH v2] base/core.c: improve comment of the function device_find_child()
Date: Mon, 15 Apr 2013 11:18:11 +0200
Message-Id: <1366017491-6523-1-git-send-email-federico.vaga@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
---
 drivers/base/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 016312437..3c8512f 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1372,6 +1372,8 @@ int device_for_each_child(struct device *parent, void *data,
  * if it does.  If the callback returns non-zero and a reference to the
  * current device can be obtained, this function will return to the caller
  * and not iterate over any more devices.
+ *
+ * NOTE: you will need to drop the reference with put_device() after use.
  */
 struct device *device_find_child(struct device *parent, void *data,
 				 int (*match)(struct device *dev, void *data))
-- 
1.8.1.4


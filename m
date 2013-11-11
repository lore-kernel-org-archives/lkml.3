Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab3KKJnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 04:43:04 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:33164 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab3KKJm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 04:42:58 -0500
X-Auth-Info: N8UXBXJghmKoursfbhulxOjSYSRD3El70hj2uYF0jDk=
From: Gerhard Sittig <gsi@denx.de>
To: Jiri Kosina <trivial@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Gerhard Sittig <gsi@denx.de>
Subject: [PATCH 1/1] regmap: trivial comment fix (copy'n'paste error)
Date: Mon, 11 Nov 2013 10:42:36 +0100
Message-Id: <1384162956-28274-1-git-send-email-gsi@denx.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix a trivial copy'n'paste error in the regmap kerneldoc, s/write/read/
for the regmap_read(), regmap_raw_read() and regmap_bulk_read() routines

Signed-off-by: Gerhard Sittig <gsi@denx.de>
---
 drivers/base/regmap/regmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 7d689a15c500..d92648f771c4 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1573,7 +1573,7 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 /**
  * regmap_read(): Read a value from a single register
  *
- * @map: Register map to write to
+ * @map: Register map to read from
  * @reg: Register to be read from
  * @val: Pointer to store read value
  *
@@ -1600,7 +1600,7 @@ EXPORT_SYMBOL_GPL(regmap_read);
 /**
  * regmap_raw_read(): Read raw data from the device
  *
- * @map: Register map to write to
+ * @map: Register map to read from
  * @reg: First register to be read from
  * @val: Pointer to store read value
  * @val_len: Size of data to read
@@ -1679,7 +1679,7 @@ EXPORT_SYMBOL_GPL(regmap_field_read);
 /**
  * regmap_bulk_read(): Read multiple registers from the device
  *
- * @map: Register map to write to
+ * @map: Register map to read from
  * @reg: First register to be read from
  * @val: Pointer to store read value, in native register size for device
  * @val_count: Number of registers to read
-- 
1.7.10.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbaJGPT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:19:56 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:39477 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbaJGPTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:19:53 -0400
From: Darshana Padmadas <darshanapadmadas@gmail.com>
To: opw-kernel@googlegroups.com
Cc: grant.likely@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        linux-arm-kernel@lists.infradead.org, jic23@kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Darshana Padmadas <darshanapadmadas@gmail.com>
Subject: [PATCH v4 3/4] Staging: iio: light: Added correct vendor-prefix for device isl29028
Date: Tue,  7 Oct 2014 20:49:28 +0530
Message-Id: <1412695169-22815-4-git-send-email-darshanapadmadas@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412695169-22815-1-git-send-email-darshanapadmadas@gmail.com>
References: <1412695169-22815-1-git-send-email-darshanapadmadas@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the correct vendor-prefix for device isl29028 and
maintains deprecated vendor-prefix found by checkpatch warning
for older kernel releases.

Signed-off-by: Darshana Padmadas <darshanapadmadas@gmail.com>
---
 drivers/staging/iio/light/isl29028.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/iio/light/isl29028.c b/drivers/staging/iio/light/isl29028.c
index 6014625..e969107 100644
--- a/drivers/staging/iio/light/isl29028.c
+++ b/drivers/staging/iio/light/isl29028.c
@@ -537,7 +537,8 @@ static const struct i2c_device_id isl29028_id[] = {
 MODULE_DEVICE_TABLE(i2c, isl29028_id);
 
 static const struct of_device_id isl29028_of_match[] = {
-	{ .compatible = "isil,isl29028", },
+	{ .compatible = "isl,isl29028", },
+	{ .compatible = "isil,isl29028", },/* deprecated, don't use */
 	{ },
 };
 MODULE_DEVICE_TABLE(of, isl29028_of_match);
-- 
1.9.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaLOO4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:56:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38585 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaLOO2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 078/168] iio: adc: men_z188_adc: Add terminating entry for men_z188_ids
Date: Mon, 15 Dec 2014 14:25:32 +0000
Message-Id: <1418653622-21105-79-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit fbbba1f89eb68e7d07707e104193d56de8e37fe5 upstream.

The mcb_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iio/adc/men_z188_adc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/men_z188_adc.c b/drivers/iio/adc/men_z188_adc.c
index b58d6302521f..d095efe1ba14 100644
--- a/drivers/iio/adc/men_z188_adc.c
+++ b/drivers/iio/adc/men_z188_adc.c
@@ -152,6 +152,7 @@ static void men_z188_remove(struct mcb_device *dev)
 
 static const struct mcb_device_id men_z188_ids[] = {
 	{ .device = 0xbc },
+	{ }
 };
 MODULE_DEVICE_TABLE(mcb, men_z188_ids);
 
-- 
2.1.3


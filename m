Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbaLWNWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:22:19 -0500
Received: from mga14.intel.com ([192.55.52.115]:12998 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327AbaLWNVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:21:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,632,1413270000"; 
   d="scan'208";a="652169946"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, knaack.h@gmx.de
Cc: lars@metafoo.de, pmeerw@pmeerw.net, daniel.baluta@intel.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        srinivas.pandruvada@linux.intel.com
Subject: [PATCH 08/10] iio: imu: kmx61: Remove unnecessary REG_INS1 read
Date: Tue, 23 Dec 2014 15:22:31 +0200
Message-Id: <1419340953-23161-9-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com>
References: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Useful in the debugging phase, not needed now.

Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 drivers/iio/imu/kmx61.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
index 5b5be2b..eb3900e 100644
--- a/drivers/iio/imu/kmx61.c
+++ b/drivers/iio/imu/kmx61.c
@@ -1196,8 +1196,6 @@ ack_intr:
 	if (ret < 0)
 		dev_err(&data->client->dev, "Error reading reg_inl\n");
 
-	ret = i2c_smbus_read_byte_data(data->client, KMX61_REG_INS1);
-
 	return IRQ_HANDLED;
 }
 
-- 
1.9.1


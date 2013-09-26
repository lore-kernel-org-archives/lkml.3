Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255Ab3IZNLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:11:22 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3750 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237Ab3IZNLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:11:20 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 26 Sep 2013 06:07:39 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/4] mfd: palmas: add MODULE_DEVICE_TABLE for of_device table
Date: Thu, 26 Sep 2013 19:03:49 +0530
Message-ID: <1380202431-4868-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1380202431-4868-1-git-send-email-ldewangan@nvidia.com>
References: <1380202431-4868-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/palmas.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 9607d24..3b63139 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -368,6 +368,7 @@ static const struct of_device_id of_palmas_match_tbl[] = {
 	},
 	{ },
 };
+MODULE_DEVICE_TABLE(of, of_palmas_match_tbl);
 
 static int palmas_i2c_probe(struct i2c_client *i2c,
 			    const struct i2c_device_id *id)
-- 
1.7.1.1


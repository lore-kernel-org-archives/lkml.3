Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbaEMLCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:02:40 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:13029 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760077AbaEMK7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:59:05 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-79-5371faf6fbcb
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 14/16] mfd: max77686: Make of_device_id array const
Date: Tue, 13 May 2014 12:58:51 +0200
Message-id: <1399978733-13662-14-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJMWRmVeSWpSXmKPExsVy+t/xy7rffhUGG+z5bWTx+oWhxf2vRxkt
	Lu+aw2ZxupvVgcXjzrU9bB7zTgZ69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV0bD9ydMBbtY
	K5qucTUwHmfpYuTkkBAwkWiY/48NwhaTuHBvPZDNxSEksJRR4sH7DawQTh+TxKEl35lAqtgE
	jCU2L18C1iEikCXxY9pqsEnMAoYSP9/9YQexhQWcJaZ87GYFsVkEVCUuX9sJ1MvBwSvgITHv
	oyvEMjmJk8cmg5VwAoVf3D4LZgsJuEvcWDWJZQIj7wJGhlWMoqmlyQXFSem5RnrFibnFpXnp
	esn5uZsYIUHydQfj0mNWhxgFOBiVeHg9mAuChVgTy4orcw8xSnAwK4nwun8qDBbiTUmsrEot
	yo8vKs1JLT7EyMTBKdXAmPnpqHIc0z6tU69nXXooe6GQkeUS78tHdifb2z5915v5b0nY/BOe
	NzZOnSKirPtUxoMhOFzG1efzNf+VvfcZdq18ucbD40OL57Oc7XGbFq/9Iv3Uy+PreoPYJT5O
	mc5ea90/mZvPcDl7eW7btO1NUYuDcmJU3Vef+mSfPuuyx1NOhtC5GkrvbiqxFGckGmoxFxUn
	AgD9lR9Y8AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Array of struct of_device_id may be be const as expected by
of_match_table field.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/max77686.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max77686.c b/drivers/mfd/max77686.c
index e5fce765accb..ce869acf27ae 100644
--- a/drivers/mfd/max77686.c
+++ b/drivers/mfd/max77686.c
@@ -47,7 +47,7 @@ static struct regmap_config max77686_regmap_config = {
 };
 
 #ifdef CONFIG_OF
-static struct of_device_id max77686_pmic_dt_match[] = {
+static const struct of_device_id max77686_pmic_dt_match[] = {
 	{.compatible = "maxim,max77686", .data = NULL},
 	{},
 };
-- 
1.9.1


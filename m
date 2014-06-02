Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaFBGaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 02:30:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:43696 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaFBG37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 02:29:59 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-cf-538c19e5911b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Haojian Zhuang'" <haojian.zhuang@gmail.com>
References: <000101cf7e2b$b5c9f9c0$215ded40$%han@samsung.com>
In-reply-to: <000101cf7e2b$b5c9f9c0$215ded40$%han@samsung.com>
Subject: [PATCH 2/3] regulator: max8649: remove unnecessary OOM messages
Date: Mon, 02 Jun 2014 15:29:57 +0900
Message-id: <000201cf7e2c$129996b0$37ccc410$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9+K7WAMnl298jeROKabyh9CsMnMAAACi3w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zQ92nkj3BBi97ZCymPnzCZnFhnbnF
	5YWXWC2+Xelgsri8aw6bA6vHzll32T02repk8+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	5Y9mMRacZ6v41nGCrYHxIGsXIyeHhICJxLn+i1C2mMSFe+vZuhi5OIQEljFKtJ7cxg5TdGLd
	TEaIxHRGiX+T77BDOL8ZJT6t3ccEUsUmoCbx5cthoAQHh4iAqsT/V+4gNcwCsxglGhb9ZQGp
	ERKwldi88ArYVE4BO4mJ9y8xgdQLC3hIrF4vDRJmAWrtbl/MDGLzApXvevaZBcIWlPgx+R6Y
	zSygJbF+53EmCFteYvOat8wgYyQE1CUe/dUFCYsIGEn8mLMWqlxEYt+Ld2D3SwhcY5d4N2E1
	E8QuAYlvkw+xQPTKSmw6wAzxr6TEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ
	6UVGesWJucWleel6yfm5mxgh0dm3g/HmAetDjMlA6ycyS4km5wOjO68k3tDYzMjC1MTU2Mjc
	0ow0YSVx3kUPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MJaunrToaW7D5jzPsk+8LXES
	huJCaqcnS9W5/Ldzq5Gd1Cl9fRF/29ywqIl1KWv811rnWtzcI7q6qeVfr3HruTWxOmJbNr71
	aVj07OV75b+r9wl8uxVc4LNx6mpZJr9nV2pN3c8sdmcV/u8ntycjJMZsx6uGxfZ1R9bYda9n
	Vebmufuzk7H0rBJLcUaioRZzUXEiABeEuCDkAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jQd2nkj3BBp9mS1hMffiEzeLCOnOL
	ywsvsVp8u9LBZHF51xw2B1aPnbPusntsWtXJ5tG3ZRWjx+dNcgEsUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAe5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhHWMGcsfzWIsOM9W8a3jBFsD40HWLkZODgkBE4kT62YyQthi
	EhfurWfrYuTiEBKYzijxb/IddgjnN6PEp7X7mECq2ATUJL58OQyU4OAQEVCV+P/KHaSGWWAW
	o0TDor8sIDVCArYSmxdeYQexOQXsJCbev8QEUi8s4CGxer00SJgFqLW7fTEziM0LVL7r2WcW
	CFtQ4sfke2A2s4CWxPqdx5kgbHmJzWveMoOMkRBQl3j0VxckLCJgJPFjzlqochGJfS/eMU5g
	FJqFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBsf9MagfjygaL
	Q4wCHIxKPLwTFnQFC7EmlhVX5h5ilOBgVhLhPXq2O1iINyWxsiq1KD++qDQntfgQYzLQoxOZ
	pUST84FpKa8k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGHW9
	6zJDuq8J7tQ2mPXcMOGAjf3DcKMHjlNKFrjFFvuwGa8Wfaa4QjCHZ9cti8Qta0K4FdZsWDar
	wCb4/WPHNe5ut5jOT7kc1NXH9q4zfd8S65LdE5ezfWXJKcoOK7rg3LBgU6Xj9XeMfBNfP59s
	ovBwI0+Z/nNl7ZSbPfeuSL+Lk85aXPRVQYmlOCPRUIu5qDgRAAb+LxtBAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/max8649.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index 3172da8..c8bddcc 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -161,10 +161,8 @@ static int max8649_regulator_probe(struct i2c_client *client,
 
 	info = devm_kzalloc(&client->dev, sizeof(struct max8649_regulator_info),
 			    GFP_KERNEL);
-	if (!info) {
-		dev_err(&client->dev, "No enough memory\n");
+	if (!info)
 		return -ENOMEM;
-	}
 
 	info->regmap = devm_regmap_init_i2c(client, &max8649_regmap_config);
 	if (IS_ERR(info->regmap)) {
-- 
1.7.10.4



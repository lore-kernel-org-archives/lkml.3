Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaBQJPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:15:48 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:39974 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaBQJGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:06:15 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-95-5301d107df4b
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>
Subject: [PATCH v3 12/15] power: max17040: Add ID for max77836 Fuel Gauge block
Date: Mon, 17 Feb 2014 10:05:47 +0100
Message-id: <1392627950-26927-13-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
References: <1392627950-26927-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLLMWRmVeSWpSXmKPExsVy+t/xa7rsFxmDDXbcZLI4uFXTYuOM9awW
	Ux8+YbO4/uU5q8WkJ++ZLSaunMxs8fqFocXZpjfsFve/HmW02PT4GqvF5V1z2CzWHrnLbnG7
	cQWbxeluVov1M16zOPB7TOj/xOixc9Zddo/NK7Q8Nq3qZPO4c20Pm8e8k4Eem5fUe/RtWcXo
	8XmTXABnFJdNSmpOZllqkb5dAldG461u5oJ37BW7O4+yNTDeYeti5OSQEDCRmHhwGwuELSZx
	4d56oDgXh5DAUkaJ8907WSCcPiaJS5cvM4JUsQkYS2xevgSsSkSghUni/fr9jCAOs8ALJome
	/f2sIFXCAv4SrRvvgu1gEVCVuH39CTOIzSvgIfFm/R6gBg6gfQoScybZgIQ5gcI3l95iB7GF
	BNwlnjzawTKBkXcBI8MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJAg/rqDcekxq0OMAhyM
	Sjy8BtWMwUKsiWXFlbmHGCU4mJVEeG3XAYV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwququmxyy
	y+vKt3kBO5rmrs3P72b8W/laTP3DPsUupYX3lqwQevZI5nOAmKdmA2tyas+JZo85fOq/V4fr
	bGVPEAvtjK+9f1n8/cMJiSkeuzr+njo0la9p0rdC9/vypYnefJu+1v4xFDLerhGzv3v2pY2r
	k6Ob1l+xLAxojfWJ2Lry7se3fwRuKbEUZyQaajEXFScCAMMIyp5AAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX77836 has the same Fuel Gauge as MAX17040. The max17040 driver can be
safely re-used. The patch adds MAX77836 ID to array with i2c_device_id.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/max17040_battery.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
index 0fbac861080d..165ffe381803 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -278,6 +278,7 @@ static SIMPLE_DEV_PM_OPS(max17040_pm_ops, max17040_suspend, max17040_resume);
 
 static const struct i2c_device_id max17040_id[] = {
 	{ "max17040", 0 },
+	{ "max77836-battery", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max17040_id);
-- 
1.7.9.5


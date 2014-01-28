Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124AbaA1MTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:19:23 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32551 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbaA1MTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:19:13 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-76-52e7a03f8a06
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 17/18] power: max17040: Add ID for max77836 Fuel Gauge block
Date: Tue, 28 Jan 2014 13:18:41 +0100
Message-id: <1390911522-28209-18-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t/xa7r2C54HGUzv57M4uFXTYurDJ2wW
	1788Z7WY9OQ9s8XElZOZLV6/MLQ42/SG3eL+16OMFt+udDBZbHp8jdXi8q45bBZrj9xlt7jd
	uILN4nQ3qwOfx4T+T4weO2fdZffYvELLY9OqTjaPO9f2sHnMOxnosXlJvUffllWMHp83yQVw
	RnHZpKTmZJalFunbJXBlLH7/kq3gHXvFm1nH2BsY77B1MXJySAiYSKzePpsZwhaTuHBvPVCc
	i0NIYCmjxMEbX9khnD4miQtt68Cq2ASMJTYvXwJWJSKwmklizYKpLCAOM0jV4lvH2UGqhAV8
	JDo/t7CC2CwCqhJPfjSD2bwCHhKPm7YCdXMA7VOQmDPJBiTMCRR+dbWRCcQWEnCXOHX8HcsE
	Rt4FjAyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUJC98sOxsXHrA4xCnAwKvHwdnQ+CxJi
	TSwrrsw9xCjBwawkwps4+3mQEG9KYmVValF+fFFpTmrxIUYmDk6pBsYg1d3+r2/3KDFWfgmM
	+xbjYT7LQur0RLF3ReH6e89lNtedrVO8LRmrV7f3Y2LfhyNyX3e+W/Xe+Oudi5WTehfEPzi0
	8N6xgklHrOVuca9Wv/l5+yvbLkMhzu/av2Qufdiqqm148sr09duWmwkmari+1c9S9/eqrWl0
	2XM8RLbtyN0E4UWx3txKLMUZiYZazEXFiQDLbllFOwIAAA==
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
index c7ff6d67f158..591984a93f9f 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -277,6 +277,7 @@ static SIMPLE_DEV_PM_OPS(max17040_pm_ops, max17040_suspend, max17040_resume);
 
 static const struct i2c_device_id max17040_id[] = {
 	{ "max17040", 0 },
+	{ "max77836-battery", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max17040_id);
-- 
1.7.9.5


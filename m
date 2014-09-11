Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbaIKMyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:54:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57473 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756542AbaIKMyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:54:31 -0400
X-AuditID: cbfee68d-f79c46d000000b84-5f-54119b8268cf
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v4 3/4] mfd: max77693: add haptic of_compatible in mfd_cell
Date: Thu, 11 Sep 2014 21:54:21 +0900
Message-id: <1410440062-19963-4-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1410440062-19963-1-git-send-email-jaewon02.kim@samsung.com>
References: <1410440062-19963-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWyRsSkWLd5tmCIQfcCJovrX56zWhxe9ILR
	YkfDEVaL+1+PMlrc/PSN1eLyrjlsFqe7WR3YPXbOusvucefaHjaPeScDPfq2rGL0+LxJLoA1
	issmJTUnsyy1SN8ugSuj81M7e8E+torDtzrZGhhXsnYxcnJICJhI3PtyhRHCFpO4cG89Wxcj
	F4eQwFJGiXNbXzLCFE1ZcYsZIrGIUWLByvtQVW1MEl2rfrOBVLEJaEt8X78YbKyIQKVEf/cL
	VpAiZoEeRomlq5aygySEBbwlzi05ygJiswioSnxe9h6sgVfAQ+LS9F1ANRxA6xQk5kyyAQlz
	CnhK3OqeA9YqBFRyrmclC8hMCYHp7BId209BzRGQ+Db5EAtEr6zEpgPMEFdLShxccYNlAqPw
	AkaGVYyiqQXJBcVJ6UWGesWJucWleel6yfm5mxiBQX7637PeHYy3D1gfYhTgYFTi4a1gEQwR
	Yk0sK67MPcRoCrRhIrOUaHI+MJbySuINjc2MLExNTI2NzC3NlMR5FaV+BgsJpCeWpGanphak
	FsUXleakFh9iZOLglGpgVLhln7X/wtowpunR8uJNMRK7jm1xuirNzpBgv7BVdUlDJMMz2VaR
	zg7ts8w1c6LlJd+I71JyMj+uYCgZYhxcvUGhuKHwtk9My8JM7wdmEZt2J13ztVM8+vfkgXPH
	jOYYPG99WxAtGGGqxCLzucryXfT27Stl036HRv2yvXX6ukW8IvdxeSElluKMREMt5qLiRAAQ
	gh4GbQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t9jAd2m2YIhBleaLS2uf3nOanF40QtG
	ix0NR1gt7n89ymhx89M3VovLu+awWZzuZnVg99g56y67x51re9g85p0M9OjbsorR4/MmuQDW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGZ2f2tkL9rFVHL7VydbAuJK1
	i5GTQ0LARGLKilvMELaYxIV769m6GLk4hAQWMUosWHkfymljkuha9ZsNpIpNQFvi+/rFYN0i
	ApUS/d0vWEGKmAV6GCWWrlrKDpIQFvCWOLfkKAuIzSKgKvF52XuwBl4BD4lL03cB1XAArVOQ
	mDPJBiTMKeApcat7DlirEFDJuZ6VLBMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93E
	CI6hZ1I7GFc2WBxiFOBgVOLhrWARDBFiTSwrrsw9xCjBwawkwntjOlCINyWxsiq1KD++qDQn
	tfgQoynQUROZpUST84HxnVcSb2hsYmZkaWRuaGFkbK4kznug1TpQSCA9sSQ1OzW1ILUIpo+J
	g1OqgVFO76HsI7NDiVd/P6vInWW+6+bKAwGZN1yNYmccfFNy5uq6tdrurXMuaFXfVLnqXcMf
	3DPx844fNsLX+h8fOzG3tdPiQ8KJB2ZhN6Mvqb3LzVDv2Td/YgR/Z3j4U/Ef/Gu1pm9P2qDM
	WcagcP/RbUmx/cJX3eSefKyfOOGW4y9jxl7zV7esjPiUWIozEg21mIuKEwGQh0z5twIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add haptic of_compatible in order to use the haptic
device driver using Devicetree.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/mfd/max77693.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index fbfed56..5b516fe 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -46,7 +46,10 @@ static const struct mfd_cell max77693_devs[] = {
 	{ .name = "max77693-charger", },
 	{ .name = "max77693-flash", },
 	{ .name = "max77693-muic", },
-	{ .name = "max77693-haptic", },
+	{
+		.name = "max77693-haptic",
+		.of_compatible = "maxim,max77693-haptic",
+	},
 };
 
 static const struct regmap_config max77693_regmap_config = {
-- 
1.7.9.5


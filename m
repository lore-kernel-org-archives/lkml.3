Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaLSJah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:30:37 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64318 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaLSJ3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:29:39 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-cf-5493f0012bc9
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] mfd: max77693: Remove unused structures
Date: Fri, 19 Dec 2014 10:29:19 +0100
Message-id: <1418981359-16457-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418981359-16457-1-git-send-email-k.kozlowski@samsung.com>
References: <1418981359-16457-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsVy+t/xq7qMHyaHGJx5xW8x9eETNovXLwwt
	7n89ymjx7UoHk8XlXXPYLE53szqweeycdZfdY9OqTjaPO9f2sHnMOxno0bdlFaPH501yAWxR
	XDYpqTmZZalF+nYJXBmfVv5nLljAVXH532rmBsYDHF2MnBwSAiYSPSsPsELYYhIX7q1n62Lk
	4hASWMoose37IhYIp49JovXFD0aQKjYBY4nNy5eAVYkIbGKU6Hi8GCzBLGAo8fPdH3YQW1jA
	RuJKQxuYzSKgKnHr6FU2EJtXwF1i2ZwNjBDr5CROHpsMtppTwEPizY6JYDVCQDV7999lmsDI
	u4CRYRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSEh93cG49JjVIUYBDkYlHt4PjZNDhFgT
	y4orcw8xSnAwK4nwOh4HCvGmJFZWpRblxxeV5qQWH2Jk4uCUamCsm+Jg+N/jxUelH55317ou
	SAxe7FmbcPlahY1Krto1eeucfVFVXzY9vbCfIejyzudRJX/WWB2z4W1OaK6bqbNGZeZvpv5k
	72SBD3G5v0/aPfoWL7D20n/z+EmH/4l++20tlZAZu4FXYeFShhnZrzX+RjH5bk8/Hvdhm3Ta
	CieJyV/9r3bOfpWjxFKckWioxVxUnAgAZnFKoAcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max77693 regulator driver no longer supports board files. Remove the
left-overs. Additionally fix name of device in comment.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 include/linux/mfd/max77693.h | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
index f0b6585cd874..09a4dedaeea8 100644
--- a/include/linux/mfd/max77693.h
+++ b/include/linux/mfd/max77693.h
@@ -30,7 +30,7 @@
 #ifndef __LINUX_MFD_MAX77693_H
 #define __LINUX_MFD_MAX77693_H
 
-/* MAX77686 regulator IDs */
+/* MAX77693 regulator IDs */
 enum max77693_regulators {
 	MAX77693_ESAFEOUT1 = 0,
 	MAX77693_ESAFEOUT2,
@@ -38,12 +38,6 @@ enum max77693_regulators {
 	MAX77693_REG_MAX,
 };
 
-struct max77693_regulator_data {
-	int id;
-	struct regulator_init_data *initdata;
-	struct device_node *of_node;
-};
-
 struct max77693_reg_data {
 	u8 addr;
 	u8 data;
@@ -103,10 +97,6 @@ struct max77693_led_platform_data {
 /* MAX77693 */
 
 struct max77693_platform_data {
-	/* regulator data */
-	struct max77693_regulator_data *regulators;
-	int num_regulators;
-
 	/* muic data */
 	struct max77693_muic_platform_data *muic_data;
 	struct max77693_led_platform_data *led_data;
-- 
1.9.1


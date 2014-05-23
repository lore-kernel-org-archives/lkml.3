Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaEWJDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:03:36 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:27269 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbaEWJDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:03:34 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-46-537f0ed2db8f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: [PATCH] extcon: palmas: Make of_device_id array const
Date: Fri, 23 May 2014 11:03:05 +0200
Message-id: <1400835785-26947-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGJMWRmVeSWpSXmKPExsVy+t/xy7qX+OqDDS4eN7G4/uU5q0X/FheL
	1y8MLS7vmsNmcbtxBZsDq0ffllWMHlOn/GX0+LxJLoA5issmJTUnsyy1SN8ugSvjz9QlzAU/
	2SpetE5gaWD8wdrFyMEhIWAi8edFVhcjJ5ApJnHh3nq2LkYuDiGBpYwS2772MoIkhAT6mCT+
	dpaD2GwCxhKbly9hA7FFBAolnmy4CmYzC0RI9PYtYAGxhQXsJD4umMgMYrMIqEr8vngbzOYV
	cJdYPn8TC8QyOYmTxyazTmDkXsDIsIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjxO9fdzAu
	PWZ1iFGAg1GJh5dDrS5YiDWxrLgy9xCjBAezkgivLXN9sBBvSmJlVWpRfnxRaU5q8SFGJg5O
	qQbG2E1vSkx0mOuZH+Q+t/xkXjczc6t13PWvc5MitSels0j++1DMb8/5eHuTmu/knY7mXlF/
	ko2my+93O9C7NNxEYpuicceO7vyPziLVcsvXf1lV/bRUIFcn+eKWmPwTbfm3vU89nfD6PzMX
	X4mA49YjHEfXvC6/8tx5XfoTh4IvmcqbxX3yN9YosRRnJBpqMRcVJwIAKIwP5tkBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Array of struct of_device_id may be be const as expected by
of_match_table field.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>
---
 drivers/extcon/extcon-palmas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index ddff2b72f0a8..eb59fe564fd1 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -273,7 +273,7 @@ static int palmas_usb_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(palmas_pm_ops, palmas_usb_suspend, palmas_usb_resume);
 
-static struct of_device_id of_palmas_match_tbl[] = {
+static const struct of_device_id of_palmas_match_tbl[] = {
 	{ .compatible = "ti,palmas-usb", },
 	{ .compatible = "ti,palmas-usb-vid", },
 	{ .compatible = "ti,twl6035-usb", },
-- 
1.9.1


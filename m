Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaKLKbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:31:09 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:37180 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbaKLKbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:31:05 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-35-546336e2730f
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org, Vivek Gautam <gautam.vivek@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: [PATCH] phy: phy-samsung-usb2: Don't use same name for driver name and
 global structure
Date: Wed, 12 Nov 2014 15:54:53 +0530
Message-id: <1415787893-21857-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWyRsSkWveRWXKIweIdEhZtVw6yW/x4fYHN
	4sLTHjaLy7vmsFksWtbK7MDq0bdlFaPH8RvbmTw+b5ILYI7isklJzcksSy3St0vgyljb+Y69
	YDFXxfljbcwNjI84uhg5OSQETCS6vl9hgrDFJC7cW8/WxcjFISSwlFHi8LMDrDBF93Z8ZAex
	hQQWMUp0vUqEKJrAJLHl3UWwIjYBXYmmt7sYQWwRAQWJzb3PWEGKmAWmMkosvTEDrEhYIEli
	6Zk9YOtYBFQlvu1fCNbAK+AhcWrNfKANHEDbFCTmTLIB6ZUQeM4msfnLLHaIegGJb5MPsUDU
	yEpsOsAMcZykxMEVN1gmMAouYGRYxSiaWpBcUJyUXmSiV5yYW1yal66XnJ+7iREYjqf/PZuw
	g/HeAetDjAIcjEo8vAlrkkKEWBPLiitzDzGaAm2YyCwlmpwPDPq8knhDYzMjC1MTU2Mjc0sz
	JXHe11I/g4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwhs+wk286trDI8+Re30iZM2WTOhMW
	Mzw4rJOw3qQ5Iqrm8ipvm4AnEau+3E158e0GR3ZOvmvVcWGhPw2662P0Of+1HLhnvkEmO3FN
	sf4acd7nMvsMTi6fv0/Evzbd6l/gnmatqQXVxe9vmK/TWZV4x/Gs+AwpzzOx8csMNj+sW8Mp
	l3tX5aSAEktxRqKhFnNRcSIA0oMLiEICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t9jAd1HZskhBo/nC1i0XTnIbvHj9QU2
	iwtPe9gsLu+aw2axaFkrswOrR9+WVYwex29sZ/L4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/d
	Vsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2inkkJZYk4pUCggsbhYSd8O04TQEDdd
	C5jGCF3fkCC4HiMDNJCwhjFjbec79oLFXBXnj7UxNzA+4uhi5OSQEDCRuLfjIzuELSZx4d56
	NhBbSGARo0TXq8QuRi4gewKTxJZ3F1lBEmwCuhJNb3cxgtgiAgoSm3ufsYIUMQtMZZRYemMG
	WJGwQJLE0jN7mEBsFgFViW/7F4I18Ap4SJxaMx9oGwfQNgWJOZNsJjByL2BkWMUomlqQXFCc
	lJ5rpFecmFtcmpeul5yfu4kRHOzPpHcwrmqwOMQowMGoxMObsTkpRIg1say4MvcQowQHs5II
	L7dxcogQb0piZVVqUX58UWlOavEhRlOg5ROZpUST84GRmFcSb2hsYm5qbGppYmFiZqkkznuw
	1TpQSCA9sSQ1OzW1ILUIpo+Jg1OqgdH+X7rjNPuARsH7t5eoqH979KmOg9XyaNnGXbXzt5u3
	bJqq8nP6xaA63hnH3zz76JF5+XWXoqGxuTdjMme+fvoa/konpk4rZ5Nrb0xMU7NrojN+8zFM
	2GV9ZP2Z9Y4rBKYb3P6ic5H5S8lvy+arP698Odt1N77sM/fq+qe/v7umHpy9d0XY9d9KLMUZ
	iYZazEXFiQC0pjNZjAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the same driver name for platform driver and a globally defined,
structure used throughout the file, looks a bit unpleasing.
So changing the driver name from "samsung_usb2_phy_driver" to
"samsung_usb2_phy"

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/phy/phy-samsung-usb2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-samsung-usb2.c
index 908949d..2934fb7 100644
--- a/drivers/phy/phy-samsung-usb2.c
+++ b/drivers/phy/phy-samsung-usb2.c
@@ -226,7 +226,7 @@ static int samsung_usb2_phy_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static struct platform_driver samsung_usb2_phy_driver = {
+static struct platform_driver samsung_usb2_phy = {
 	.probe	= samsung_usb2_phy_probe,
 	.driver = {
 		.of_match_table	= samsung_usb2_phy_of_match,
@@ -234,7 +234,7 @@ static struct platform_driver samsung_usb2_phy_driver = {
 	}
 };
 
-module_platform_driver(samsung_usb2_phy_driver);
+module_platform_driver(samsung_usb2_phy);
 MODULE_DESCRIPTION("Samsung S5P/EXYNOS SoC USB PHY driver");
 MODULE_AUTHOR("Kamil Debski <k.debski@samsung.com>");
 MODULE_LICENSE("GPL v2");
-- 
1.7.10.4


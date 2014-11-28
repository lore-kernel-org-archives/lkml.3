Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaK1NbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:31:16 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16216 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaK1NbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:31:14 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-f3-5478791febac
From: Karol Wrona <k.wrona@samsung.com>
To: Sebastian Reichel <sre@kernel.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH] power: max14577: Remove SYSFS dependency from Kconfig
Date: Fri, 28 Nov 2014 14:23:02 +0100
Message-id: <1417180982-15127-1-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIJMWRmVeSWpSXmKPExsVy+t/xq7oKlRUhButMLDbOWM9q8fqFocWp
	ZfuZLM42vWG3uLxrDpvF594jjBand5c4sHtsWtXJ5tG3ZRWjx+dNcgHMUVw2Kak5mWWpRfp2
	CVwZ0y9eZSzYzVrx6NQ7lgbGbSxdjJwcEgImEt9+vWODsMUkLtxbD2RzcQgJLGWUOLvyJDuE
	08ck8W/zFXaQKjYBdYnmHYuZQWwRgQSJJcduM4IUMQvsZJQ4P28/2FhhATeJlgM/wWwWAVWJ
	nddbwZp5BZwl/t6ZCtTAAbROQWLOJJsJjNwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+du
	YoQEw5cdjIuPWR1iFOBgVOLhPZBcESLEmlhWXJl7iFGCg1lJhDe9BCjEm5JYWZValB9fVJqT
	WnyIkYmDU6qBMeXIfm4u45OcKyss7fQECuN1zia5xE64U+7HsJZ/yvkPR2KSpHY4HniwQnPH
	0WTj1T1ibF+OsJ3YwL7w2vmpO82P5U1n82pbbiUbN2vnTfEU5xSb2eYevj72G4QXv9d5fvzB
	dbOl3ucD9nRkWNa+cngiv2PN6T0KM3giw626SmJVY55GF3xcqsRSnJFoqMVcVJwIAP74MBvk	AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is only a small clean-up. The driver can be built without SYSFS
as there exist stubs for used functions.

Signed-off-by: Karol Wrona <k.wrona@samsung.com>
---
 drivers/power/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 0108c2a..69fa8a9 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -327,7 +327,6 @@ config CHARGER_MANAGER
 config CHARGER_MAX14577
 	tristate "Maxim MAX14577/77836 battery charger driver"
 	depends on MFD_MAX14577
-	depends on SYSFS
 	help
 	  Say Y to enable support for the battery charger control sysfs and
 	  platform data of MAX14577/77836 MUICs.
-- 
1.7.9.5


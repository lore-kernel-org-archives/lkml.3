Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab3C1GXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:23:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:53021 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750Ab3C1GXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:23:15 -0400
X-AuditID: cbfee68d-b7f786d000005188-a5-5153e1ba901d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/3] backlight: omap1: convert omapbl to dev_pm_ops
Date: Thu, 28 Mar 2013 15:22:50 +0900
Message-id: <000201ce2b7c$ac0d1280$04273780$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4rfKvKs9cALAZgRNGI8/RGwG6ZcA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zI91dD4MDDQ7dNbCYs34Nm8XlhZdY
	LS7vmsNmsXvXU1YHFo8TM36zeOyZ/4PVo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDJ6dl9g
	K/jMX9F9fiVzA+Mi3i5GTg4JAROJXc9+MUHYYhIX7q1n62Lk4hASWMYo8XjpPpYuRg6wossr
	+CDiixglnjX9hCr6xSixc9I7VpBuNgE1iS9fDrODNIgI6Eu0tWiAhJkFSiW2PnjPAmILCzhL
	HDvwBWwZi4CqRNObrWBxXgFbiUOfV7FB2IISPybfY4Ho1ZJYv/M4E4QtL7F5zVtmiHvUJR79
	1QUJiwjoSfy68JkZokREYt+Ld4wgp0kIbGKX6G46wgaxS0Di2+RDUL/ISmw6wAzxr6TEwRU3
	WCYwis1CsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UWGesWJucWleel6yfm5mxghMda7g/H2
	AetDjMlA6ycyS4km5wNjNK8k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC1KL4
	otKc1OJDjEwcnFINjMvr+bTWFzFEnnxsFfVWfcYH/Y9u++5NP5nY2HvWpkP0wZWTAgXfWQx0
	du/x2rfq1rXlM3jfnudYdvDA4ze7IqXlD/38v5fVussteennw54vv1ne4AiPreP6/szltfGM
	2O7Tmg7lV0+GdvuctzBQ81+z8t+ExFe+rptSO0uvKLC/UnuifeYX61IlluKMREMt5qLiRABW
	ZSKbxwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd1dD4MDDa580rGYs34Nm8XlhZdY
	LS7vmsNmsXvXU1YHFo8TM36zeOyZ/4PVo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgzenZfYCv4zF/RfX4lcwPjIt4uRg4OCQETicsr+LoYOYFMMYkL
	99azdTFycQgJLGKUeNb0E8r5xSixc9I7VpAqNgE1iS9fDrODNIsI6Eu0tWiAhJkFSiW2PnjP
	AmILCzhLHDvwhQnEZhFQlWh6sxUszitgK3Ho8yo2CFtQ4sfkeywQvVoS63ceZ4Kw5SU2r3nL
	DHGbusSjv7ogYREBPYlfFz4zQ5SISOx78Y5xAqPALCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4o
	TkrPNdQrTswtLs1L10vOz93ECI7gZ1I7GFc2WBxiFOBgVOLhrRAIDhRiTSwrrsw9xCjBwawk
	wnuoEyjEm5JYWZValB9fVJqTWnyIMRno0YnMUqLJ+cDkklcSb2hsYmZkaWRmYWRibk6asJI4
	74FW60AhgfTEktTs1NSC1CKYLUwcnFINjMfMLy3S6b4fMGO69qr5ceGr6uZ/FJhwkj0jROvA
	K/4vIhNjP2lN21Yx1Sd8QqCOxe2Kq5UP3l3N4Xrjxmm+RbDi1zpLuWu2waEvTq+PyN9oWjpJ
	ca05J4eZW3KpT0jo8uYvPs29EWsy9+uXzC2WqV9jZrOc/cnDSPbTOxnkpwqEM0jyTuK/p8RS
	nJFoqMVcVJwIAD/6IhskAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/omap1_bl.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index 0aed176..812e22e 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -71,27 +71,24 @@ static void omapbl_blank(struct omap_backlight *bl, int mode)
 	}
 }
 
-#ifdef CONFIG_PM
-static int omapbl_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int omapbl_suspend(struct device *dev)
 {
-	struct backlight_device *dev = platform_get_drvdata(pdev);
-	struct omap_backlight *bl = bl_get_data(dev);
+	struct backlight_device *bl_dev = dev_get_drvdata(dev);
+	struct omap_backlight *bl = bl_get_data(bl_dev);
 
 	omapbl_blank(bl, FB_BLANK_POWERDOWN);
 	return 0;
 }
 
-static int omapbl_resume(struct platform_device *pdev)
+static int omapbl_resume(struct device *dev)
 {
-	struct backlight_device *dev = platform_get_drvdata(pdev);
-	struct omap_backlight *bl = bl_get_data(dev);
+	struct backlight_device *bl_dev = dev_get_drvdata(dev);
+	struct omap_backlight *bl = bl_get_data(bl_dev);
 
 	omapbl_blank(bl, bl->powermode);
 	return 0;
 }
-#else
-#define omapbl_suspend	NULL
-#define omapbl_resume	NULL
 #endif
 
 static int omapbl_set_power(struct backlight_device *dev, int state)
@@ -182,13 +179,14 @@ static int omapbl_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static SIMPLE_DEV_PM_OPS(omapbl_pm_ops, omapbl_suspend, omapbl_resume);
+
 static struct platform_driver omapbl_driver = {
 	.probe		= omapbl_probe,
 	.remove		= omapbl_remove,
-	.suspend	= omapbl_suspend,
-	.resume		= omapbl_resume,
 	.driver		= {
 		.name	= "omap-bl",
+		.pm	= &omapbl_pm_ops,
 	},
 };
 
-- 
1.7.2.5



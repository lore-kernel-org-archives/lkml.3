Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab3B1Ilw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:41:52 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48057 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077Ab3B1Ils (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:41:48 -0500
X-AuditID: cbfee68d-b7f636d0000009be-3d-512f184b43b4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
In-reply-to: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
Subject: [PATCH 08/19] rtc: rtc-coh901331: remove erroneous __init/__exit
 annotations
Date: Thu, 28 Feb 2013 17:41:46 +0900
Message-id: <00ac01ce158f$719219f0$54b64dd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAAAHZMg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zQ11vCf1Ag6N/+CyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKuD1pJ3vBS+6KT0+kGxi/cXYxcnJICJhIfDmynh3CFpO4cG89WxcjF4eQwDJGiU0d
	rewwRavPvWaBSExnlNg/fQZYQkjgF6NE5xs1EJtNQE3iy5fDQHEODhEBfYm2Fg2QemaBXkaJ
	M727oeptJY61tbGA2JwCdhK/nx5lBbGFBcIlZi34wARiswioSsw6NJ8FZA4vUP2djRIgYV4B
	QYkfk++BtTILaEms33mcCcKWl9i85i0zSLmEgLrEo7+6EBcYSWx/VgNRISKx78U7RohPbrFL
	XF6gCbFIQOLb5EMsEJ2yEpsOMEOUSEocXHGDZQKjxCwke2ch2TsLyd5ZSDYsYGRZxSiaWpBc
	UJyUXmSoV5yYW1yal66XnJ+7iRESob07GG8fsD7EmAy0fiKzlGhyPjDC80riDY2NTcxMTE3M
	LU3NTUkTVhLnlbskEygkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB8WBB6qejfiV1N8UvKjH7
	yK/36xBIWW16zPu9yN4Gs+9flcwsY+5yHN9Z/6i3ZM2USptVl/pfX7u6/ZbmpHSvuNnzSz5F
	WPZ9LjZOnp7ceWEi+9Wbb6/kxjtt65r6+nbhze8yuQc07Xyq0x2Vs5ekOW/uetV+mbv01ppT
	0rM+aNiwiKy7ovX4vBJLcUaioRZzUXEiAJnhb5XmAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jQV1vCf1Ag91LuCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzLg9aSd7wUvuik9PpBsYv3F2MXJySAiYSKw+
	95oFwhaTuHBvPVsXIxeHkMB0Ron902ewgySEBH4xSnS+UQOx2QTUJL58OQwU5+AQEdCXaGvR
	AKlnFuhllDjTuxuq3lbiWFsb2FBOATuJ30+PsoLYwgLhErMWfGACsVkEVCVmHZrPAjKHF6j+
	zkYJkDCvgKDEj8n3wFqZBbQk1u88zgRhy0tsXvOWGaRcQkBd4tFfXYgLjCS2P6uBqBCR2Pfi
	HeMERqFZSAbNQjJoFpJBs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnACeSe9g
	XNVgcYhRgINRiYe3w0QvUIg1say4MvcQowQHs5IIrwu/fqAQb0piZVVqUX58UWlOavEhxmSg
	NycyS4km5wOTU15JvKGxiZmRpZGZhZGJuTlpwkrivIynngQICaQnlqRmp6YWpBbBbGHi4JRq
	YOwJXptvVKG3V/qclnZ6ljyneNBRYYWrCRM1F/VXl8tq6rjN0hRwu1BixDZJQ/v1lpYddx6V
	OD05HWj63PfjV/EMhmlnnq/kV9U2Wfu7UOeVuswxPeXIxS96rc82B6gHx53nXzo55Napyy8y
	Zu4703SuLXfdHjOVp74V+nwtLzQ+tSgei5nBrsRSnJFoqMVcVJwIAOb88wBEAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__init/__exit annotations for probe()/remove() are supposed to be
__devinit/__devexit, because __init/__exit for probe()/remove()
are not correct. However, __devinit/__devexit are not used,
because CONFIG_HOTPLUG was removed. Thus, these annotations
should be removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-coh901331.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-coh901331.c b/drivers/rtc/rtc-coh901331.c
index 2d28ec1..a166a37 100644
--- a/drivers/rtc/rtc-coh901331.c
+++ b/drivers/rtc/rtc-coh901331.c
@@ -150,7 +150,7 @@ static struct rtc_class_ops coh901331_ops = {
 	.alarm_irq_enable = coh901331_alarm_irq_enable,
 };
 
-static int __exit coh901331_remove(struct platform_device *pdev)
+static int coh901331_remove(struct platform_device *pdev)
 {
 	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
 
@@ -164,7 +164,7 @@ static int __exit coh901331_remove(struct platform_device *pdev)
 }
 
 
-static int __init coh901331_probe(struct platform_device *pdev)
+static int coh901331_probe(struct platform_device *pdev)
 {
 	int ret;
 	struct coh901331_port *rtap;
@@ -281,7 +281,7 @@ static struct platform_driver coh901331_driver = {
 		.name = "rtc-coh901331",
 		.owner = THIS_MODULE,
 	},
-	.remove = __exit_p(coh901331_remove),
+	.remove = coh901331_remove,
 	.suspend = coh901331_suspend,
 	.resume = coh901331_resume,
 	.shutdown = coh901331_shutdown,
-- 
1.7.2.5



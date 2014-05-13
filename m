Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbaEMK7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:59:13 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:13029 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760544AbaEMK7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:59:04 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-13-5371faf6209f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 12/16] mfd: max8997: Make of_device_id array const
Date: Tue, 13 May 2014 12:58:49 +0200
Message-id: <1399978733-13662-12-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHJMWRmVeSWpSXmKPExsVy+t/xy7rffhUGG5w7xmPx+oWhxf2vRxkt
	Lu+aw2ZxupvVgcXjzrU9bB7zTgZ69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8an/f/YCh6w
	Vuw9tZy9gfEpSxcjJ4eEgInEmcVdbBC2mMSFe+uBbC4OIYGljBLfu5YzQTh9TBKHlnxnAqli
	EzCW2Lx8CViHiECWxI9pq8EmMQsYSvx894cdxBYWcJI4fnMdUJyDg0VAVWLVnSqQMK+Ah0Tn
	s2vsEMvkJE4em8wKYnMCxV/cPgtmCwm4S9xYNYllAiPvAkaGVYyiqaXJBcVJ6bmGesWJucWl
	eel6yfm5mxghYfJlB+PiY1aHGAU4GJV4eAO4CoKFWBPLiitzDzFKcDArifC6fyoMFuJNSays
	Si3Kjy8qzUktPsTIxMEp1cAYG9vy59++2b7iAk01LW8N5vr92v8w4rUV97epM6pU1+qU302X
	zX970PfeJOfTAa1rfjzxZfx/KXhrt4bgRmG+AMaNi1Min7/kFLigtjCHv6qP3Wz64bM7n+jM
	v3ZAt6lQQf/GuuKPlxS6Dn5qLSi7Z96Te235zjrVgB1vtje6Gk70s2fxeaKqxFKckWioxVxU
	nAgA8+aGr/EBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Array of struct of_device_id may be be const as expected by both
of_match_table field and of_match_node() call.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/max8997.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index 8cf7a015cfe5..595364ee178a 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -51,7 +51,7 @@ static const struct mfd_cell max8997_devs[] = {
 };
 
 #ifdef CONFIG_OF
-static struct of_device_id max8997_pmic_dt_match[] = {
+static const struct of_device_id max8997_pmic_dt_match[] = {
 	{ .compatible = "maxim,max8997-pmic", .data = (void *)TYPE_MAX8997 },
 	{},
 };
-- 
1.9.1


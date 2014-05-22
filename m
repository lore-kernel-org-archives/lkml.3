Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaEVJS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:18:58 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:56844 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbaEVJS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:18:56 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH] mfd: axp20x: Remove unnecessary const qualifier from axp20x_supplies[]
Date: Thu, 22 May 2014 10:18:30 +0100
Message-Id: <1400750311-15323-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400750311-15323-1-git-send-email-lee.jones@linaro.org>
References: <1400750311-15323-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/mfd/axp20x.c:159:3:
  warning: initialization discards ‘const’ qualifier from pointer target type
   .parent_supplies = axp20x_supplies,
   ^
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/axp20x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index dee6539..5734f8c 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -140,7 +140,7 @@ static const struct regmap_irq_chip axp20x_regmap_irq_chip = {
 	.init_ack_masked	= true,
 };
 
-static const char * const axp20x_supplies[] = {
+static const char * axp20x_supplies[] = {
 	"acin",
 	"vin2",
 	"vin3",
-- 
1.8.3.2


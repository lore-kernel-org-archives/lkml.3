Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbaGYPdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:33:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33602 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507AbaGYPda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:33:30 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mfd: arizona: Add MICVDD to mapped regulators for wm8997
Date: Fri, 25 Jul 2014 16:24:43 +0100
Message-Id: <1406301884-7145-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous update adding MICVDD to the regulator mappings:

mfd: arizona: Add MICVDD to mapped regulators

Only added the mapping for wm5102 and wm5110 but wm8997 also has a
MICVDD supply that needs to be mapped back to the main Arizona device.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index e9c3563..e0d415e 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -613,6 +613,7 @@ static const struct mfd_cell wm5110_devs[] = {
 };
 
 static const char *wm8997_supplies[] = {
+	"MICVDD",
 	"DBVDD2",
 	"CPVDD",
 	"SPKVDD",
-- 
1.7.2.5


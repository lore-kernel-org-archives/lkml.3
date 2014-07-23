Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbaGWK7y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:59:54 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:47434 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306AbaGWKyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:54:16 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 07/25] clocksource: shmobile: Remove unused sh_timer_config members
Date: Wed, 23 Jul 2014 12:53:49 +0200
Message-Id: <1406112847-26275-7-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
References: <53CF93B2.6040903@linaro.org>
 <1406112847-26275-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The name, channel_offset, timer_bit, clockevent_rating and
clocksource_rating members are unused. Remove them.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Tested-by: Simon Horman <horms+renesas@verge.net.au>
---
 include/linux/sh_timer.h |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/sh_timer.h b/include/linux/sh_timer.h
index 8e1e036..64638b0 100644
--- a/include/linux/sh_timer.h
+++ b/include/linux/sh_timer.h
@@ -2,11 +2,6 @@
 #define __SH_TIMER_H__
 
 struct sh_timer_config {
-	char *name;
-	long channel_offset;
-	int timer_bit;
-	unsigned long clockevent_rating;
-	unsigned long clocksource_rating;
 	unsigned int channels_mask;
 };
 
-- 
1.7.9.5


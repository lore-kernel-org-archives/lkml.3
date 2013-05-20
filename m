Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3ETKwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:52:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55922 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab3ETKwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 002/115] ARM: at91: Fix typo in restart code panic message
Date: Mon, 20 May 2013 11:50:02 +0100
Message-Id: <1369047116-9378-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <maxime.ripard@free-electrons.com>

commit e7619459d47a673af3433208a42f583af920e9db upstream.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-at91/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 98c07d3..7c4edff 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -332,7 +332,7 @@ static void at91_dt_rstc(void)
 
 	of_id = of_match_node(rstc_ids, np);
 	if (!of_id)
-		panic("AT91: rtsc no restart function availlable\n");
+		panic("AT91: rtsc no restart function available\n");
 
 	arm_pm_restart = of_id->data;
 
-- 
1.8.1.2


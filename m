Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345Ab3EFVRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:17:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139Ab3EFUp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:45:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [ 008/115] ARM: at91: Fix typo in restart code panic message
Date: Mon,  6 May 2013 13:44:04 -0700
Message-Id: <20130506203056.442531201@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <maxime.ripard@free-electrons.com>

commit e7619459d47a673af3433208a42f583af920e9db upstream.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-at91/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -333,7 +333,7 @@ static void at91_dt_rstc(void)
 
 	of_id = of_match_node(rstc_ids, np);
 	if (!of_id)
-		panic("AT91: rtsc no restart function availlable\n");
+		panic("AT91: rtsc no restart function available\n");
 
 	arm_pm_restart = of_id->data;
 



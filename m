Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbaKTPMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:12:42 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:52827 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454AbaKTPMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:12:38 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-2e-546e04e4f5c1
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>, Kukjin Kim <kgene@kernel.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com
Subject: [PATCH 4/4] ARM: EXYNOS: cpuidle: allow driver usage on Exynos3250 SoC
Date: Thu, 20 Nov 2014 16:11:49 +0100
Message-id: <1416496309-27602-5-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1416496309-27602-1-git-send-email-b.zolnierkie@samsung.com>
References: <1416496309-27602-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t9jQd0nLHkhBpM+yFpsnLGe1WLeZ1mL
	3gVX2Sz6H79mtjjb9IbdYtPja6wWl3fNYbP43HuE0WLG+X1MFqt2/WF04PLYOesuu8emVZ1s
	Hneu7WHz2Lyk3qNvyypGj8+b5ALYorhsUlJzMstSi/TtErgyvl6fylawnb3iwtUDjA2MG9m6
	GDk5JARMJG4v3s4EYYtJXLi3HijOxSEkMJ1RovPYdSini0li8ZlZjCBVbAJWEhPbV4HZIgKu
	EnOuTGIEKWIWWMgkMevtE3aQhLCAv8TrP1tYQGwWAVWJjbv3ga3gFfCQeLpwMzvEOkWJ7mcT
	gDZwcHAKeErc3pQDEhYCKnnetIRxAiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjB
	ofdMegfjqgaLQ4wCHIxKPLwJFrkhQqyJZcWVuYcYJTiYlUR4F74HCvGmJFZWpRblxxeV5qQW
	H2KU5mBREue9cRMoJZCeWJKanZpakFoEk2Xi4JRqYFQsKXHteMQZzK6pZy/Bb+I2zXL/pwtF
	aQfPPSub/Mlj4a8lCQdWyZ5ISzhodHev768lB75dXBZ77KLaXcl9L2T1Mo/IPQj7Me/ok5bk
	g8b/Tx0U12rcsbykS/3nbwUf1gkvFvenfpjStLLZaqFczvIPGkofv3iknm89kafQKNNjeb00
	yXKu92slluKMREMt5qLiRAB5SMnxOQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register cpuidle platform device on Exynos3250 SoC allowing EXYNOS
cpuidle driver usage on this SoC.

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/exynos.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 847cd0a..6efdbbe 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -297,6 +297,7 @@ static void __init exynos_dt_machine_init(void)
 	    of_machine_is_compatible("samsung,exynos4212") ||
 	    (of_machine_is_compatible("samsung,exynos4412") &&
 	     of_machine_is_compatible("samsung,trats2")) ||
+	    of_machine_is_compatible("samsung,exynos3250") ||
 	    of_machine_is_compatible("samsung,exynos5250"))
 		platform_device_register(&exynos_cpuidle);
 
-- 
1.8.2.3


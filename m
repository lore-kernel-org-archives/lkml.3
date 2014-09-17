Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaIQDHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 23:07:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35654 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaIQDHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 23:07:51 -0400
X-AuditID: cbfee68d-f79c46d000000b84-6f-5418fb05686e
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [RESEND PATCH] arm: exynos: Allow rtc alarm and tick wakeup irq for
 exynos3250.
Date: Wed, 17 Sep 2014 12:07:42 +0900
Message-id: <1410923262-4771-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsWyRsSkRJf1t0SIweQn/BadZ58wW/QuuMpm
	senxNVaLy7vmsFnMOL+PyYHVY/OSeo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DKuPByMkvB
	M86Kzzs7mBoY/7B3MXJySAiYSJzbNRnKFpO4cG89WxcjF4eQwFJGibO7frDCFbXPY4dILGKU
	uHC9lRXCaWOSOLVtNgtIFZuAjsT/fTfBRokIZEvM39sNZjMLOEpsXP8fzBYWiJJ4//IY2FQW
	AVWJDTOfMILYvALuEv+2vwWq4QDapiAxZ5INyHwJgftsEi1H/kDVC0h8m3yIBaJGVmLTAWaI
	4yQlDq64wTKBUXABI8MqRtHUguSC4qT0IkO94sTc4tK8dL3k/NxNjMBgPP3vWe8OxtsHrA8x
	CnAwKvHwbrgsESLEmlhWXJl7iNEUaMNEZinR5HxgyOeVxBsamxlZmJqYGhuZW5opifMqSv0M
	FhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC4LTpdQ1P4jaTzmypVEQ6Wa3UPA9V8N0ru1Ijp
	Ksop2Tf3FzsvI9+Ryp/RC868X1l9551L7SHTvl2PXiusY+frqv8hmeOS9FE09meI5Mq17SE7
	+0M2vxJzido/P/rg5Znz5s9+pi7cWr2HSz7q/BsfnXThuofLLGITutw3eRmLJlmp8SjtNlBi
	Kc5INNRiLipOBACVTUeTQQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t9jAV3W3xIhBo3POSw6zz5htuhdcJXN
	YtPja6wWl3fNYbOYcX4fkwOrx+Yl9R59W1YxenzeJBfAHNXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjDmHHh5WSWgmecFZ93djA1MP5h72Lk5JAQMJE41z4PyhaTuHBvPVsX
	IxeHkMAiRokL11tZIZw2JolT22azgFSxCehI/N93E6xDRCBbYv7ebjCbWcBRYuP6/2C2sECU
	xPuXx1hBbBYBVYkNM58wgti8Au4S/7a/BarhANqmIDFnks0ERu4FjAyrGEVTC5ILipPScw31
	ihNzi0vz0vWS83M3MYJD/ZnUDsaVDRaHGAU4GJV4eDdclggRYk0sK67MPcQowcGsJMIrcg8o
	xJuSWFmVWpQfX1Sak1p8iNEUaPlEZinR5HxgHOaVxBsam5gZWRqZG1oYGZsrifMeaLUOFBJI
	TyxJzU5NLUgtgulj4uCUamA8FMvoc9WeYZbb+hSj3f82yG9zP+Yi/efu1umLqowy5jo883xQ
	P2PzlxzjZNOnm71fL9BeFC8Zw/e0yzkxTlTsx9E1oi/EN5mp/Y2N3b3+kNe5yzF3z397ekb6
	2t8rSXf7lgrpW7/l4oxq7vBaVLPTbaWn0PLLdesm3DPdeexrupPJ1mf/TZtslViKMxINtZiL
	ihMBe/nVrIsCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add rtc alarm and tick irq to wakeup sources in exynos3250.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Acked-by : Chanwoo choi <cw00.choi@samsung.com>
---
 arch/arm/mach-exynos/pm.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index fa7218a..d78dcf9 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -66,6 +66,12 @@ static struct sleep_save exynos_core_save[] = {
 
 static u32 exynos_irqwake_intmask = 0xffffffff;
 
+static const struct exynos_wkup_irq exynos3250_wkup_irq[] = {
+	{ 105, BIT(1) }, /* RTC alarm */
+	{ 106, BIT(2) }, /* RTC tick */
+	{ /* sentinel */ },
+};
+
 static const struct exynos_wkup_irq exynos4_wkup_irq[] = {
 	{ 76, BIT(1) }, /* RTC alarm */
 	{ 77, BIT(2) }, /* RTC tick */
@@ -81,9 +87,10 @@ static const struct exynos_wkup_irq exynos5250_wkup_irq[] = {
 static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
 {
 	const struct exynos_wkup_irq *wkup_irq;
-
 	if (soc_is_exynos5250())
 		wkup_irq = exynos5250_wkup_irq;
+	else if (soc_is_exynos3250())
+		wkup_irq = exynos3250_wkup_irq;
 	else
 		wkup_irq = exynos4_wkup_irq;
 
-- 
1.7.9.5


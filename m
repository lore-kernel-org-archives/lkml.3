Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933808AbaHZFZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 01:25:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53062 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaHZFZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 01:25:44 -0400
X-AuditID: cbfee68f-f797f6d000001173-29-53fc1a5646e9
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: t.figa@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH] arm: exynos: Allow rtc alarm and tick wakeup irq for
 exynos3250.
Date: Tue, 26 Aug 2014 14:25:24 +0900
Message-id: <1409030724-21103-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsWyRsSkWDdM6k+wwZ99uhbXvzxnteg8+4TZ
	YtPja6wWl3fNYbOYcX4fk8X6Ga9ZHNg8Ni+p9+jbsorR4/MmuQDmKC6blNSczLLUIn27BK6M
	Cy8nsxQ846z4vLODqYHxD3sXIyeHhICJxM/N+5khbDGJC/fWs3UxcnEICSxllLh7voUJpmjj
	/0tMEIlFjBLHe14yQjhtTBIdszrYQKrYBHQk/u+7CTZWRCBbYv7ebjCbWSBcYsvlu2A1wgLB
	Eiee3WAFsVkEVCV6jv5nBLF5BTwk1izZyNLFyAG0TUFiziQbkPkSAs/ZJDbc+8sOUS8g8W3y
	IagaWYlNB6CulpQ4uOIGywRGwQWMDKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxAsPy9L9n
	/TsY7x6wPsQowMGoxMN7M/53sBBrYllxZe4hRlOgDROZpUST84HBn1cSb2hsZmRhamJqbGRu
	aaYkzrtQ6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsZ5vGrFb+Z4rHv93en9ukV/GBML
	hTzt1lv++fiB8TTblN1pv/Z3OPw/yzift+jll+702DN+D0rcF15MWxj4wLnpw7/Q2HD3L2ut
	ltWZc6UsrzBP5y6doHNFgqni8dcPTtfm9i5/cySnvJ/JSMvB8d6UZZJ5NhF1BYzMvRtXbph9
	f8ZXFf/SGclKLMUZiYZazEXFiQBJExBJRgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t9jAd0wqT/BBp3nVSyuf3nOatF59gmz
	xabH11gtLu+aw2Yx4/w+Jov1M16zOLB5bF5S79G3ZRWjx+dNcgHMUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAe5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhDWMGRdeTmYpeMZZ8XlnB1MD4x/2LkZODgkBE4mN/y8xQdhi
	EhfurWfrYuTiEBJYxChxvOclI4TTxiTRMauDDaSKTUBH4v++m2DdIgLZEvP3doPZzALhElsu
	3wWrERYIljjx7AYriM0ioCrRc/Q/I4jNK+AhsWbJRpYuRg6gbQoScybZTGDkXsDIsIpRNLUg
	uaA4KT3XUK84Mbe4NC9dLzk/dxMjOOifSe1gXNlgcYhRgINRiYf3RvzvYCHWxLLiytxDjBIc
	zEoivAwPgUK8KYmVValF+fFFpTmpxYcYTYGWT2SWEk3OB0ZkXkm8obGJmZGlkbmhhZGxuZI4
	74FW60AhgfTEktTs1NSC1CKYPiYOTqkGRr167Ul7+MttZFyy7m7dxCNsscd939zKWuv6U/tO
	B59VPn2C8bh9UWjIhVXrzzim+cw4XDhrW+ezDcf25QpO/FSUuWzHWanTspHnCvMb2jdklMR2
	Tlyjdcrmbs/7l7Ls+/StxFNTXlS8uCf0RKnnXjJ7hl9y7OPLyYqTf76xNti0b1JqhNL1TiWW
	4oxEQy3mouJEANwFwzuQAgAA
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


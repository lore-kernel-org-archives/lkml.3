Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbaKTFsF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 00:48:05 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:53587 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbaKTFsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 00:48:03 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-b6-546d8083bd98
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        pankaj.dubey@samsung.com,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH v3 3/5] driver: soc: exynos-pmu: Add an API to be called after
 wakeup
Date: Thu, 20 Nov 2014 11:09:26 +0530
Message-id: <1416461968-2057-4-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416461968-2057-1-git-send-email-amit.daniel@samsung.com>
References: <1416461968-2057-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWyRsSkVrelITfEYPd0NouGqyEWvQuuslls
	enyN1eLyrjlsFjPO72OyWLT1C7sDm8fmJfUefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlTH9
	yB7WgpW8FTe7H7A1MK7g7mLk5JAQMJF4tWkDO4QtJnHh3nq2LkYuDiGBpYwS09puMsEUTX9w
	jQXEFhJYxCgxeysLRNEEJonORUfAutkEjCV+7twPZHNwiAh4Syy/pghSwyzQxChxbt5lVpAa
	YYFwiV9du8HqWQRUJb7//Aa2gFfATeL777ssIL0SAgoScybZgIQ5Bdwlnn/awwix103i1IrF
	TCAzJQSa2SU+3LzIBjFHQOLb5ENQvbISmw4wQ9wsKXFwxQ2WCYzCCxgZVjGKphYkFxQnpReZ
	6BUn5haX5qXrJefnbmIEhvDpf88m7GC8d8D6EKMAB6MSD2+CRW6IEGtiWXFl7iFGU6ANE5ml
	RJPzgZGSVxJvaGxmZGFqYmpsZG5ppiTO+1rqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkG
	xhhpO3s9u9UrTVZd0b5f06h0INpxWX2dDPNir/zuqPt7Pkl+LbTjsUyUWPZ3tkZHqa14mFgu
	/5vpMw+euvFXJXO/wA4Nxec29lnr91577Ndsr6DnJvHUxe8Nw/2zpkzGXiav+45qFL66/21p
	0/YTC++zC7X1OW67ZFb87H2A18e4lZtuzqnTU2Ipzkg01GIuKk4EABOWgTRcAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jAd3mhtwQg38LrS0aroZY9C64ymax
	6fE1VovLu+awWcw4v4/JYtHWL+wObB6bl9R79G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5K
	Zl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBaJYWyxJxSoFBAYnGxkr4dpgmh
	IW66FjCNEbq+IUFwPUYGaCBhDWPG9CN7WAtW8lbc7H7A1sC4gruLkZNDQsBEYvqDaywQtpjE
	hXvr2UBsIYFFjBKztwLFuYDsCUwSnYuOsIMk2ASMJX7u3A9kc3CICHhLLL+mCFLDLNDEKHFu
	3mVWkBphgXCJX127wepZBFQlvv/8xgRi8wq4SXz/fZcFpFdCQEFiziQbkDCngLvE8097GCH2
	ukmcWrGYaQIj7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwRHyTHoH46oGi0OMAhyM
	Sjy8CRa5IUKsiWXFlbmHGCU4mJVEeD9VAoV4UxIrq1KL8uOLSnNSiw8xmgIdNZFZSjQ5Hxi9
	eSXxhsYm5qbGppYmFiZmlkrivAdbrQOFBNITS1KzU1MLUotg+pg4OKUaGB3TTi5xypJYc733
	ar55kukplzQFvrmCP1XFTupePMJ70drGpezdJaaWBa8ElL5e2rpLOUj81aEkw0DR4LYpBU6v
	9cy+he0R9ptiEnVeYMPl3xcvHjt3S0TRKU9syo9Jtgun83Ebipt2CU9d7fr33U+pU1oywiyK
	K168vLJdaO/pwJunTjOXWimxFGckGmoxFxUnAgABxq9RpgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an API exynos_sys_powerup_conf to be called after system sleep
wakeup. This will useful for exynos7 SoC to perform resume related
initialisations. This is similar to currently existing API
exynos_sys_powerdown_conf.

Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/soc/samsung/exynos-pmu.c       |    9 +++++++++
 include/linux/soc/samsung/exynos-pmu.h |    1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/soc/samsung/exynos-pmu.c b/drivers/soc/samsung/exynos-pmu.c
index aa43e04..f8896bc 100644
--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -29,6 +29,7 @@ struct exynos_pmu_data {
 
 	void (*pmu_init)(void);
 	void (*powerdown_conf)(enum sys_powerdown);
+	void (*powerup_conf)(enum sys_powerdown);
 };
 
 struct exynos_pmu_context {
@@ -637,6 +638,14 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
 	}
 }
 
+void exynos_sys_powerup_conf(enum sys_powerdown mode)
+{
+	const struct exynos_pmu_data *pmu_data = pmu_context->pmu_data;
+
+	if (pmu_data->powerup_conf)
+		pmu_data->powerup_conf(mode);
+}
+
 static void exynos5250_pmu_init(void)
 {
 	unsigned int value;
diff --git a/include/linux/soc/samsung/exynos-pmu.h b/include/linux/soc/samsung/exynos-pmu.h
index a2ab0d5..b497712 100644
--- a/include/linux/soc/samsung/exynos-pmu.h
+++ b/include/linux/soc/samsung/exynos-pmu.h
@@ -20,5 +20,6 @@ enum sys_powerdown {
 };
 
 extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
+extern void exynos_sys_powerup_conf(enum sys_powerdown mode);
 
 #endif /* __EXYNOS_PMU_H */
-- 
1.7.9.5


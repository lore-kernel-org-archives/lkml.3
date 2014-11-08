Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaKHNWw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 08:22:52 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41180 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaKHNWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 08:22:46 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-01-545e19242e56
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, lee.jones@linaro.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH v2 5/6] driver: soc: exynos-pmu: Add an API to be called after
 wakeup
Date: Sat, 08 Nov 2014 18:46:40 +0530
Message-id: <1415452601-13078-6-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1415452601-13078-1-git-send-email-amit.daniel@samsung.com>
References: <1415452601-13078-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWyRsSkWldFMi7EYO9WM4uGqyEWvQuuslnc
	/3qU0WLT42usFpd3zWGzmHF+H5PF4TftrA7sHneu7WHz2Lyk3qNvyypGj8+b5AJYorhsUlJz
	MstSi/TtErgy7v//z1jwhKdib8t1tgbG91xdjJwcEgImEiuetTBD2GISF+6tZ+ti5OIQEljK
	KPH54n0WmKLOpz1MEInpjBJXPq1hhnAmMEkc3XsXrJ1NwFji58797F2MHBwiAt4Sy68pgtQw
	C8xglOjpbmUEqREWCJfo3rmBCcRmEVCV+LFsERtIPa+Au0TDn0QQU0JAQWLOJBuQCk4BD4kF
	e7vBbhACqtj08B8jyEgJgcnsEiu/dLBBjBGQ+Db5EAtEr6zEpgNQz0hKHFxxg2UCo/ACRoZV
	jKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGIFhffrfswk7GO8dsD7EKMDBqMTDe6MlNkSINbGs
	uDL3EKMp0IaJzFKiyfnA6MkriTc0NjOyMDUxNTYytzRTEud9LfUzWEggPbEkNTs1tSC1KL6o
	NCe1+BAjEwenVANjwIF7z/LmL3a4uKvk4t3QyKrg/J43wppCc66mlrGxzDXub3o+ba5e/a+L
	d9jmtB62Nyjf7X1QYemNrNVd740jdwgL5Xwyvr+jf/XE8Nnf1daG9pS+cudd537xeNjh6H19
	xWv5715MMVG77mssx8Nxh6OxJ97/eIyqTuBq3TTu2mm7Ewq3PHdSYinOSDTUYi4qTgQAd67G
	SGYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsVy+t9jQV0VybgQg70vdC0aroZY9C64ymZx
	/+tRRotNj6+xWlzeNYfNYsb5fUwWh9+0szqwe9y5tofNY/OSeo++LasYPT5vkgtgiWpgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOkBJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmHH//3/Ggic8FXtbrrM1ML7n6mLk5JAQ
	MJHofNrDBGGLSVy4t56ti5GLQ0hgOqPElU9rmCGcCUwSR/feZQapYhMwlvi5cz97FyMHh4iA
	t8Tya4ogNcwCMxglerpbGUFqhAXCJbp3bgCbyiKgKvFj2SI2kHpeAXeJhj+JIKaEgILEnEk2
	IBWcAh4SC/Z2s4DYQkAVmx7+Y5zAyLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDU
	PJPewbiqweIQowAHoxIP742W2BAh1sSy4srcQ4wSHMxKIry954FCvCmJlVWpRfnxRaU5qcWH
	GE2BbprILCWanA+M6LySeENjE3NTY1NLEwsTM0slcd6DrdaBQgLpiSWp2ampBalFMH1MHJxS
	DYw80e8UdL5wzfF513WWi+1JM7d01KR/VovTCiRD1uw0i07Tczw0+Z9L3sld0U2X7nDKGcsI
	PlrCOf/1TYFeCYGgbLc3Zi6fjzY8zDlW2LlVIXrP35O23O57L+9btuDzzKJ6Ia5j/fq6hR+4
	3eYJs934MtFY79GL/58nB/HtjEplctNSZnv1eJ8SS3FGoqEWc1FxIgAGETD+sAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an API exynos_sys_powerup_conf to be called
after system sleep wakeup. This is similar to currently existing API
exynos_sys_powerdown_conf.

Reviewed-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/soc/samsung/exynos-pmu.c       |    9 +++++++++
 include/linux/soc/samsung/exynos-pmu.h |    1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/soc/samsung/exynos-pmu.c b/drivers/soc/samsung/exynos-pmu.c
index 4a5eb50..a73c1ea 100644
--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -34,6 +34,7 @@ struct exynos_pmu_data {
 
 	void (*pmu_init)(void);
 	void (*powerdown_conf)(enum sys_powerdown);
+	void (*powerup_conf)(enum sys_powerdown);
 };
 
 struct exynos_pmu_context {
@@ -430,6 +431,14 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
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
index d2f4083..9a4b833 100644
--- a/include/linux/soc/samsung/exynos-pmu.h
+++ b/include/linux/soc/samsung/exynos-pmu.h
@@ -25,5 +25,6 @@ struct pmu_dev_client_data {
 };
 
 extern void exynos_sys_powerdown_conf(enum sys_powerdown mode);
+extern void exynos_sys_powerup_conf(enum sys_powerdown mode);
 
 #endif /* __EXYNOS_PMU_H */
-- 
1.7.9.5


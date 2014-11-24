Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbaKXCMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 21:12:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16495 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaKXCMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 21:12:47 -0500
X-AuditID: cbfee68d-f79296d000004278-d4-5472941c6f3e
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH v4 3/5] driver: soc: exynos-pmu: Add an API to be called after
 wakeup
Date: Mon, 24 Nov 2014 07:36:13 +0530
Message-id: <1416794775-1605-4-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416794775-1605-1-git-send-email-amit.daniel@samsung.com>
References: <1416794775-1605-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWyRsSkTldmSlGIwdSLphYNV0MsehdcZbPY
	9Pgaq8XlXXPYLGac38dkcfsyrwObR0tzD5vH5iX1Hn1bVjF6fN4kF8ASxWWTkpqTWZZapG+X
	wJWx48sxpoKVvBWLTm9gbmBcwd3FyMkhIWAi8fV6LzOELSZx4d56ti5GLg4hgaWMEremvmCD
	Kfq5fh8rRGI6o8Tb211QzgQmiQ0n/zOCVLEJGEv83LmfvYuRg0NEwFti+TVFkBpmgQZGie0f
	5oNNEhYIl9h3/wBYDYuAqsTeC5kgYV4BN4mvNx4wgoQlBBQk5kyyAQlzCrhLNB+dDzZdCKhk
	z/cOJpCREgLd7BLrLm5lB0mwCAhIfJt8iAWiV1Zi0wGoZyQlDq64wTKBUXgBI8MqRtHUguSC
	4qT0IkO94sTc4tK8dL3k/NxNjMBQPv3vWe8OxtsHrA8xCnAwKvHwfmgtDBFiTSwrrsw9xGgK
	tGEis5Rocj4wYvJK4g2NzYwsTE1MjY3MLc2UxHkVpX4GCwmkJ5akZqemFqQWxReV5qQWH2Jk
	4uCUamDcdX3LHfNthSHWzMcyn3WsX8FeutV5yeOFZ3LU/66xzOjbc2X322871j10le44vWqz
	zMQpFt/Vpz+41r6hije388h3J5My4wi7O6buE+sunVmyTqzPrrr2kn7jmo9a89ZsK0pNbpw9
	zyTceM7TLKk5LB83dpdNnpXbKv9ZwjvslIrT5cjGwApjJZbijERDLeai4kQA6FB+32ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t9jQV2ZKUUhBkfn6Vo0XA2x6F1wlc1i
	0+NrrBaXd81hs5hxfh+Txe3LvA5sHi3NPWwem5fUe/RtWcXo8XmTXABLVAOjTUZqYkpqkUJq
	XnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QaiWFssScUqBQQGJxsZK+
	HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxo4vx5gKVvJWLDq9gbmBcQV3FyMnh4SAicTP9ftY
	IWwxiQv31rN1MXJxCAlMZ5R4e7uLFcKZwCSx4eR/RpAqNgFjiZ8797N3MXJwiAh4Syy/pghS
	wyzQwCix/cN8NpAaYYFwiX33D4DVsAioSuy9kAkS5hVwk/h64wEjSFhCQEFiziQbkDCngLtE
	89H5YNOFgEr2fO9gmsDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcKQ8k9rBuLLB
	4hCjAAejEg+vR0dhiBBrYllxZe4hRgkOZiUR3rP/gEK8KYmVValF+fFFpTmpxYcYTYFumsgs
	JZqcD4zivJJ4Q2MTc1NjU0sTCxMzSyVx3hs3c0OEBNITS1KzU1MLUotg+pg4OKUaGBfVVGiX
	PTq4em7Ijv9eb7R4mCVO1iYVxGg0tq67cen4Re/N8ZZ/D9Tu5zhzbWqezyz3lKffl/7qSlc4
	GWG38ITULZPdizXnHPu0Q6oxSd6y7t+M4xcSn29eliwvHeTqGu8jVvTDZfqBK3GJO/+n/WNx
	2XvSuOHTfre0PwHGVXcydVxvHxc+Wa3EUpyRaKjFXFScCAAU2RefqgIAAA==
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
index 2965c3b..f7ae8a0 100644
--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -32,6 +32,7 @@ struct exynos_pmu_data {
 
 	void (*pmu_init)(void);
 	void (*powerdown_conf)(enum sys_powerdown);
+	void (*powerup_conf)(enum sys_powerdown);
 };
 
 struct exynos_pmu_context {
@@ -640,6 +641,14 @@ void exynos_sys_powerdown_conf(enum sys_powerdown mode)
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


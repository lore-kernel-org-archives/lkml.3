Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab3IKLQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:16:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17962 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab3IKLO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:14:56 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-66-523050af1070
From: Yadwinder Singh Brar <yadi.brar@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [RFC 4/4] arm: exynos5: Register static platform device for ASV.
Date: Wed, 11 Sep 2013 16:44:08 +0530
Message-id: <1378898048-25205-5-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-reply-to: <1378898048-25205-1-git-send-email-yadi.brar@samsung.com>
References: <1378898048-25205-1-git-send-email-yadi.brar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42JZI2JSpbs+wCDI4PdnM4veBVfZLDY9vsZq
	cXnXHDaLGef3MVncblzBZtG/sJfJYv2M1ywWx2YsYbTY+NXDYs70d0wOXB53ru1h89i8pN6j
	b8sqRo9Hi1sYPT5vkgtgjeKySUnNySxLLdK3S+DKaDy4lrngJkfFpEmBDYyL2LsYOTkkBEwk
	fv5axAhhi0lcuLeerYuRi0NIYCmjxLPtZ1lhirZev88CkZjOKHFs2Tp2CKeNSWLJyX9ALRwc
	bAJGEq+O2YE0iAgoSGzufcYKUsMs8JxJ4uueuWwgCWEBT4nXr+8zgdgsAqoSj193gq3mFXCV
	+L52H9Q2BYnWZYfYQWZyCrhJrJliDxIWAiq5vfkUM8hMCYFt7BIrJ3WxQcwRkPg2+RALSL2E
	gKzEpgPMEGMkJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYzA8D/979nE
	HYz3D1gfYkwGGjeRWUo0OR8YP3kl8YbGZkYWpiamxkbmlmakCSuJ86q3WAcKCaQnlqRmp6YW
	pBbFF5XmpBYfYmTi4JRqYMzM2tnQ3vJEZl3MP5Gbl51mPrktaHH5t/Sxbu6Cgor/R+K9vKXL
	yn66ZFtJhB3xeVR9pPjgmT8L/2hxSZdd+KHr8DL12vE6pUWzLhTnzF95vPraq5jt+op/t+2d
	9tnq26dcb7PH5gncf4qYF6jMvydoGjP1iUKmD7+La/bFhqiw2u0xhT9uKCqxFGckGmoxFxUn
	AgBKjAbIlQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t9jQd31AQZBBp/26Fn0LrjKZrHp8TVW
	i8u75rBZzDi/j8niduMKNov+hb1MFutnvGaxODZjCaPFxq8eFnOmv2Ny4PK4c20Pm8fmJfUe
	fVtWMXo8WtzC6PF5k1wAa1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJe
	Ym6qrZKLT4CuW2YO0FFKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxozG
	g2uZC25yVEyaFNjAuIi9i5GTQ0LARGLr9fssELaYxIV769m6GLk4hASmM0ocW7aOHcJpY5JY
	cvIfUIaDg03ASOLVMTuQBhEBBYnNvc9YQWqYBZ4zSXzdM5cNJCEs4Cnx+vV9JhCbRUBV4vHr
	TkYQm1fAVeL72n2sENsUJFqXHWIHmckp4CaxZoo9SFgIqOT25lPMExh5FzAyrGIUTS1ILihO
	Ss810itOzC0uzUvXS87P3cQIjq5n0jsYVzVYHGIU4GBU4uG9IacfJMSaWFZcmXuIUYKDWUmE
	94GpQZAQb0piZVVqUX58UWlOavEhxmSgoyYyS4km5wMjP68k3tDYxNzU2NTSxMLEzJI0YSVx
	3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGNU+nF642vZJMM+vaY6rTOsPWpt/jIjWnOUUelj/
	5ySJcBXRu3x7938vX3TbhtXu8Gq5WyvfnvVbqXLpqEzS1vLaM9NSXD+V3WNWNv19uYqh2lg9
	M4XDb7JgqVFPwiXPn6Lr3YO5Td5UXJ4oM7H1+rprN9f/f/Y+Wrms68HHjJ02ry6Xcm4xfqvE
	UpyRaKjFXFScCAAlVoxs8gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since ASV is not a hardware controller so we cann't add device tree node for
it. This patch registers a static platform device exynos ASV.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 arch/arm/mach-exynos/mach-exynos5-dt.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
index f874b77..5ce58e1 100644
--- a/arch/arm/mach-exynos/mach-exynos5-dt.c
+++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
@@ -28,6 +28,7 @@ static void __init exynos5_dt_machine_init(void)
 	struct device_node *i2c_np;
 	const char *i2c_compat = "samsung,s3c2440-i2c";
 	unsigned int tmp;
+	struct platform_device_info devinfo = { .name = "exynos-asv", };
 
 	/*
 	 * Exynos5's legacy i2c controller and new high speed i2c
@@ -48,6 +49,8 @@ static void __init exynos5_dt_machine_init(void)
 	}
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
+
+	platform_device_register_full(&devinfo);
 }
 
 static char const *exynos5_dt_compat[] __initdata = {
-- 
1.7.0.4


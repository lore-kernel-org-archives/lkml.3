Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab3DDIZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 04:25:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:8230 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab3DDIZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 04:25:28 -0400
X-AuditID: cbfee690-b7f656d0000007e3-e0-515d38f65913
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Kukjin'" <kgene.kim@samsung.com>,
        "'Rafael J. Wysocki'" <rjw@sisk.pl>
References: 
In-reply-to: 
Subject: [PATCH 3.8-stable] cpufreq: exynos: Get booting freq value in
 exynos_cpufreq_init
Date: Thu, 04 Apr 2013 17:25:22 +0900
Message-id: <000001ce310d$f5b615d0$e1224170$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAEJzDJA=
Content-language: ko
x-cr-hashedpuzzle: l/c= Fke3 HCtM JX1/ LRIM Nqe4 O8KT Sjdw UVyx Uvw+ XhZ6 fJ3J
 fjU1 lUnB xfpS
 xi6X;5;agBoAGIAaQByAGQALgBjAGgAbwBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAawBnAGUAbgBlAC4AawBpAG0AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgBqAHcAQABzAGkAcwBrAC4AcABsADsAcwB0AGEAYgBsAGUAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{22DE1EB9-94FC-48AC-8EA1-88890CE89982};agBoAGIAaQByAGQALgBjAGgAbwBpAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Thu,
 04 Apr 2013 08:25:14
 GMT;WwBQAEEAVABDAEgAIAAzAC4AOAAtAHMAdABhAGIAbABlAF0AIABjAHAAdQBmAHIAZQBxADoAIABlAHgAeQBuAG8AcwA6ACAARwBlAHQAIABiAG8AbwB0AGkAbgBnACAAZgByAGUAcQAgAHYAYQBsAHUAZQAgAGkAbgAgAGUAeAB5AG4AbwBzAF8AYwBwAHUAZgByAGUAcQBfAGkAbgBpAHQA
x-cr-puzzleid: {22DE1EB9-94FC-48AC-8EA1-88890CE89982}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zI91vFrGBBjvuW1gsaea26F1wlc3i
	8q45bBb9C3uZLBZsfMTowOrRt2UVo8ejxS2MHp83yQUwR3HZpKTmZJalFunbJXBl3Nh+k6ng
	FFfF/dt72RsYf3F0MXJySAiYSFzePIUVwhaTuHBvPVsXIxeHkMAyRokbV14xwRSd2PMBrEhI
	YBGjxLR+YYiiv4wS8za9ZwFJsAnoShxbvwWsSETAW+LUlF/MXYwcHMwCyRI7WnlBTCEBbonV
	zUEgFZwCPBLr/nQyg9jCAjESTf9ngXWyCKhKtP3/xQRSzitgJ/HgqhhImFdAUOLH5Htgi5gF
	tCTW7zzOBGHLS2xe8xZskYSAusSjv7oQ+60kTq++ywhRIiKx78U7RpCDJQT+sEoc+nSADeIr
	U4lJO7+wQyQ+skvcXrmYBeIGAYlvkw+xQAyVldh0gBmiXlLi4IobLBMYpWYhOWkWkpNmITlp
	FpLdCxhZVjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmKExO+EHYz3DlgfYkwGWj+RWUo0OR8Y
	/3kl8YbGZkYWpiamxkbmlmakCSuJ86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYJy3
	zjmq+uCqI7XhCot//bna//GYTqtLtVzMSzF7jtqoe5MP2TwPnbCvfq7eyhVhfkrLu80Vp3jw
	vwpmXmIcdemIyD7urLdzTy5bKfcmKJPZ79grhm6tZyW2lYu/Ky01zYmfe2fTmjazkrCXHrNb
	J728o/5g0aKbGgUa71Q/cJz5+P+41bZr9eVKLMUZiYZazEXFiQAshexV9QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAd1vFrGBBk9PGlssaea26F1wlc3i
	8q45bBb9C3uZLBZsfMTowOrRt2UVo8ejxS2MHp83yQUwRzUw2mSkJqakFimk5iXnp2Tmpdsq
	eQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYArVRSKEvMKQUKBSQWFyvp22GaEBripmsB
	0xih6xsSBNdjZIAGEtYxZtzYfpOp4BRXxf3be9kbGH9xdDFyckgImEic2POBFcIWk7hwbz0b
	iC0ksIhRYlq/cBcjF5D9l1Fi3qb3LCAJNgFdiWPrt4A1iAh4S5ya8ou5i5GDg1kgWWJHKy+I
	KSTALbG6OQikglOAR2Ldn05mEFtYIEai6f8ssE4WAVWJtv+/mEDKeQXsJB5cFQMJ8woISvyY
	fA9sEbOAlsT6nceZIGx5ic1r3oItkhBQl3j0Vxdiv5XE6dV3GSFKRCT2vXjHCHKwhMAfVolD
	nw6wQXxlKjFp5xf2CYwis5CsmIVkxSwkK2YhmbWAkWUVo2hqQXJBcVJ6rqFecWJucWleul5y
	fu4mRnByeCa1g3Flg8UhRgEORiUe3pX+MYFCrIllxZW5hxglOJiVRHjdeWIDhXhTEiurUovy
	44tKc1KLDzEmAwNgIrOUaHI+MHHllcQbGpuYGVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1
	tSC1CGYLEwenVANj5NVb6zXPP9uYMoutWf38fr+ADx8v37ptesu1JpqlKkTgWUXfwrt9644+
	+LbwrWxvatizr7pSsUvP31ra8myDjZFGxLKd1o4fzJV8VljI3NJcu1pA+vifEl232MVvZp4+
	ce3E+kdPboQtjL6zoPTD9z2HZ6+ZtfFg54vAPz9Y16UtOnvIyqTmtJUSS3FGoqEWc1FxIgB4
	YJ9fUgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.8-stable tree, should we apply
it?

------------------

From: "Jonghwan Choi <jhbird.choi@samsung.com>"

Boot_freq is for saving booting freq. But exynos_cpufreq_cpu_init
is called in hotplug. If boot_freq is existed in exynos_cpufreq_cpu_init,
boot_freq could be changed.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/cpufreq/exynos-cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c
b/drivers/cpufreq/exynos-cpufreq.c
index 7012ea8..41fc550 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -222,8 +222,6 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy
*policy)
 
 	cpufreq_frequency_table_get_attr(exynos_info->freq_table,
policy->cpu);
 
-	locking_frequency = exynos_getspeed(0);
-
 	/* set the transition latency value */
 	policy->cpuinfo.transition_latency = 100000;
 
@@ -288,6 +286,8 @@ static int __init exynos_cpufreq_init(void)
 		goto err_vdd_arm;
 	}
 
+	locking_frequency = exynos_getspeed(0);
+
 	register_pm_notifier(&exynos_cpufreq_nb);
 
 	if (cpufreq_register_driver(&exynos_driver)) {
-- 
1.7.9.5


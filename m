Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab3CKCOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 22:14:23 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28238 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab3CKCOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 22:14:20 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-29-513d3df94129
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <005301ce1dfd$f306bec0$d9143c40$%han@samsung.com>
In-reply-to: <005301ce1dfd$f306bec0$d9143c40$%han@samsung.com>
Subject: [PATCH 2/3] pwm: pwm-tipwmss: add CONFIG_PM_SLEEP to suspend/resume
 functions
Date: Mon, 11 Mar 2013 11:14:16 +0900
Message-id: <005401ce1dfe$21fef9e0$65fceda0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4d/fLoREAEAFdzR4uo7XL58BGkQQAAB7Cg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zY92ftraBBnNm8Vlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MbXtnMBY856j43f2CrYFxJ3sXIyeHhICJxIJP96FsMYkL99az
	gdhCAssYJY53G8PUrNm0CqiGCyi+iFFiz/+tzBDObCaJ8wsPM4NUsQmoSXz5chhskoiAucSS
	RXuB4hwczAIuEkeniUAMtZVYeO4yWDmngJ3Ep1krGEFsYYEIicmXbrKDlLMIqEosfp8JEuYF
	Kj9zaSE7hC0o8WPyPRYQm1lAS2LztiZWCFteYvOat2CbJATUJR791YU4wEji+vQNUOUiEvte
	vGMEuVhCYBG7xPkPp8HWsggISHybfIgFoldWYtMBZoh3JSUOrrjBMoFRYhaSzbOQbJ6FZPMs
	JCsWMLKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAiJqok7GO8fsD7EmAy0fiKzlGhyPjAq
	80riDY3NjCxMTUyNjcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAuOS6
	2boKh9QF2wyZAwya/mge47W9sUHBwVLvoJ51t/w31+5zlnv8kuR3TWLx2Fh3OWRV29G9gmtV
	+i/EGF9j7Ha/G22/4Lhj6mReEVlpB/cros8FJ5zsfxnx43Gdrt5+/40fN/Fd/dPyNOSglUmR
	h0C7adS6+w+OJ5zQ3CJ8ISPj1iejh3vmKLEUZyQaajEXFScCAHFDclbAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO5PW9tAgyUTuS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxra9MxgLnnNU/O5+wdbA
	uJO9i5GTQ0LARGLNplVQtpjEhXvr2boYuTiEBBYxSuz5v5UZwpnNJHF+4WFmkCo2ATWJL18O
	g3WICJhLLFm0FyjOwcEs4CJxdJoISFhIwFZi4bnLYOWcAnYSn2atYASxhQUiJCZfuskOUs4i
	oCqx+H0mSJgXqPzMpYXsELagxI/J91hAbGYBLYnN25pYIWx5ic1r3oJtkhBQl3j0VxfiACOJ
	69M3QJWLSOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vO
	z93ECI7aZ9I7GFc1WBxiFOBgVOLhnaBjGyjEmlhWXJl7iFGCg1lJhHflJptAId6UxMqq1KL8
	+KLSnNTiQ4zJQH9OZJYSTc4HJpS8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqem
	FqQWwWxh4uCUamBUnC7iJsQStMPmM8unmw5zjwVGWfs+SWd6VffpoN/06veOC/h3Kki/Cpra
	fndO4oPmd7tu5UTzJNYE6Vc3RVY+M/P/H14n2TpHtZXtVzufW92FRx8rNmr8/SOgOL9sHZMx
	A59pwpItr9OFrJidwt10n+V9K1FvO/rWfXdk023Ds3aL1hWceaPEUpyRaKjFXFScCACyv9DT
	HgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds CONFIG_PM_SLEEP to suspend/resume functions to fix
the following build warning when CONFIG_PM_SLEEP is not selected.

drivers/pwm/pwm-tipwmss.c:104:12: warning: 'pwmss_suspend' defined but not used [-Wunused-function]
drivers/pwm/pwm-tipwmss.c:113:12: warning: 'pwmss_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pwm/pwm-tipwmss.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pwm/pwm-tipwmss.c b/drivers/pwm/pwm-tipwmss.c
index 17cbc59..c9c3d3a 100644
--- a/drivers/pwm/pwm-tipwmss.c
+++ b/drivers/pwm/pwm-tipwmss.c
@@ -101,6 +101,7 @@ static int pwmss_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int pwmss_suspend(struct device *dev)
 {
 	struct pwmss_info *info = dev_get_drvdata(dev);
@@ -118,6 +119,7 @@ static int pwmss_resume(struct device *dev)
 	writew(info->pwmss_clkconfig, info->mmio_base + PWMSS_CLKCONFIG);
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(pwmss_pm_ops, pwmss_suspend, pwmss_resume);
 
-- 
1.7.2.5



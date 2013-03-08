Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666Ab3CHEDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 23:03:37 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:50101 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552Ab3CHEDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:03:34 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-5e-51396314246e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] pwm: samsung: convert s3c_pwm to dev_pm_ops
Date: Fri, 08 Mar 2013 13:03:31 +0900
Message-id: <000201ce1bb1$e5df6fb0$b19e4f10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4bseXIs5BEuT8ZStWurBAAwl0nxQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t8zA12RZMtAg/99PBaXF15itbi8aw6b
	xe6VS1gcmD36plxl8+jbsorR4/MmuQDmKC6blNSczLLUIn27BK6MVZNPMxfM5a/4vXszawPj
	Xp4uRk4OCQETiQkXG5khbDGJC/fWs3UxcnEICSxjlHiz+xErTNGfr5uhEtMZJVqermSEcH4x
	ShxrvAxWxSagJvHly2F2EFtEwFxiyaK9QGM5OJgFXCSOThMBCQsL2EhM3LqYCcRmEVCVWHfy
	JVgJr4CtxMcpsSBhXgFBiR+T77GA2MwCWhLrdx5ngrDlJTaveQtWLiGgLvHory7EIj2J7dOe
	sEOUiEjse/EO7DIJgVXsEtdvfWaGWCUg8W3yIRaIXlmJTQeg/pWUOLjiBssERrFZSDbPQrJ5
	FpLNs5CsWMDIsopRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjJJ4m7mC8f8D6EGMy0PqJzFKi
	yfnAeMwriTc0NjYxMzE1Mbc0NTclTVhJnFf+kkygkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6p
	BsY0dft4l5cpxtOX96ac4XBJ52i68O3Ogn6vTd6HYtnMvU+oSXA/jG4xcfBbJ3CryGLqZl7H
	N+uDcnIYcxcVT/nB+Sv34bHtr2fG/S5rPB+zUPPqzKvavwy12QtU1t/rZ9V/ZGh45H9VZffm
	M3cMDttp82mcXbX9gG2VzJ+LM+OXir6ou5PwI0uJpTgj0VCLuag4EQAnZPkhvQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xoK5IsmWgwYcGDovLCy+xWlzeNYfN
	YvfKJSwOzB59U66yefRtWcXo8XmTXABzVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGh
	rqGlhbmSQl5ibqqtkotPgK5bZg7QJiWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1G
	BmggYR1jxqrJp5kL5vJX/N69mbWBcS9PFyMnh4SAicSfr5vZIGwxiQv31gPZXBxCAtMZJVqe
	rmSEcH4xShxrvMwKUsUmoCbx5cthdhBbRMBcYsmivcxdjBwczAIuEkeniYCEhQVsJCZuXcwE
	YrMIqEqsO/kSrIRXwFbi45RYkDCvgKDEj8n3WEBsZgEtifU7jzNB2PISm9e8BSuXEFCXePRX
	F2KRnsT2aU/YIUpEJPa9eMc4gVFgFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YW
	l+al6yXn525iBEfrM6kdjCsbLA4xCnAwKvHwVmyyCBRiTSwrrsw9xCjBwawkwvtbxjJQiDcl
	sbIqtSg/vqg0J7X4EGMy0J8TmaVEk/OBiSSvJN7Q2MTMyNLIzMLIxNycNGElcV7GU08ChATS
	E0tSs1NTC1KLYLYwcXBKNTBGzn2ca7ZeISVDcK21c9CmkKk1Dzxt385OV/z6JY3rmp6LWYn+
	3UaT2Wqb7PqeupntudD77sc0zT0aO06X8b52r+mQOX2ax0fvnu/rmKzGEt6f0gr6bzJMRFf+
	FRd139t/cnK1eM090abZ304F7XBm2X5lz+rGyNrCml0veySCzq0pKjKvMFNiKc5INNRiLipO
	BAAC/gH2GgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pwm/pwm-samsung.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
index 5207e6c..a0ece50 100644
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -289,10 +289,10 @@ static int s3c_pwm_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int s3c_pwm_suspend(struct platform_device *pdev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int s3c_pwm_suspend(struct device *dev)
 {
-	struct s3c_chip *s3c = platform_get_drvdata(pdev);
+	struct s3c_chip *s3c = dev_get_drvdata(dev);
 
 	/* No one preserve these values during suspend so reset them
 	 * Otherwise driver leaves PWM unconfigured if same values
@@ -304,9 +304,9 @@ static int s3c_pwm_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int s3c_pwm_resume(struct platform_device *pdev)
+static int s3c_pwm_resume(struct device *dev)
 {
-	struct s3c_chip *s3c = platform_get_drvdata(pdev);
+	struct s3c_chip *s3c = dev_get_drvdata(dev);
 	unsigned long tcon;
 
 	/* Restore invertion */
@@ -316,21 +316,19 @@ static int s3c_pwm_resume(struct platform_device *pdev)
 
 	return 0;
 }
-
-#else
-#define s3c_pwm_suspend NULL
-#define s3c_pwm_resume NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(s3c_pwm_pm_ops, s3c_pwm_suspend,
+			s3c_pwm_resume);
+
 static struct platform_driver s3c_pwm_driver = {
 	.driver		= {
 		.name	= "s3c24xx-pwm",
 		.owner	= THIS_MODULE,
+		.pm	= &s3c_pwm_pm_ops,
 	},
 	.probe		= s3c_pwm_probe,
 	.remove		= s3c_pwm_remove,
-	.suspend	= s3c_pwm_suspend,
-	.resume		= s3c_pwm_resume,
 };
 
 static int __init pwm_init(void)
-- 
1.7.2.5



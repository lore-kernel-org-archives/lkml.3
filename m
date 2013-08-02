Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab3HBFp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 01:45:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22804 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab3HBFp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 01:45:27 -0400
X-AuditID: cbfee691-b7fef6d000002d62-54-51fb47764dda
From: Jingoo Han <jg1.han@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] MFD: ucb1x00-core: add CONFIG_PM_SLEEP to suspend/resume
Date: Fri, 02 Aug 2013 14:45:25 +0900
Message-id: <000501ce8f43$7cc948b0$765bda10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6PQ3bMKMCG/b+nSVqu8o9wIUzTfg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t8zA90y99+BBu9+c1hcXniJ1eL+16OM
	Fpd3zWGz2PzhJZvF6W5WB1aPluYeNo871/awecw7GejRt2UVo8fnTXIBrFFcNimpOZllqUX6
	dglcGSfPL2cseMtZcerDTuYGxo0cXYwcHBICJhLXv7l0MXICmWISF+6tZ+ti5OIQEljGKHF2
	UScTRMJE4mNPLwtEYjqjxPXm3YwQzi9GiT//3jKDVLEJqEl8+XKYHWSqiICXxK07QSBhZoEC
	ib+Hd7CC2MICnhJHFv9gAilhEVCVuPMlESTMK2Ap8XDZVRYIW1Dix+R7LBCtWhLrdx5ngrDl
	JTavgdgkIaAgsePsa0YQW0RAT+Lb+1OsEDUiEvtevAM7TULgELvElWt7wAaxCAhIfJt8iAXi
	YVmJTQeg5khKHFxxg2UCo9gsJKtnIVk9C8nqWUhWLGBkWcUomlqQXFCclF5kqlecmFtcmpeu
	l5yfu4kREnMTdzDeP2B9iDEZaP1EZinR5HxgzOaVxBsamxlZmJqYGhuZW5qRJqwkzqveYh0o
	JJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgfG83l//e0xlUx5OfnbxCIt/uFfxj88SAvn7BERk
	y490p/XohFhrFByt2Lvtr69LBeORj1WF86s/H72z4tuxaWbt7T0Xqm59+n6Ya09pddX5hdeY
	ljoYiFzR2C0pO/nul/Vnrd5pHptY/+CNyaGZ+1bYnAwLvZHF03Moae/2gEbtqVtLHwtwb49W
	YinOSDTUYi4qTgQA98RwN88CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jQd0y99+BBhe7WC0uL7zEanH/61FG
	i8u75rBZbP7wks3idDerA6tHS3MPm8eda3vYPOadDPTo27KK0ePzJrkA1qgGRpuM1MSU1CKF
	1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoN1KCmWJOaVAoYDE4mIl
	fTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoyT55czFrzlrDj1YSdzA+NGji5GTg4JAROJjz29
	LBC2mMSFe+vZuhi5OIQEpjNKXG/ezQjh/GKU+PPvLTNIFZuAmsSXL4fZuxg5OEQEvCRu3QkC
	CTMLFEj8PbyDFcQWFvCUOLL4BxNICYuAqsSdL4kgYV4BS4mHy66yQNiCEj8m32OBaNWSWL/z
	OBOELS+xeQ3EJgkBBYkdZ18zgtgiAnoS396fYoWoEZHY9+Id4wRGgVlIRs1CMmoWklGzkLQs
	YGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc08+kdzCuarA4xCjAwajEw/sg81egEGti
	WXFl7iFGCQ5mJRHeP7OBQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwPTDd5JfGGxiZmRpZG
	ZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cCo7zpbZdqJwtZrt2dO3pC5KPYT
	c0xXyzXhjlcqGu+Ytd/Nm3uO7ce1sFsH60PPsC8pDKpXDo3etv3c0hNNp2WWZ3+Jtf6z6w3L
	4w+7CuofPn5xctWdnHkvl4v8tO1q2dy70nvp9x9Tl3jGTZvEdLfQL/3eoxVR6Tesrgods3mz
	apqYnmNk5j82TSWW4oxEQy3mouJEABV4s4wtAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_PM_SLEEP to suspend/resume functions to fix the build
warnings when CONFIG_PM_SLEEP is not selected. This is because
sleep PM callbacks defined by SET_SYSTEM_SLEEP_PM_OPS are only used
when the CONFIG_PM_SLEEP is enabled.

drivers/mfd/ucb1x00-core.c:672:12: warning: 'ucb1x00_suspend' defined but not used [-Wunused-function]
drivers/mfd/ucb1x00-core.c:704:12: warning: 'ucb1x00_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/ucb1x00-core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/ucb1x00-core.c b/drivers/mfd/ucb1x00-core.c
index 70f02da..daec8c8 100644
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -669,6 +669,7 @@ void ucb1x00_unregister_driver(struct ucb1x00_driver *drv)
 	mutex_unlock(&ucb1x00_mutex);
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int ucb1x00_suspend(struct device *dev)
 {
 	struct ucb1x00_plat_data *pdata = dev->platform_data;
@@ -736,6 +737,7 @@ static int ucb1x00_resume(struct device *dev)
 	mutex_unlock(&ucb1x00_mutex);
 	return 0;
 }
+#endif
 
 static const struct dev_pm_ops ucb1x00_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(ucb1x00_suspend, ucb1x00_resume)
-- 
1.7.10.4



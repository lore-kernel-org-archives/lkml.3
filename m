Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab3CSCDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:03:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24399 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab3CSCDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:03:01 -0400
X-AuditID: cbfee68e-b7f946d000001e37-82-5147c7532649
From: Jingoo Han <jg1.han@samsung.com>
To: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>
Cc: "'Chanwoo Choi'" <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/2] extcon: max8997: use dev_err() instead of pr_err()
Date: Tue, 19 Mar 2013 11:02:59 +0900
Message-id: <000001ce2445$e1927be0$a4b773a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4kRd0wUErczhqhS3ap06hUTXi3rA==
Content-language: ko
x-cr-hashedpuzzle: B9nh Ifkr I/4x MR0G PX/1 Qtyk Wiz9 aM4E aP2m flpN f7YQ kF54
 lLji oszg qgzm
 t/iM;4;YwB3ADAAMAAuAGMAaABvAGkAQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AG0AeQB1AG4AZwBqAG8AbwAuAGgAYQBtAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Sosha1_v1;7;{DE2DD1B3-4CA7-4CC7-A436-B175C1DEF294};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Tue,
 19 Mar 2013 02:02:52
 GMT;WwBQAEEAVABDAEgAIAAxAC8AMgBdACAAZQB4AHQAYwBvAG4AOgAgAG0AYQB4ADgAOQA5ADcAOgAgAHUAcwBlACAAZABlAHYAXwBlAHIAcgAoACkAIABpAG4AcwB0AGUAYQBkACAAbwBmACAAcAByAF8AZQByAHIAKAApAA==
x-cr-puzzleid: {DE2DD1B3-4CA7-4CC7-A436-B175C1DEF294}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t8zI93g4+6BBsevGFlc//Kc1eLywktA
	YtccNovbjSvYHFg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK6NjHnfBJdaKS6fsGxjvsXQx
	cnJICJhIPFreyQhhi0lcuLeerYuRi0NIYBmjxNwpC5hgihb8+ssIkZjOKPFn4nUmCOcXo8Sj
	zkPMIFVsAmoSX74cZgexRQR0JV5evQ0WZxbIk5hyZBeYLSzgLjHrxntWEJtFQFXixZdGMJtX
	wFZi6b677BC2oMSPyRDnMQtoSazfeZwJwpaX2LzmLdAcDqCL1CUe/dWFWKUnsWbac6hyEYl9
	L96BHSohMIdV4vy+16wQH5hK/FzTCpXYxi7xYdlxdogjBCS+TT7EAjFUVmLTAWaIekmJgytu
	sExglJiF5KRZSE6aheSkWUh2L2BkWcUomlqQXFCclF5kpFecmFtcmpeul5yfu4kREoF9Oxhv
	HrA+xJgMtH4is5Rocj4wgvNK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4UEkhPLEnNTk0tSC2K
	LyrNSS0+xMjEwSnVwChZ/OP2VXPF5ZN4XD8lv8x7FPnnjumkLVFm+lkcbSanCsPNO4+2l15m
	3LBJ0bg6dUvZrds7XikYxfq8fxp49NXXazoKD6bqhG5jMF+vw2mx7+x8MaeM3fd3X5jdWOd+
	kznAflpO4gtD7gkLRGacPMrT87ZMZINh9KZj79I+y/Iz62uK3/tU2KPEUpyRaKjFXFScCAC0
	lUZf1gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jQd3g4+6BBpvO6Flc//Kc1eLywktA
	YtccNovbjSvYHFg8+rasYvT4vEkugCmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX
	0NLCXEkhLzE31VbJxSdA1y0zB2iTkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMD
	NJCwjjGjYx53wSXWikun7BsY77F0MXJySAiYSCz49ZcRwhaTuHBvPVsXIxeHkMB0Rok/E68z
	QTi/GCUedR5iBqliE1CT+PLlMDuILSKgK/Hy6m2wOLNAnsSUI7vAbGEBd4lZN96zgtgsAqoS
	L740gtm8ArYSS/fdZYewBSV+TIa4gllAS2L9zuNMELa8xOY1b4HmcABdpC7x6K8uxCo9iTXT
	nkOVi0jse/GOEeQ2CYE5rBLn971mhfjAVOLnmlbGCYxCs5CsmIVkxSwkK2YhmbWAkWUVo2hq
	QXJBcVJ6rqFecWJucWleul5yfu4mRnB8P5PawbiyweIQowAHoxIP74lg90Ah1sSy4srcQ4wS
	HMxKIrzB/kAh3pTEyqrUovz4otKc1OJDjMnAEJjILCWanA9MPXkl8YbGJmZGlkZmFkYm5uak
	CSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwNjGa/IsDZhIPr2W28SmmP40zq388O4vyWxH
	M5+bGO44+iz3a9SyxZZnuJ++aN/I1spbPV+he8391c/viilcmDOlLinsX47Pqoe279m3GGmc
	y7FRT20+3CfQ/OJj+l7zvye7Ww9a/Ggv3Nb1c9ZeqT3L/qWpVfWL7tQW7pM/qJMttft5aPHE
	KiWW4oxEQy3mouJEAC/aCZczAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_err() is more preferred than pr_err().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/extcon/extcon-max8997.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 69641bc..20772ad 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -646,7 +646,7 @@ static void max8997_muic_detect_cable_wq(struct work_struct *work)
 
 	ret = max8997_muic_detect_dev(info);
 	if (ret < 0)
-		pr_err("failed to detect cable type\n");
+		dev_err(info->dev, "failed to detect cable type\n");
 }
 
 static int max8997_muic_probe(struct platform_device *pdev)
-- 
1.7.2.5



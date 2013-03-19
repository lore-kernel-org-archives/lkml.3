Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3CSFal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 01:30:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33410 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab3CSFaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 01:30:39 -0400
X-AuditID: cbfee690-b7f656d0000007e3-d9-5147f7fdc9a4
From: Jingoo Han <jg1.han@samsung.com>
To: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>
Cc: "'Chanwoo Choi'" <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v2 1/2] extcon: max8997: use dev_err() instead of pr_err()
Date: Tue, 19 Mar 2013 14:30:37 +0900
Message-id: <000101ce2462$e31b5fa0$a9521ee0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4kYt9lRWnD2nPSSoCwWKQtUrUYLA==
Content-language: ko
x-cr-hashedpuzzle: Ae0y GOS6 J5DF Wg/Z ap2s brVv cXNX coLR g8Kc hjAY iys8 lo9N
 mBzS mv3H nKR3
 odtF;4;YwB3ADAAMAAuAGMAaABvAGkAQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AG0AeQB1AG4AZwBqAG8AbwAuAGgAYQBtAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtAA==;Sosha1_v1;7;{99013C4A-18B3-453D-8F1A-72A99840450C};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Tue,
 19 Mar 2013 05:30:31
 GMT;WwBQAEEAVABDAEgAIAB2ADIAIAAxAC8AMgBdACAAZQB4AHQAYwBvAG4AOgAgAG0AYQB4ADgAOQA5ADcAOgAgAHUAcwBlACAAZABlAHYAXwBlAHIAcgAoACkAIABpAG4AcwB0AGUAYQBkACAAbwBmACAAcAByAF8AZQByAHIAKAApAA==
x-cr-puzzleid: {99013C4A-18B3-453D-8F1A-72A99840450C}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zI92/390DDdb80rO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZjTcyCl6xVjw/cJW5gfE9SxcjJ4eEgInEgk8nmCFsMYkL99az
	dTFycQgJLGOU+NG5mhmmaOmGX4wQiUWMEpN+PmaFcGYzSUyYupkNpIpNQE3iy5fD7CC2iICu
	xMurt8G6mQXyJKYc2QVmCwt4SRw69JIJxGYRUJWY1gyxmlfAVuLl/8NsELagxI/J91ggerUk
	1u88zgRhy0tsXvMWqJ4D6CJ1iUd/dUFMEQE9ibWPvSAqRCT2vXgHdqeEwBJWiTMfdrJBPGAq
	8f0myGkgiUXsEgu/TGaHuEFA4tvkQywQM2UlNh2AelhS4uCKGywTGCVmIbloFpKLZiG5aBaS
	3QsYWVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525ihETWhB2M9w5YH2JMBlo/kVlKNDkfGJl5
	JfGGxmZGFqYmpsZG5pZmpAkrifOqt1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDMrk9h
	14+WC1FI2c473/yJjcVslvO7fjabZRqYZJ/4Wj2LuVX3+py1JYsteji4lpVX9fcmThY/3xZS
	8fPOjxrNGQ7WOzUTt5Ze2dBatsIy3++KzGuR8turc9gaD+5doFq0bp9KJafSrx+XcrdWl2ZZ
	/Lw2v/Hu29qtqgs2eW23nKPIMe0p5zMlluKMREMt5qLiRACqjhI2wgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO7f7+6BBhOnaFtc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjMYbGQWvWCueH7jK3MD4
	nqWLkZNDQsBEYumGX4wQtpjEhXvr2boYuTiEBBYxSkz6+ZgVwpnNJDFh6mY2kCo2ATWJL18O
	s4PYIgK6Ei+v3mYGsZkF8iSmHNkFZgsLeEkcOvSSCcRmEVCVmNZ8AizOK2Ar8fL/YTYIW1Di
	x+R7LBC9WhLrdx5ngrDlJTaveQtUzwF0kbrEo7+6IKaIgJ7E2sdeEBUiEvtevGMEOU1CYAmr
	xJkPO9kgHjCV+H7zMPsERqFZSDbMQrJhFpINs5DMWsDIsopRNLUguaA4KT3XUK84Mbe4NC9d
	Lzk/dxMjOG6fSe1gXNlgcYhRgINRiYf3RLB7oBBrYllxZe4hRgkOZiUR3mB/oBBvSmJlVWpR
	fnxRaU5q8SHGZGAATGSWEk3OB6aUvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGan
	phakFsFsYeLglGpg5A4+nCXoejj9jrPg6R3VrwJf2ZRe7Jt4wt6lVpnbKb+B7+4PrUWNbcX2
	x97+cVoW+1/4XBCH9MGrH2/fa5PftSpFcocQ5/pzZ1gn/t+e6PNDma9OcWXIueiVhyRNl6rM
	OrR1+Qzml80r93rGP41yXVZWa9D/bPlMpjlq/RaLmfa/7PXP3iXxQomlOCPRUIu5qDgRALtQ
	XlMfAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_err() is more preferred than pr_err().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No Changes since v1:

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



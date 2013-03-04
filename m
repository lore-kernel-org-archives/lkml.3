Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3CDIGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:06:38 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14584 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab3CDIGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:06:36 -0500
X-AuditID: cbfee68d-b7f636d0000009be-e3-5134560ba157
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 22/24] rtc: rtc-sun4v: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 17:06:35 +0900
Message-id: <014f01ce18af$30c95f50$925c1df0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAAUAwA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zQ13uMJNAg439VhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj2plJrAUf2Cu+/slvYHzM1sXIySEhYCLx6+oRKFtM4sK99UA2
	F4eQwDJGiZuHHzF1MXKAFV2clQgRX8Qo8ePCFSYIZzaTxPJXL1hButkE1CS+fDnMDtIgIqAv
	0daiAVLDLNDLKHGmdzc7SI2QgK3El4cPmEBsTgE7ifvnVoH1Cgt4SrSv+AZ2BYuAqkTH8Saw
	el6g+mf/HjJC2IISPybfYwGxmQW0JNbvPM4EYctLbF7zlhniUHWJR391QcIiAkYS+6/PZ4co
	EZHY9+IdI8STy9glHs2UhFglIPFt8iEWiFZZiU0HmCFKJCUOrrjBMoFRYhaSxbOQLJ6FZPEs
	JBsWMLKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAiJqt4djLcPWB9iTAZaP5FZSjQ5HxiV
	eSXxhsbGJmYmpibmlqbmpqQJK4nzyl2SCRQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA6MPD
	8up8WYwpa1KG1osNn+p2FCTdiOg5r+G89LxlfITN1w1Mv3PvcD4M7t4xNa/t5W2buzfSeJ5M
	S2y78CSmNEfY5NXk9xJse9T+hH4/tP/yoZt6Ngn/fCaevGAw+3rBwbNnb785t+O37Qsbv36V
	nDUFfWxf6w3vHFcK37O/P6UqOHGyufbZcCWW4oxEQy3mouJEAKW9dEvAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgC53mEmgwbUDZhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x49qZSawFH9grvv7Jb2B8
	zNbFyMEhIWAicXFWYhcjJ5ApJnHh3nqgMBeHkMAiRokfF64wQTizmSSWv3rBClLFJqAm8eXL
	YXaQZhEBfYm2Fg2QGmaBXkaJM7272UFqhARsJb48fMAEYnMK2EncP7cKrFdYwFOifcU3NhCb
	RUBVouN4E1g9L1D9s38PGSFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDHG0usSjv7ogYREB
	I4n91+ezQ5SISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L
	10vOz93ECI7aZ1I7GFc2WBxiFOBgVOLhFfhkHCjEmlhWXJl7iFGCg1lJhLdMwiRQiDclsbIq
	tSg/vqg0J7X4EGMy0KMTmaVEk/OBCSWvJN7Q2MTMyNLIzMLIxNycNGElcV7GU08ChATSE0tS
	s1NTC1KLYLYwcXBKNTC2fj+6yjmn/UpOtZCD3rq7vvs+C7/Ii5GNfGdmO2kL+9Wy62tvrPu3
	6v66nqkKiwPVwyOlra5KTNDJEpv/8M63/u/eDx2So38feCy+8nf2silsqouX+pbnL3XbaLzU
	54iSBLuxi7eYVI57p6Ln1XDLlsJTVwzEOPaWms+WXCpx9+sPzZJNXxcpsRRnJBpqMRcVJwIA
	1FXicR4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-sun4v.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-sun4v.c b/drivers/rtc/rtc-sun4v.c
index 59b5c2d..7c51c49 100644
--- a/drivers/rtc/rtc-sun4v.c
+++ b/drivers/rtc/rtc-sun4v.c
@@ -106,18 +106,7 @@ static struct platform_driver sun4v_rtc_driver = {
 	.remove		= __exit_p(sun4v_rtc_remove),
 };
 
-static int __init sun4v_rtc_init(void)
-{
-	return platform_driver_probe(&sun4v_rtc_driver, sun4v_rtc_probe);
-}
-
-static void __exit sun4v_rtc_exit(void)
-{
-	platform_driver_unregister(&sun4v_rtc_driver);
-}
-
-module_init(sun4v_rtc_init);
-module_exit(sun4v_rtc_exit);
+module_platform_driver_probe(sun4v_rtc_driver, sun4v_rtc_probe);
 
 MODULE_AUTHOR("David S. Miller <davem@davemloft.net>");
 MODULE_DESCRIPTION("SUN4V RTC driver");
-- 
1.7.2.5



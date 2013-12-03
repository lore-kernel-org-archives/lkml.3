Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab3LCGuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 01:50:14 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:16465 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3LCGuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 01:50:11 -0500
X-AuditID: cbfee690-b7f676d00000310d-d8-529d7f210564
From: Jingoo Han <jg1.han@samsung.com>
To: "'Daniel Lezcano'" <daniel.lezcano@linaro.org>
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        "'Magnus Damm'" <damm@igel.co.jp>,
        "'Paul Mundt'" <lethal@linux-sh.org>,
        "'Simon Horman'" <horms+renesas@verge.net.au>,
        "'Laurent Pinchart'" <laurent.pinchart+renesas@ideasonboard.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/2] clocksource: sh_tmu: remove unnecessary
 platform_set_drvdata()
Date: Tue, 03 Dec 2013 15:50:09 +0900
Message-id: <000001ceeff3$e867a100$b936e300$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7v8+f5y27PXVikS06wEXaGqjqG/g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t8zI13F+rlBBhdabSwmTJrAaDHvs6zF
	hbcf2CwuL7zEajGx6Q6Lxf63P1ktLu+aw2axedNUZgcOj9kdM1k9Gp9LeNy5tofN4925c+we
	p98fYvXo27KK0WPOz28sHp83yQVwRHHZpKTmZJalFunbJXBlTNqnU9DMVvH1fQNTA+Nvli5G
	Tg4JAROJ7rWXGSFsMYkL99azdTFycQgJLGOUmDnxOlxR65T5LBCJ6YwSr1bfZoRwfjFK7Fl6
	G6ydTUBN4suXw+wgtoiAgcTr07/ZQYqYBZYxSbQf+QSWEBYIlXg5bxaYzSKgKrGm7wsbiM0r
	YCtxY88TVghbUOLH5Htgq5kFtCTW7zzOBGHLS2xe85a5i5ED6CR1iUd/dSF26Uk0bVrIDFEi
	IrHvxTtGiJKP7BL/yyE2CUh8m3yIBSIsK7HpADPEX5ISB1fcYJnAKDYLyd5ZSPbOQrJ3FpIF
	CxhZVjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmKExOuEHYz3DlgfYkwGWj+RWUo0OR8Y73kl
	8YbGZkYWpiamxkbmlmakCSuJ86o9SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwGibc+Dl
	Zw2ZjUlHppx1OnV2qUPc3xWPHseKeq3xmhuem5H7xjFv3fovFwM9vjMG1Mu8znfJU53fmPHl
	/PWD/7g0jOoOsj9v1/px8ObDmJMlmtuvbcmq3N7lXfTs61KbWSXN8+78uv8t8OGWKc9PqwQJ
	Tpi/rYprhXziZEuGBvG/hcpGV1dvCStUYinOSDTUYi4qTgQAMiPZoe0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jQV3F+rlBBuuemFtMmDSB0WLeZ1mL
	C28/sFlcXniJ1WJi0x0Wi/1vf7JaXN41h81i86apzA4cHrM7ZrJ6ND6X8LhzbQ+bx7tz59g9
	Tr8/xOrRt2UVo8ecn99YPD5vkgvgiGpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0
	tDBXUshLzE21VXLxCdB1y8wBukxJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEa
	SFjHmDFpn05BM1vF1/cNTA2Mv1m6GDk5JARMJFqnzIeyxSQu3FvP1sXIxSEkMJ1R4tXq24wQ
	zi9GiT1LQRxODjYBNYkvXw6zg9giAgYSr0//ZgcpYhZYxiTRfuQTWEJYIFTi5bxZYDaLgKrE
	mr4vbCA2r4CtxI09T1ghbEGJH5Pvga1mFtCSWL/zOBOELS+xec1b5i5GDqCT1CUe/dWF2KUn
	0bRpITNEiYjEvhfvGCcwCsxCMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS9
	5PzcTYzghPBMagfjygaLQ4wCHIxKPLwPts8JEmJNLCuuzD3EKMHBrCTCOz99bpAQb0piZVVq
	UX58UWlOavEhxmSgRycyS4km5wOTVV5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1Kz
	U1MLUotgtjBxcEo1MAb1Xr6cl/z3YU9OnMDP020/53/s6vWw/pdyPvhI197ZCx+caNrO8KbL
	e8Zt0yOOhY3TNPff05gzg3lOnLPG8r1iD0ICow4fLkmuUr8lpaV/QyKqYu3H0/fsDlcHpf5Z
	enz+xy9v1Ho/qWns8r+4r2oyv3ez5ua+JW8ncMj4/nqWHFqf4jpbM1GJpTgj0VCLuag4EQBp
	TH+fTAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Simon Horman <horms+renesas@verge.net.au>
---
 drivers/clocksource/sh_tmu.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 63557cd..e29295e 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -523,7 +523,6 @@ static int sh_tmu_probe(struct platform_device *pdev)
 	ret = sh_tmu_setup(p, pdev);
 	if (ret) {
 		kfree(p);
-		platform_set_drvdata(pdev, NULL);
 		pm_runtime_idle(&pdev->dev);
 		return ret;
 	}
-- 
1.7.10.4



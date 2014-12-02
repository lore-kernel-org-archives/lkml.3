Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaLBIud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:50:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:31595 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaLBIuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:50:08 -0500
X-AuditID: cbfee68e-f79b46d000002b74-d3-547d7d38b2ba
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, mark.rutland@arm.com, marc.zyngier@arm.com,
        arnd@arndb.de, olof@lixom.net, catalin.marinas@arm.com,
        will.deacon@arm.com, s.nawrocki@samsung.com, tomasz.figa@gmail.com,
        kyungmin.park@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, geunsik.lim@samsung.com,
        sw0312.kim@samsung.com, jh80.chung@samsung.com, cw00.choi@samsung.com,
        a.kesavan@samsung.com, pankaj.dubey@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 19/19] arm64: Enable Exynos5433 SoC in the defconfig
Date: Tue, 02 Dec 2014 17:49:56 +0900
Message-id: <1417510196-6714-20-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
References: <1417510196-6714-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWyRsSkUNeitjbE4O1rFYvHaxYzWfyddIzd
	4v2yHkaLy/u1La5/ec5qMf/IOVaLPxNa2Swm3Z/AYnHjVxurRe+Cq2wWZ5vesFtsenyN1eLy
	rjlsFjPO7wPqv/OPzWLp9YtMFqeuf2azWLT1C7vF4TftrBYzJr9ks1i16w+jxcuPJ1gcxDzW
	zFvD6PH71yRGj52z7rJ7bF5S73HlRBOrR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGVMWr6E
	uWA+W8WbJ1YNjBtZuxg5OSQETCTeLelmgrDFJC7cW8/WxcjFISSwlFHiTMc3dpiiaUsfMEIk
	pjNKnJu2mhXCaWKSWHZ4NlgVm4CWxP4XN9hAbBEBZ4mGqY1MIEXMAm+YJfbc380CkhAWcJE4
	3NoE1sAioCrx63MzWAOvgKvEiesvoNYpSCxbPhPsPk6geNeZPrC4EFDvr9aP7CBDJQQmckgc
	mXSBCWKQgMS3yYeAFnAAJWQlNh1ghpgjKXFwxQ2WCYzCCxgZVjGKphYkFxQnpRcZ6RUn5haX
	5qXrJefnbmIExuPpf8/6djDePGB9iFGAg1GJh/fE+ZoQIdbEsuLK3EOMpkAbJjJLiSbnA6M+
	ryTe0NjMyMLUxNTYyNzSTEmcN0HqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxpj4RKmo
	M+HZjpYL9r9suZW97PNS7aJ9dQzy4SfZDcV/rSu6PvlC27nzRxqWTG+eYrPAPLVbr1Zbyjvc
	d8Ne4xNxevZfwicdrFLR/StYv30jR9OLL70nZxY9Fc9s7P7ZuXLbP5aOstDQBdM48uO0Fyfy
	2Z8N565s6JzW5Wm3nCFx3oMpGz/zKLEUZyQaajEXFScCAEJZwW3CAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQV2L2toQg933pS0er1nMZPF30jF2
	i/fLehgtLu/Xtrj+5Tmrxfwj51gt/kxoZbOYdH8Ci8WNX22sFr0LrrJZnG16w26x6fE1VovL
	u+awWcw4vw+o/84/Noul1y8yWZy6/pnNYtHWL+wWh9+0s1rMmPySzWLVrj+MFi8/nmBxEPNY
	M28No8fvX5MYPXbOusvusXlJvceVE02sHn1bVjF6fN4kF8Ae1cBok5GamJJapJCal5yfkpmX
	bqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0mpJCWWJOKVAoILG4WEnfDtOE0BA3
	XQuYxghd35AguB4jAzSQsIYxY9LyJcwF89kq3jyxamDcyNrFyMkhIWAiMW3pA0YIW0ziwr31
	bF2MXBxCAtMZJc5NW80K4TQxSSw7PJsdpIpNQEti/4sbbCC2iICzRMPURiaQImaBN8wSe+7v
	ZgFJCAu4SBxubQJrYBFQlfj1uRmsgVfAVeLE9RfsEOsUJJYtnwl2BidQvOtMH1hcCKj3V+tH
	9gmMvAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEf7M+kdjKsaLA4xCnAwKvHwnjhf
	EyLEmlhWXJl7iFGCg1lJhPeXcW2IEG9KYmVValF+fFFpTmrxIUZToKsmMkuJJucDE1FeSbyh
	sYmZkaWRuaGFkbG5kjjvjZu5IUIC6YklqdmpqQWpRTB9TBycUg2MlkzdGw/qv1IRZMssjixn
	7v931bFQcIbYl74uY37m403JP2xXcNgy8uazTdNjNDa7V8Bxp9uy71nJdt7Dl3o2iH39uPPb
	8r9fb850W9bwVTLuZHpSgkUgz+vTRQE8JbtZD73N+XlYzsdk65o/gsc2GV6Tl909P+i/mYPd
	R7OvrAw8x5yUTi5SYinOSDTUYi4qTgQAwrErKQwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enable Exynos5433 SoC in the arm64 defconfig.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
Acked-by: Geunsik Lim <geunsik.lim@samsung.com>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index c7ae5ac..7551a50 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -33,6 +33,7 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_IOSCHED_DEADLINE is not set
 CONFIG_ARCH_EXYNOS=y
+CONFIG_ARCH_EXYNOS5433=y
 CONFIG_ARCH_EXYNOS7=y
 CONFIG_ARCH_THUNDER=y
 CONFIG_ARCH_VEXPRESS=y
-- 
1.8.5.5


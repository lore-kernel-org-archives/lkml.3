Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965892AbaDJKHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:07:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53305 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965744AbaDJKGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:06:51 -0400
X-AuditID: cbfee68f-b7f156d00000276c-35-53466d1c275b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com,
        linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, inki.dae@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 12/27] ARM: dts: exynos3250: Add default interrupt-parent
 connected with GIC
Date: Thu, 10 Apr 2014 19:06:02 +0900
Message-id: <1397124377-16969-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkWFcm1y3Y4Nw0RYvrX56zWnz+0MJu
	Men+BBaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2QxY/JLNov1M16zWOzdOZnRgdtj85J6
	j74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4MpovZ5RsI+1Yv2pH0wNjJdYuhg5OSQETCR2nv3H
	CGGLSVy4t56ti5GLQ0hgKaPE//9vWWGKGr9cY4ZILGKUuP/iNpTTxCRx4u02dpAqNgEtif0v
	brCB2CICARI/jr8Ds5kFbjJKHHsfBmILC8RJdL/bAhZnEVCV2HNyM5jNK+AqcXTKbmaIbXIS
	H/Y8ApvJKeAmMXPRSbAaIaCankcXwRZLCCxjl/i6dCMjxCABiW+TDwH9wwGUkJXYdABqjqTE
	wRU3WCYwCi9gZFjFKJpakFxQnJReZKxXnJhbXJqXrpecn7uJERj4p/8969/BePeA9SHGZKBx
	E5mlRJPzgZGTVxJvaGxmZGFqYmpsZG5pRpqwkjjv/YdJQUIC6YklqdmpqQWpRfFFpTmpxYcY
	mTg4pRoYzWIvti+xvBH3QKLl7Jf6ij07mw0sHvsw7OOIMXr97VfP/bOJvRI/clO2LFzym72n
	rkvnbLL79jI2OZ+XDd+2TxQwFlWcurLU+syvT7qdMisr7/lnfPG/rb+uR0VynXKc0pMdS8st
	90R+DX0hUfbuJ9OR/VNEJ8W2fAsuvVZ+8WqvoObK2UwKSizFGYmGWsxFxYkAV71v7pICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAV2ZXLdgg4M/JSyuf3nOavH5Qwu7
	xaT7E1gsehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PFjMkv2SzWz3jNYrF352RGB26PzUvq
	Pfq2rGL0+LxJLoA5qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jRuv1jIJ9
	rBXrT/1gamC8xNLFyMkhIWAi0fjlGjOELSZx4d56ti5GLg4hgUWMEvdf3GaGcJqYJE683cYO
	UsUmoCWx/8UNNhBbRCBA4sfxd2A2s8BNRolj78NAbGGBOInud1vA4iwCqhJ7Tm4Gs3kFXCWO
	TtkNtU1O4sOeR2AzOQXcJGYuOglWIwRU0/PoIvMERt4FjAyrGEVTC5ILipPSc430ihNzi0vz
	0vWS83M3MYLj6pn0DsZVDRaHGAU4GJV4eA8scw0WYk0sK67MPcQowcGsJMK7O9MtWIg3JbGy
	KrUoP76oNCe1+BBjMtBVE5mlRJPzgTGfVxJvaGxiZmRpZG5oYWRsTpqwkjjvwVbrQCGB9MSS
	1OzU1ILUIpgtTBycUg2MsX9/NM8PbnuzbmukxVMZuQ6O2KQj3VqaxfL3+p8I8X9XDXt6o6Nf
	jL/MdUc4286TzhqrnljclXlxfGGrlP7VN4+eC/IciVbwM52g07NYaJ2y7KkEfveH5xiWxUel
	ljRUKiXcXRqtxj/ru8q3bw6J/eeu/E8M3Wv4JuPZIslWyXv5E7I6vUuVWIozEg21mIuKEwHf
	4drx7wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add interrupt-parent node to connected with GIC.
All interrupt-related dt nodes need default interrupt-parent node.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index fe8960e..13efdbed 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -21,6 +21,7 @@
 
 / {
 	compatible = "samsung,exynos3250";
+	interrupt-parent = <&gic>;
 
 	chipid@10000000 {
 		compatible = "samsung,exynos4210-chipid";
-- 
1.8.0


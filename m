Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbaCLGVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 02:21:05 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49496 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbaCLGTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 02:19:23 -0400
X-AuditID: cbfee690-b7f266d00000287c-02-531ffc6a1f42
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 3/5] ARM: dts: exynos4x12: Add GPS_ALIVE power domain
Date: Wed, 12 Mar 2014 15:19:14 +0900
Message-id: <1394605156-7768-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1394605156-7768-1-git-send-email-cw00.choi@samsung.com>
References: <1394605156-7768-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWyRsSkRDfrj3ywwbW/nBbXvzxntZh/5Byr
	xblXKxktehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8FkuvX2SymDB9LYvFq4NtLBbr
	Z7xmceD1WDNvDaNHS3MPm8fK5V/YPDYvqffo27KK0ePzJjmPjXNDA9ijuGxSUnMyy1KL9O0S
	uDJW9kxiLNjDWXH9xnfmBsa/7F2MnBwSAiYSKxY2MkPYYhIX7q1n62Lk4hASWMoosXHxVlaY
	orb7K1kgEtMZJab+6GGHcBqZJA4s/MEGUsUmoCWx/8UNMFtEQFdiysw7YN3MAseYJE5MdQCx
	hQXcJdo+TwGrYRFQlfi94Q4LiM0r4CKx7PtpqDPkJD7seQS0gIODU8BVYsO8ZJCwEFDJ8Y9H
	wY6QELjELtGz9CErxBwBiW+TD7GA1EsIyEpsOgA1RlLi4IobLBMYhRcwMqxiFE0tSC4oTkov
	MtErTswtLs1L10vOz93ECIyY0/+eTdjBeO+A9SHGZKBxE5mlRJPzgRGXVxJvaGxmZGFqYmps
	ZG5pRpqwkjiv2qOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M7kbl2x++eCm7c4vM4rI2
	pq13w5ozW+Sf1V9b/2+lxloDw+7MKQWzJH542fgwJZklN8p9nnjvdf/aJUvORPQH+K+f870p
	VcqsKvOE38fohM3Mm22WJ/6NPmO8YkWBG3/OsZPWyrdV/mju3c+v4x7TIjeHSZr9q7BBOYv7
	p/Lpol+v67sdKDBQYinOSDTUYi4qTgQAFdyChq4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jQd2sP/LBBvt3M1lc//Kc1WL+kXOs
	FuderWS06F1wlc3ibNMbdotNj6+xWlzeNYfNYsb5fUwWty/zWiy9fpHJYsL0tSwWrw62sVis
	n/GaxYHXY828NYweLc09bB4rl39h89i8pN6jb8sqRo/Pm+Q8Ns4NDWCPamC0yUhNTEktUkjN
	S85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6VkmhLDGnFCgUkFhcrKRv
	h2lCaIibrgVMY4Sub0gQXI+RARpIWMOYsbJnEmPBHs6K6ze+Mzcw/mXvYuTkkBAwkWi7v5IF
	whaTuHBvPVsXIxeHkMB0RompP3rYIZxGJokDC3+wgVSxCWhJ7H9xA8wWEdCVmDLzDiuIzSxw
	jEnixFQHEFtYwF2i7fMUsBoWAVWJ3xvugG3gFXCRWPb9NDPENjmJD3seAS3g4OAUcJXYMC8Z
	JCwEVHL841GWCYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx+MzqR2MKxssDjEK
	cDAq8fAu0JQPFmJNLCuuzD3EKMHBrCTC+xEkxJuSWFmVWpQfX1Sak1p8iDEZ6KiJzFKiyfnA
	VJFXEm9obGJmZGlkbmhhZGxOmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzm+0wOfny8
	53RNN98KR2Helkvm+Ren8l8+orL2TNIF1oMlz1kf/j8e8apDtKr/YJcXe+yl0LDjOxZzzCn3
	2dBpvfLlkh87F2/yuR/D886kT2iCY/BGs8yLog9Edv0K53asq669WfzF+3WyZ1/WxmdCW17X
	bVvNpHCpVPBXj9DrDdfPvd6ntv+SEktxRqKhFnNRcSIAxgB9CgsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add GPS_ALIVE power domain for Exynos4x12 SoC. GPS_ALIVE power domain
include GPS_BLK for GPS IP. Exynos SoC used generic power-domain driver to
control power domain. After completed kernel booting, Exynos power-domain driver
disable un-used power domain to reduce power-consumption/leak.

If GPS_ALIVE power domain isn't registered to Exynos power-domain driver,
happen power-leakage because GPS_ALIVE_CONFIGURATION is default power on state.

- 0x10023D00 : GPS_ALIVE_CONFIGURATION register address

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 28b5ec7..0401f4d 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -86,6 +86,11 @@
 		reg = <0x10023CE0 0x20>;
 	};
 
+	pd_gps_alive: gps-alive-power-domain@10023D00 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10023D00 0x20>;
+	};
+
 	gic: interrupt-controller@10490000 {
 		compatible = "arm,cortex-a9-gic";
 		#interrupt-cells = <3>;
-- 
1.8.0


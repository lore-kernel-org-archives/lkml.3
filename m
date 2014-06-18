Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965110AbaFRIkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:40:21 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:57723 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933182AbaFRIkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:40:09 -0400
X-AuditID: cbfee690-b7fb56d000003439-ac-53a15064878b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: t.figa@samsung.com, kgene.kim@samsung.com, thomas.ab@samsung.com,
        viresh.kumar@linaro.org, mturquette@linaro.org, shawn.guo@linaro.org
Cc: kyungmin.park@samsung.com, cw00.choi@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 3/3] ARM: dts: Exynos: Add cpu clock table for Exynos3250
Date: Wed, 18 Jun 2014 17:40:02 +0900
Message-id: <1403080802-2794-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1403080802-2794-1-git-send-email-cw00.choi@samsung.com>
References: <1403080802-2794-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSpJsSsDDY4PYxS4vrX56zWvQuuMpm
	cbbpDbvFpsfXWC0u75rDZvG59wijxYzz+5gsnk64yGbxdN0SZov1M16zWHQsY7TY+NXDgcfj
	zrU9bB6bl9R79G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bJeU9ZC66wV3zofMHSwPiNtYuR
	k0NCwERixeTTULaYxIV769m6GLk4hASWMkocW/aWCabo1LLHrBCJ6YwSDx5MgKpqYpJ4sOIJ
	G0gVm4CWxP4XN8BsEYEeRomlHfYgRcwCOxkl5l9tYwZJCAt4Sxxqu8wCYrMIqEpcP7ODsYuR
	g4NXwEVi1nYbiG1yEh/2PGIHCXMKuEqs/BACEhYCqtjTexHsCAmBXewS2xcvZYQYIyDxbfIh
	FpB6CQFZiU0HmCHGSEocXHGDZQKj8AJGhlWMoqkFyQXFSelFJnrFibnFpXnpesn5uZsYgZFw
	+t+zCTsY7x2wPsSYDDRuIrOUaHI+MJLySuINjc2MLExNTI2NzC3NSBNWEudVe5QUJCSQnliS
	mp2aWpBaFF9UmpNafIiRiYNTqoHR1uNjwC+pTT+C6myERM1YIkId5t6I/sQS+0nuym+PB7O2
	Keg2O16/6pTTGVnB+ya+ec/rUjsJ4QfVtuW/fe89dbJirrsX/Pbpj5ssAW3bn6iqn9R6xjTt
	bXzHXj2RGaq23L6HLXre/Jros3+q1Fq+5cIJzmeqim49VTv/rvuH66rkO980RVyUWIozEg21
	mIuKEwHkTU51mgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd2UgIXBBv0/DCyuf3nOatG74Cqb
	xdmmN+wWmx5fY7W4vGsOm8Xn3iOMFjPO72OyeDrhIpvF03VLmC3Wz3jNYtGxjNFi41cPBx6P
	O9f2sHlsXlLv0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgzTs57ylpwhb3iQ+cLlgbGb6xdjJwcEgImEqeWPYayxSQu3FvP1sXIxSEkMJ1R4sGDCVBO
	E5PEgxVP2ECq2AS0JPa/uAFmiwj0MEos7bAHKWIW2MkoMf9qGzNIQljAW+JQ22UWEJtFQFXi
	+pkdjF2MHBy8Ai4Ss7bbQGyTk/iw5xE7SJhTwFVi5YcQkLAQUMWe3ousExh5FzAyrGIUTS1I
	LihOSs811CtOzC0uzUvXS87P3cQIjrNnUjsYVzZYHGIU4GBU4uHlyF0QLMSaWFZcmXuIUYKD
	WUmEd4rnwmAh3pTEyqrUovz4otKc1OJDjMlAN01klhJNzgemgLySeENjEzMjSyNzQwsjY3PS
	hJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYPQJShf/Z31+Vry7Y9oiZu+jZxaKbNos9WXD
	htJVUkt+LxI7s49jMaOe+pELm5pECp5I9t263zr/m3h27r+PHh5rTwXvWJOwRiYgbMOUEiEe
	hSdLp3Hfjn271On1TcszU1w5rvyJCFxz36U32/i/TjbDXbN5094vnvlguWxG1q1ZKbr5Vtuv
	76hUYinOSDTUYi4qTgQAm0Kh1vcCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add cpu clock table (CPU clock and voltage) to support generic
cpufreq-cpu0 driver for Exynos3250.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index d3777d2..3d3c45b 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -53,6 +53,21 @@
 			compatible = "arm,cortex-a7";
 			reg = <0>;
 			clock-frequency = <1000000000>;
+			clocks = <&cmu CLK_DIV_CORE2>;
+			clock-names = "cpu";
+
+			operating-points = <
+				1000000 1150000
+				900000  1112500
+				800000  1075000
+				700000  1037500
+				600000  1000000
+				500000  962500
+				400000  925000
+				300000  887500
+				200000  850000
+				100000  850000
+			>;
 		};
 
 		cpu1: cpu@1 {
-- 
1.8.0


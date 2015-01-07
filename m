Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbbAGOJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:09:29 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10368 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbbAGOIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:08:32 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-81-54ad3dda156f
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel@vger.kernel.org, Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH RESEND v2 3/4] ARM: dts: Enable USB node for exynos3250-rinato
Date: Wed, 07 Jan 2015 23:08:20 +0900
Message-id: <1420639701-1524-4-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420639701-1524-1-git-send-email-jaewon02.kim@samsung.com>
References: <1420639701-1524-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWyRsSkWPeW7doQg30bdC2uf3nOarGj4Qir
	Rf/j18wWl3fNYbOYcX4fkwOrx6ZVnWwefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXHy9H72
	gkOsFWv3bGVtYDzC0sXIySEhYCJx8s13NghbTOLCvfVANheHkMBSRok3a3YywxTt+XaNEcQW
	EpjOKNH7OwKiqI1J4uCF62BFbALaEt/XL2btYuTgEBFQlNi8QAGkhllgEqPEjXsrWEFqhAX8
	JNaung82iEVAVWL/6hdgV/AKuEu8XD6VDaRXQkBBYs4kG5Awp4CHxN4/R6H2ukv8eXaLFWSm
	hMB/Nontb2azQswRkPg2+RALRK+sxKYDUDdLShxccYNlAqPwAkaGVYyiqQXJBcVJ6UUmesWJ
	ucWleel6yfm5mxiBwXv637MJOxjvHbA+xCjAwajEw1vQtyZEiDWxrLgy9xCjKdCGicxSosn5
	wBjJK4k3NDYzsjA1MTU2Mrc0UxLnfS31M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo/hx
	hRPThQpFzseGzsuUdpROslsn7DT3snSQU5TtzN1bjbNi767cmHrqrI3XzRmSBu++y8xZPPvm
	0YWFcVJHcs+9O8MinisWMjuw6vPMF7c3vFytuu1P26HKiPglux0/hQWcnj4jJXWFjLFQbOox
	laI32tVv5v3Ue23UWMU1zT0i1P6kjSdLihJLcUaioRZzUXEiAJ7i5N1ZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsVy+t9jQd1btmtDDBaeUbO4/uU5q8WOhiOs
	Fv2PXzNbXN41h81ixvl9TA6sHptWdbJ59G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhDWPGydP72QsOsVas3bOVtYHxCEsXIyeHhICJxJ5v1xghbDGJC/fW
	s4HYQgLTGSV6f0d0MXIB2W1MEgcvXGcGSbAJaEt8X7+YtYuRg0NEQFFi8wIFkBpmgUmMEjfu
	rWAFqREW8JNYu3o+2FAWAVWJ/atfgC3jFXCXeLl8KhtIr4SAgsScSTYgYU4BD4m9f44yQux1
	l/jz7BbrBEbeBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCY+OZ9A7GVQ0WhxgFOBiV
	eHgL+taECLEmlhVX5h5ilOBgVhLhffMLKMSbklhZlVqUH19UmpNafIjRFOioicxSosn5wLjN
	K4k3NDYxM7I0Mje0MDI2VxLnVbJvCxESSE8sSc1OTS1ILYLpY+LglGpglL1xWT3q9rrXtlzv
	D3w5echkRccM63//HzkYKrDPOR//hG9NkeUUMR2Tnhfv2dIYH3n65gbI1T6+rlO8Tkt8Vt+q
	G59WZlc+ENwRJK5rV9X8NcHHPibzp3vf23PB/LeXZU96KHGkgDvzfcYe9mnxTSufiWxoUNi4
	aPmqR0k/Hm9MfbSzQ/ZPuBJLcUaioRZzUXEiAFylWSmjAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables hsotg and usbphy node to use USB 2.0 Device.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
---
 arch/arm/boot/dts/exynos3250-rinato.dts |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 0e3d499..b3f217c 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -132,6 +132,16 @@
 	};
 };
 
+&exynos_usbphy {
+	status = "okay";
+};
+
+&hsotg {
+	vusb_d-supply = <&ldo15_reg>;
+	vusb_a-supply = <&ldo12_reg>;
+	status = "okay";
+};
+
 &i2c_0 {
 	#address-cells = <1>;
 	#size-cells = <0>;
-- 
1.7.9.5


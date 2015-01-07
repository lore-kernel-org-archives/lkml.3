Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbbAGOIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:08:31 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:10368 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbbAGOI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:08:28 -0500
X-AuditID: cbfee68e-f79b46d000002b74-a2-54ad3dda20c8
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel@vger.kernel.org, Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH RESEND v2 0/4] ARM: dts: Add USB node for exynos3250 SoC boards
Date: Wed, 07 Jan 2015 23:08:17 +0900
Message-id: <1420639701-1524-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWyRsSkUPeW7doQg4/fxC2uf3nOarGj4Qir
	Rf/j18wWl3fNYbOYcX4fkwOrx6ZVnWwefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXG0/zpb
	wSbWii0n9zE2MK5g6WLk5JAQMJFYsH0OG4QtJnHh3nogm4tDSGApo0TDhwVMMEUdF3azQySm
	M0pM7f7MDOG0MUkcvHCdGaSKTUBb4vv6xaxdjBwcIgKKEpsXKIDUMAtMYpS4cW8FK0iNsIC/
	xKKFs9lBbBYBVYllT8+AbeAVcJe4cOIqE0ivhICCxJxJNiC9EgKv2SS62pcyQdQLSHybfIgF
	okZWYtMBZojjJCUOrrjBMoFRcAEjwypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MwHA8/e9Z
	3w7GmwesDzEKcDAq8fAW9q0JEWJNLCuuzD3EaAq0YSKzlGhyPjDo80riDY3NjCxMTUyNjcwt
	zZTEeROkfgYLCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYBTd0RTIIuW3T/28prOwcaOx+r8M
	ZimNf35OfKoFkR7u+spWZ9Ij+aZFn0yYtlpT5mpB+Ywk50id90dv9vgq7s5sfWCXzMD35Zq0
	r4zKMfXD6U2ml/4sy7rMvuKO3Z3K3bpSSitZ+U9vtP1lcNthmndV9I9db36xKMgJaihcPsf0
	952D7kpHJZbijERDLeai4kQAwNj+mUICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t9jQd1btmtDDNbOFrS4/uU5q8WOhiOs
	Fv2PXzNbXN41h81ixvl9TA6sHptWdbJ59G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhDWPG0f7rbAWbWCu2nNzH2MC4gqWLkZNDQsBEouPCbnYIW0ziwr31
	bF2MXBxCAtMZJaZ2f2aGcNqYJA5euM4MUsUmoC3xff1i1i5GDg4RAUWJzQsUQGqYBSYxSty4
	t4IVpEZYwF9i0cLZYFNZBFQllj09wwRi8wq4S1w4cZUJpFdCQEFiziSbCYzcCxgZVjGKphYk
	FxQnpeca6hUn5haX5qXrJefnbmIEB/szqR2MKxssDjEKcDAq8fAW9K0JEWJNLCuuzD3EKMHB
	rCTC++YXUIg3JbGyKrUoP76oNCe1+BCjKdDyicxSosn5wEjMK4k3NDYxM7I0Mje0MDI2VxLn
	VbJvCxESSE8sSc1OTS1ILYLpY+LglGpgrF3u+WBz2oMzTC99nfRz/k+YZpb94Gzj6qWO05xF
	31tlHl5wY9bclsjpLtPWfI+4sOel0afZerNSfD4d6NhktS4rQ8Hs1yWLlMuVUwKvZUx49axg
	hqM7V9PldRKK1p9/Rn78UiwS9vB+tr7K2iVHvvlkbfpY0rZl9y7ZOq2K4N8rWdQb1Lg+3lRi
	Kc5INNRiLipOBAAij623jAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds USB device node and phy for exynos3250 SoC.
And enables for rinato and monk boards.

Changes in v2:
 - remove unnessasary property "samsung,sysreg-phandle"
 - change "xusbxti" clock to "CLK_SCLK_UPLL"

Jaewon Kim (4):
  ARM: dts: Add exynos_usbphy node for exynos3250
  ARM: dts: Add hsotg node for exynos3250
  ARM: dts: Enable USB node for exynos3250-rinato
  ARM: dts: Enable USB node for exynos3250-monk

 arch/arm/boot/dts/exynos3250-monk.dts   |   10 ++++++++++
 arch/arm/boot/dts/exynos3250-rinato.dts |   10 ++++++++++
 arch/arm/boot/dts/exynos3250.dtsi       |   21 +++++++++++++++++++++
 3 files changed, 41 insertions(+)

-- 
1.7.9.5


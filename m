Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbaLXFpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 00:45:40 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:63636 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaLXFpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 00:45:38 -0500
X-AuditID: cbfee68f-f791c6d000004834-76-549a5300c55b
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v2 0/4] ARM: dts: Add USB node for exynos3250 SoC boards
Date: Wed, 24 Dec 2014 14:45:29 +0900
Message-id: <1419399933-3707-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsWyRsSkRJcheFaIQfN8dYvrX56zWuxoOMJq
	0f/4NbPF5V1z2CxmnN/HZLFoWSuzxdojd9kd2D02repk8+jbsorR4/MmuQDmKC6blNSczLLU
	In27BK6Mo/3X2Qo2sVZsObmPsYFxBUsXIyeHhICJxOEde5khbDGJC/fWs3UxcnEICSxllGj8
	cpcJpuju7wcsEIlFjBJdFxYwgiSEBNqYJJbN9Aax2QS0Jb6vX8zaxcjBISLgJ7HspS5IPbPA
	ekaJHRtusYHUCAt4SDQ8fAm2jUVAVWL/3VawObwC7hKXXn9nA+mVEFCQmDPJBqRXQuA7m8SJ
	V+tYIOoFJL5NPsQCUSMrsekA1NGSEgdX3GCZwCi4gJFhFaNoakFyQXFSepGxXnFibnFpXrpe
	cn7uJkZggJ7+96x/B+PdA9aHGAU4GJV4eBecmREixJpYVlyZe4jRFGjDRGYp0eR8YBzklcQb
	GpsZWZiamBobmVuaKYnzLpT6GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB0Y/pTvWUXfNm
	hwsc/ZMSdEKlLuv+E06vyvcfzz28HMyy4pvkyXtL+hoNzHXE1jeUH1lwWsBHRm+Ga3/bnFbl
	vh+z5Gxcn7I9+q874X3bNLs4tcJTeZmSXxmvGHYpyB16eMlj6bZj29MNrn6wfvx/QnONS6ba
	hAAts71FdSe3i8plaBw9beR9XImlOCPRUIu5qDgRAHpZ7qNLAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42I5/e+xgC5D8KwQg8+nFC2uf3nOarGj4Qir
	Rf/j18wWl3fNYbOYcX4fk8WiZa3MFmuP3GV3YPfYtKqTzaNvyypGj8+b5AKYoxoYbTJSE1NS
	ixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAtisplCXmlAKFAhKL
	i5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM472X2cr2MRaseXkPsYGxhUsXYycHBICJhJ3
	fz+AssUkLtxbz9bFyMUhJLCIUaLrwgJGkISQQBuTxLKZ3iA2m4C2xPf1i1m7GDk4RAT8JJa9
	1AWpZxZYzyixY8MtNpAaYQEPiYaHL5lBbBYBVYn9d1vB5vAKuEtcev2dDaRXQkBBYs4kmwmM
	3AsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBIf/M+kdjKsaLA4xCnAwKvHwLjgzI0SI
	NbGsuDL3EKMEB7OSCK/OjZkhQrwpiZVVqUX58UWlOanFhxhNgZZPZJYSTc4HxmZeSbyhsYmZ
	kaWRuaGFkbG5kjivkn1biJBAemJJanZqakFqEUwfEwenVAOjdeX1RYeYdnfe2/K0TLjmDcfi
	2HtO6zL6H6r/OqdgFpMSnp5043uqr6FK0cXCg0plk73D1Lc2HlvAe+dEq4CU8E65E1KeOobK
	syP1Xz4/8vPqOTnrPUeLi1Y/PxoSKPvml882LyahpTHMAmu8Uv++/Hx+/rHk+4+SDOJcX7nP
	j7KoZ404lpSsxFKckWioxVxUnAgAeWdakpUCAAA=
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


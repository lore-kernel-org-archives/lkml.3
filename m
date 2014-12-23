Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbaLWMqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 07:46:44 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:49880 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713AbaLWMql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:46:41 -0500
X-AuditID: cbfee68d-f79296d000004278-66-5499642ea494
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH 0/4] ARM: dts: Add USB node for exynos3250 SoC boards
Date: Tue, 23 Dec 2014 21:46:28 +0900
Message-id: <1419338792-22853-1-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrILMWRmVeSWpSXmKPExsWyRsSkRFcvZWaIwYt5lhbXvzxntdjRcITV
	ov/xa2aLy7vmsFnMOL+PyWLRslZmBzaPTas62Tz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr
	41VzYcEulopVM+wbGI8ydzFyckgImEisPvWWFcIWk7hwbz0biC0ksJRRYvVFJ5iax/Pfs3cx
	cgHFpzNKfL93ihHCaWOS+LX6MgtIFZuAtsT39YuBJnFwiAgoSmxeoABSwyywnlFix4ZbYFOF
	BVwl9s69C7aNRUBV4sbVVkYQm1fAQ2LxoYUsIL0SAgoScybZgPRKCLxnk1iyYCUbRL2AxLfJ
	h6BqZCU2HYB6QFLi4IobLBMYBRcwMqxiFE0tSC4oTkovMtQrTswtLs1L10vOz93ECAzJ0/+e
	9e5gvH3A+hCjAAejEg/vgjMzQoRYE8uKK3MPMZoCbZjILCWanA8M/LySeENjMyMLUxNTYyNz
	SzMlcV5FqZ/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhiTggX3LLzix7Zga9C1rFSztxuV
	JKK7ilMb7x49s23u/4Qv7jb6c1ceDDSuupepv13kRYTBx+UPVSdVH3E4cpN/VdhtLUVl1xfX
	5G/ItJhJsN09P2Xpuu6H3lNSI5f/VZ115PEdm8WOTawhP3O9y6sMo5c7O7/R4vrc/Tduz9F9
	AUq3uVi5F8krsRRnJBpqMRcVJwIAK6Emc0QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t9jQV29lJkhBgenGFlc//Kc1WJHwxFW
	i/7Hr5ktLu+aw2Yx4/w+JotFy1qZHdg8Nq3qZPPo27KK0ePzJrkA5qgGRpuM1MSU1CKF1Lzk
	/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoMVKCmWJOaVAoYDE4mIlfTtM
	E0JD3HQtYBojdH1DguB6jAzQQMIaxoxXzYUFu1gqVs2wb2A8ytzFyMkhIWAi8Xj+e3YIW0zi
	wr31bF2MXBxCAtMZJb7fO8UI4bQxSfxafZkFpIpNQFvi+/rFrF2MHBwiAooSmxcogNQwC6xn
	lNix4RYbSI2wgKvE3rl3WUFsFgFViRtXWxlBbF4BD4nFhxaygPRKCChIzJlkM4GRewEjwypG
	0dSC5ILipPRcI73ixNzi0rx0veT83E2M4JB/Jr2DcVWDxSFGAQ5GJR7eBWdmhAixJpYVV+Ye
	YpTgYFYS4VUOnBkixJuSWFmVWpQfX1Sak1p8iNEUaPlEZinR5HxgPOaVxBsam5gZWRqZG1oY
	GZsrifMq2beFCAmkJ5akZqemFqQWwfQxcXBKNTAuTc3+Z8HMe7yenf2wWSJrTFOX2a/aqe2q
	YoJzLt9ff3WVmKPiCvO+l5POhU9KOc7D4/pyurl+XMcBhdbvpUmJStbqZ/VelFmFTPr3/KrV
	iZ7dwXPKbLqORR43lPhaJO8mJvMx+MP6quhI5dVX3y/c/7+DdebMvLsCyfFrkwpU8/8p/hCu
	4VRiKc5INNRiLipOBAC4sYh/jwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series adds USB device node and phy for exynos3250 SoC.
And enables for rinato and monk boards.

Jaewon Kim (4):
  ARM: dts: Add exynos_usbphy node for exynos3250
  ARM: dts: Add hsotg node for exynos3250
  ARM: dts: Enable USB node for exynos3250-rinato
  ARM: dts: Enable USB node for exynos3250-monk

 arch/arm/boot/dts/exynos3250-monk.dts   |   10 ++++++++++
 arch/arm/boot/dts/exynos3250-rinato.dts |   10 ++++++++++
 arch/arm/boot/dts/exynos3250.dtsi       |   22 ++++++++++++++++++++++
 3 files changed, 42 insertions(+)

-- 
1.7.9.5


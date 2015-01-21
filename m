Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbbAUXot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 18:44:49 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54584 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbbAUXom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 18:44:42 -0500
X-AuditID: cbfee68d-f79296d000004278-ea-54c039e7833b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: s.nawrocki@samsung.com, tomasz.figa@gmail.com, mturquette@linaro.org
Cc: kgene@kernel.org, pankaj.dubey@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, sw0312.kim@samsung.com,
        cw00.choi@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/9] clk: samsung: Add clocks for remaining domains of
 Exynos5433
Date: Thu, 22 Jan 2015 08:44:29 +0900
Message-id: <1421883878-4980-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWyRsSkRPeF5YEQgwttTBaX92tbXP/ynNVi
	0v0JLBb9j18zW1zeNYfNYsb5fUwWTydcZLNYtPULu8XhN+2sFjMmv2SzWLXrD6MDt8fOWXfZ
	PTat6mTzuHNtD5tH35ZVjB6fN8kFsEZx2aSk5mSWpRbp2yVwZcxc9JOx4D1vxZH9qQ2M7dxd
	jJwcEgImEhPuL2SEsMUkLtxbz9bFyMUhJLCUUWLylNWsMEX79y9i7mLkAEpMZ5Q47wESFhJo
	YpI4csUMxGYT0JLY/+IGG4gtIuAhcfrZTRaQOcwClxklVneeAusVFgiWOPAGbBeLgKrEzbtz
	wOp5BVwk2h6vYIFYpSCxbPlMVpBeCYF57BLv++4xQTQISHybfIgFZI6EgKzEpgPMEPWSEgdX
	3GCZwCi4gJFhFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZgWJ/+96x3B+PtA9aHGAU4GJV4
	eF8o7g8RYk0sK67MPcRoCrRhIrOUaHI+MHrySuINjc2MLExNTI2NzC3NlMR5FaV+BgsJpCeW
	pGanphakFsUXleakFh9iZOLglGpgjFgifGv1p5boRSd/n+X4K3PlnfA2nphjvad8zggulVoS
	8Xz6hddXD2hG+a2tVeMvvTPBPiXr5j6X/bvj4yOWT3MNcpBqb5YI/XOaz2VN1roC/nC7F3cT
	ptYWtidU19yIP1m47k2GYO+kQxI1V6enisnFvzx7vCPPSE0kSffUNm7BzI+xKaKnlViKMxIN
	tZiLihMBpKFPC2YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsVy+t9jQd3nlgdCDN7ONbO4vF/b4vqX56wW
	k+5PYLHof/ya2eLyrjlsFjPO72OyeDrhIpvFoq1f2C0Ov2lntZgx+SWbxapdfxgduD12zrrL
	7rFpVSebx51re9g8+rasYvT4vEkugDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX
	0NLCXEkhLzE31VbJxSdA1y0zB+g0JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYG
	aCBhDWPGzEU/GQve81Yc2Z/awNjO3cXIySEhYCKxf/8iZghbTOLCvfVsXYwcHEIC0xklznuA
	hIUEmpgkjlwxA7HZBLQk9r+4wQZiiwh4SJx+dpOli5GLg1ngMqPE6s5TzCC9wgLBEgfeMILU
	sAioSty8OwesnlfARaLt8QoWiFUKEsuWz2SdwMi9gJFhFaNoakFyQXFSeq6hXnFibnFpXrpe
	cn7uJkZw1DyT2sG4ssHiEKMAB6MSD+8Lxf0hQqyJZcWVuYcYJTiYlUR4PTQOhAjxpiRWVqUW
	5ccXleakFh9iNAXaPpFZSjQ5HxjReSXxhsYmZkaWRuaGFkbG5krivEr2bSFCAumJJanZqakF
	qUUwfUwcnFINjO5cP25NLlM90VzRa+4/K2dJsMyBW2HcV//eLJ2fobj27JbHX+e9/Pvp5f1I
	ay7RX0menbePLplyLrrI4Mr9AzadPW/fCVTatLbbKKqkZwTkyfVc5JbQeJ71PKHRwGnLFZPn
	Oj9MeHxeM7PdEhGdMzVjUUDDj6fv+0VrDx/fLKUxXc7W1/yFhRJLcUaioRZzUXEiAJH2EVWw	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds the support for following clock domains of Exynos5433
and clkout drvier.

Following clock domains has clocks for each IP.
- CMU_APOLLO : clocks for Cortex-A53 Quad-core processor.
- CMU_ATLAS  : clocks for Cortex-A57 Quad-core processor, CoreSight and
               L2 cache controller.
- CMU_MSCL   : clocks for M2M (Memory to Memory) scaler and JPEG IPs.
- CMU_MFC    : clocks for MFC (Multi-Format Codec) IP.
- CMU_HEVC   : clocks for HEVC(High Efficiency Video Codec) decoder IP.
- CMU_ISP    : clocks for FIMC-ISP/DRC/SCLC/DIS/3DNR IPs.
- CMU_CAM0   : clocks for MIPI_CSIS{0|1}/FIMC_LITE_{A|B|D}/FIMC_3AA{0|1} IPs.
- CMU_CAM1   : clocks for COrtex-A5/MIPI_CSIS2/FIMC_LITE_C/FIMC-FD IPs.

Depend on:
[PATCH v3 00/12] clk: samsung: Add the support for exynos5433 clocks
- https://lkml.org/lkml/2015/1/21/44

Chanwoo Choi (8):
  clk: samsung: exynos5433: Add clocks for CMU_APOLLO domain
  clk: samsung: exynos5433: Add clocks for CMU_ATLAS domain
  clk: samsung: exynos5433: Add clocks for CMU_MSCL domain
  clk: samsung: exynos5433: Add clocks for CMU_MFC domain
  clk: samsung: exynos5433: Add clocks for CMU_HEVC domain
  clk: samsung: exynos5433: Add clocks for CMU_ISP domain
  clk: samsung: exynos5433: Add clocks for CMU_CAM0 domain
  clk: samsung: exynos5433: Add clocks for CMU_CAM1 domain

Inha Song (1):
  clk: samsung: Add CLKOUT driver support for Exynos5433 SoC.

 .../devicetree/bindings/clock/exynos5433-clock.txt |   66 +
 drivers/clk/samsung/clk-exynos-clkout.c            |    2 +
 drivers/clk/samsung/clk-exynos5433.c               | 2028 ++++++++++++++++++++
 include/dt-bindings/clock/exynos5433.h             |  548 +++++-
 4 files changed, 2643 insertions(+), 1 deletion(-)

-- 
1.8.5.5


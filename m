Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab3JJFpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:45:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56922 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3JJFps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:45:48 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-1a-52563f0afbe4
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com, kyungmin.park@samsung.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 0/3] ARM: dts: exynos: Add missing dt data to bring up kernel
 feature
Date: Thu, 10 Oct 2013 14:45:33 +0900
Message-id: <1381383936-2627-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42JZI2JSqMtlHxZksH2XusX1L89ZLeYfOcdq
	ce7VSkaL3gVX2SzONr1ht9j0+BqrxeVdc9gsZpzfx2Rx+zKvxdLrF5ksJkxfy2JxeMUBJotX
	B9tYLNbPeM3iwOexZt4aRo+W5h42jwWfr7B7rFz+hc1j85J6j74tqxg9Pm+S89g4NzSAI4rL
	JiU1J7MstUjfLoEr49mCsIJrLBUrd/5kbmC8zdzFyMkhIWAiseLyXhYIW0ziwr31bF2MXBxC
	AksZJd4s+sXUxcgBVnTjYi1EfDqjxOwfC5ghnEYmiSWz57GCdLMJaEnsf3EDrFtEoJ1RYnXr
	AhYQh1mglUni6pZdzCCjhAUiJa49SARpYBFQlWjZ+QYszCvgIvH3byXEFXISH/Y8YgdplRA4
	xS4x6+ZFJoh6AYlvkw+xQFwkK7HpANQHkhIHV9xgmcAouICRYRWjaGpBckFxUnqRsV5xYm5x
	aV66XnJ+7iZGYEyc/vesfwfj3QPWhxiTgcZNZJYSTc4HxlReSbyhsZmRhamJqbGRuaUZacJK
	4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhj3qB/exTY5oFZzf6jV3bgVh9m/NdvW
	f1+UZCx39OKlm989nKc93/4owuzNJPl1M4Jay+baC/IvipObMPvgoeT9NbrvDn/e+Eug0Z3x
	xvn6bMlWCfnfF/U1u7+lHNnF1vvj+Cd2puopbed26R0piT1feVebq1PWJrwl4MPJGamH9n7P
	cy3rynumxFKckWioxVxUnAgAavAmkJ8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t9jQV0u+7Agg09d8hbXvzxntZh/5Byr
	xblXKxktehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8FkuvX2SymDB9LYvF4RUHmCxe
	HWxjsVg/4zWLA5/HmnlrGD1amnvYPBZ8vsLusXL5FzaPzUvqPfq2rGL0+LxJzmPj3NAAjqgG
	RpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoLOVFMoS
	c0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBnPFoQVXGOpWLnzJ3MD423mLkYO
	DgkBE4kbF2u7GDmBTDGJC/fWs3UxcnEICUxnlJj9YwEzhNPIJLFk9jxWkCo2AS2J/S9ugFWJ
	CLQzSqxuXcAC4jALtDJJXN2yC2yssECkxLUHiSANLAKqEi0734CFeQVcJP7+rYTYJifxYc8j
	9gmM3AsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEfcM+kdjKsaLA4xCnAwKvHwVpSF
	BgmxJpYVV+YeYpTgYFYS4Z1+EijEm5JYWZValB9fVJqTWnyIMRlo+URmKdHkfGAyyCuJNzQ2
	MTOyNDI3tDAyNidNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRpOld7Vf11fbOnP8Fnix
	z/CRjYHMHCkZo9AZjwu22ovvi83XecN15rZ8pajb+daPPwO/bj0l0Xxms7e4wvFpM+rdv5w4
	oVJ9ifFYgOz7275pSbPYl8dcF+vtejhNOe4MY2ueQsH24KSryyMEH+l8bu+Vnzjl0p7TJkEs
	7+ak3n+geHTi1C1nFiuxFGckGmoxFxUnAgD2ixfB/AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add missing dt data to bring up kernel feature
- MAUDIO/GPS_ALIVE power domain
- PMU
- Clock data for Multi core timer

Changes since v1:
- Fix wrong address of GPS_ALIVE power domain

Chanwoo Choi (2):
  ARM: dts: exynos4212: Add PMU dt data for pmu-irq
  ARM: dts: exynos4x12: Add maudio/gps_alive power domain for exynos4x12

Marek Szyprowski (1):
  ARM: dts: exynos4212: Add missing clock for multi core timer

 arch/arm/boot/dts/exynos4212.dtsi |  8 ++++++++
 arch/arm/boot/dts/exynos4x12.dtsi | 10 ++++++++++
 2 files changed, 18 insertions(+)

-- 
1.8.0


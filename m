Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaJTMIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:08:52 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17062 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaJTMIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:08:48 -0400
X-AuditID: cbfee68f-f791c6d000004834-ce-5444fb4ed2d3
From: Chanwoo Choi <cw00.choi@samsung.com>
To: viresh.kumar@linaro.org, tomasz.figa@gmail.com
Cc: kgene.kim@samsung.com, thomas.ab@samsung.com, kyungmin.park@samsung.com,
        inki.dae@samsung.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 0/4] cpufreq: Use cpufreq-dt driver for Exynos3250
Date: Mon, 20 Oct 2014 21:08:38 +0900
Message-id: <1413806922-22722-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWyRsSkQNfvt0uIwe797BbXvzxntZh0fwKL
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8miYxmjxapdfxgtNn71cOD22DnrLrvH
	nWt72Dw2L6n36NuyitHj8ya5ANYoLpuU1JzMstQifbsEroyp34+zFnTzVPzYd4O1gfEHZxcj
	B4eEgIlE76KILkZOIFNM4sK99WxdjFwcQgJLGSW+XLjBDpEwkejpmMICkZjOKPFj5lEop4lJ
	4uSW7cwgVWwCWhL7X9xgA7FFBIwkVu1cygpSxCzQxyTxf/ETdpB1wgIuEkdv24PUsAioSpy+
	1s0EEuYVcJWY904MYpmcxIc9j9hBWiUE5rFLPF50mB2iXkDi2+RDLBBXy0psOsAMUS8pcXDF
	DZYJjIILGBlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYgSG9el/z/p3MN49YH2IUYCDUYmH
	d4eZS4gQa2JZcWXuIUZToA0TmaVEk/OB0ZNXEm9obGZkYWpiamxkbmmmJM67UOpnsJBAemJJ
	anZqakFqUXxRaU5q8SFGJg5OqQbGSjfl3gtTJQ2eKp7cdMNepibW2ym8rq/oVPEC9SVvNVm3
	qxhvzf62bb/AppNbchbtypy57cvSU9885gb03RTfcGvP7Pwj7wRT9pVvPvhQULf9VOvSr8Xl
	Rr9nqt1VtJz+I+H2h8Vzf2y2F58aPu/ghi0qAfHPjzN829jwe3rS3rc/06wZu2fcjlRiKc5I
	NNRiLipOBADp/Cr5ZgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t9jQV3f3y4hBiu7bSyuf3nOajHp/gQW
	i94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5NFxzJGi1W7/jBabPzq4cDtsXPWXXaP
	O9f2sHlsXlLv0bdlFaPH501yAaxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgzpn4/zlrQzVPxY98N1gbGH5xdjJwcEgImEj0dU1ggbDGJC/fWs3UxcnEICUxnlPgx8ygL
	hNPEJHFyy3ZmkCo2AS2J/S9usIHYIgJGEqt2LmUFKWIW6GOS+L/4CXsXIweHsICLxNHb9iA1
	LAKqEqevdTOBhHkFXCXmvRODWCYn8WHPI/YJjNwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl
	5+duYgTHzTOpHYwrGywOMQpwMCrx8O4wcwkRYk0sK67MPcQowcGsJMIb9Q0oxJuSWFmVWpQf
	X1Sak1p8iNEUaPlEZinR5HxgTOeVxBsam5gZWRqZG1oYGZsrifMeaLUOFBJITyxJzU5NLUgt
	gulj4uCUamA0spb6vzhSUFTq8KTo7MS4jdtfdP5eVRLzZw7rh1L3OY4fUk5++nC4rKFKsS44
	eUHtFHnrKrud8588/Dmh4cW2p1q7X83x3XP/2n2RpBaTwH3VxxTmLjZRj+yxCjqi/3OS8M6F
	zYoOGfqKDvtfhN9auXeuhtvK/NuLYnS50ttvfFPSfiTvvlJRiaU4I9FQi7moOBEA5GLWIbEC	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset use cpufreq-dt driver to support Exynos3250 cpufreq and tested it
on Exynos3250-based Rinato board.

Changes from v3:
- This patchset is based on 3.18-rc1 with new patchset[3] of Thomas Abraham
  [3] [PATCH v11 0/6] cpufreq: use generic cpufreq drivers for exynos platforms
  - http://www.spinics.net/lists/arm-kernel/msg370412.html

Changes from v2:
- Rebased on new patchset of Thomas Abraham
  and for-next branch of samsunc-clk.git of Tomasz Figa

Changes from v1:
- Rebased on new patchset[1] by Thomas Abraham
  [1] [PATCH v10 0/6] cpufreq: use generic cpufreq drivers for exynos platforms
  - http://www.spinics.net/lists/arm-kernel/msg364790.html
- Modify clk-cpu.c to support Exynos3250
- Drop documentation patch on previous patchset[2]
  [2] http://www.spinics.net/lists/cpufreq/msg10265.html
- Add only operating-points for Exynos3250 without armclk-divider-table

Chanwoo Choi (4):
  clk: samsung: exynos3250: Add cpu clock configuration data and instaniate cpu clock
  clk: samsung: exynos3250: Update clock flags related to CPU to use cpu-clock type
  ARM: exynos: Add exynos3250 compatible to use generic cpufreq driver
  ARM: dts: Add CPU OPP and regulator supply property for Exynos3250

 arch/arm/boot/dts/exynos3250.dtsi    | 15 +++++++++++
 arch/arm/mach-exynos/exynos.c        |  1 +
 drivers/clk/samsung/clk-cpu.h        |  4 +++
 drivers/clk/samsung/clk-exynos3250.c | 49 ++++++++++++++++++++++++++++--------
 4 files changed, 59 insertions(+), 10 deletions(-)

-- 
1.8.0


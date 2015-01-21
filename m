Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbbAUG1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:27:06 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62694 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbbAUG1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:27:02 -0500
X-AuditID: cbfee68d-f79296d000004278-4a-54bf46b3d635
From: Chanwoo Choi <cw00.choi@samsung.com>
To: s.nawrocki@samsung.com, tomasz.figa@gmail.com
Cc: mturquette@linaro.org, kgene@kernel.org, pankaj.dubey@samsung.com,
        inki.dae@samsung.com, chanho61.park@samsung.com,
        sw0312.kim@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/12] clk: samsung: Add the support for exynos5433 clocks
Date: Wed, 21 Jan 2015 15:26:49 +0900
Message-id: <1421821618-8627-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsWyRsSkRHez2/4Qg3NHDCwu79e2uP7lOavF
	pPsTWCz6H79mtri8aw6bxYzz+5gsnk64yGaxaOsXdovDb9pZLWZMfslmsWrXH0YHbo+ds+6y
	e2xa1cnmcefaHjaPvi2rGD0+b5ILYI3isklJzcksSy3St0vgyjiw4ixbwRehihl3HrA3MB7i
	72Lk5JAQMJFY9Hk7E4QtJnHh3nq2LkYuDiGBpYwSS9vXM8MULX86kQXEFhJYxCjx/4EfRFET
	k0TL2TawBJuAlsT+FzeAujk4RAQMJW4eUgKpYRZ4wyjR/f43K0iNsICvxPUL59lBbBYBVYld
	zy4zgtTzCrhI/NiaCrFLQWLZ8pmsIL0SAvPYJbbu6mOEqBeQ+Db5EAtIvYSArMSmA1C3SUoc
	XHGDZQKj4AJGhlWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsYgaF9+t+z3h2Mtw9YH2IU4GBU
	4uF9obg/RIg1say4MvcQoynQhonMUqLJ+cAIyiuJNzQ2M7IwNTE1NjK3NFMS51WU+hksJJCe
	WJKanZpakFoUX1Sak1p8iJGJg1OqgdG6btu2hPWbtBMueOU1qMmkfmFUC79w+eI9x9D+OMXC
	0iNxqUfeGUXt9EnMmnBtafsXX/nDV+MdDR09rB/eC2paEnf6/dwDPAcKVvx1sInSs3vRVsY5
	Y6NnefOtN+8ffvd57sTB9cYpua/mUbXW57QJ7Ikfzc95/joVv05C/rdwdLdPXaX5FCWW4oxE
	Qy3mouJEAGIfiGVoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t9jAd3NbvtDDDqma1hc3q9tcf3Lc1aL
	SfcnsFj0P37NbHF51xw2ixnn9zFZPJ1wkc1i0dYv7BaH37SzWsyY/JLNYtWuP4wO3B47Z91l
	99i0qpPN4861PWwefVtWMXp83iQXwBrVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhr
	aGlhrqSQl5ibaqvk4hOg65aZA3SakkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMD
	NJCwhjHjwIqzbAVfhCpm3HnA3sB4iL+LkZNDQsBEYvnTiSwQtpjEhXvr2UBsIYFFjBL/H/h1
	MXIB2U1MEi1n28CK2AS0JPa/uAFUxMEhImAocfOQEkgNs8AbRonu979ZQWqEBXwlrl84zw5i
	swioSux6dpkRpJ5XwEXix9ZUiF0KEsuWz2SdwMi9gJFhFaNoakFyQXFSeq6hXnFibnFpXrpe
	cn7uJkZw5DyT2sG4ssHiEKMAB6MSD+8Lxf0hQqyJZcWVuYcYJTiYlUR4FSWAQrwpiZVVqUX5
	8UWlOanFhxhNgZZPZJYSTc4HRnVeSbyhsYmZkaWRuaGFkbG5kjivkn1biJBAemJJanZqakFq
	EUwfEwenVAPjmX1Hf5YmqXJfdg1SW9bN3N7bpOG9ZvZVm+/XbhxsFH/Aftn7qs3d/c+frP2t
	KDR73+T/Z+5JarF+5wm80PXkl8+XmbMsC913KO6+ELDmfW55a5hUeIq8SVT4yt7rk/7+T5vo
	wPt9gWLfm9e/XMUUlhjKf90sde8JI0eL++7c0lWJRYkfjMuuKbEUZyQaajEXFScCABzFAkuy	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds the support for Exynos5433 CMU (Clock Management Unit)
by using common clock framework. This patchset is divided from patch[1]
and then sent it.
[1] https://lkml.org/lkml/2014/12/2/134

Changelog:

Changes from v2:
- Fix the parent clock of sclk_bus_pll/sclk_mfc_pll clock on CMU_MIF domain
- Fix wrong clock name of 'phyclk_usbdrd30_udrd30_{pipe_pclk|phyclock}_phy' clock
- Add the clock id for CMU_FSYS fixed clock
- Fix wrong bit width of CLK_DIV_SCLK_SCI clock on CMU_PERIC domain
- Remove duplicat parent clocks on CMU_DISP/CMU_AUD domains
- Fix typo on patch descriptions
- Fix wrong fixed rate on CMU_AUD domain (ioclk_{jtag_|slimbus_|i2s_b}clk)
- Add CLK_IGNORE_UNUSED flag to 'aclk_dmac/sclk_aud_i2s' clock for audio subsystem
- Fix the parent clock of mout_aclk_fsys_200_user clock from aclk_fsys_200 to div_aclk_fsys_200

Changes from v1:
- Fix wrong register and code clean by using space instead of tab [Pankaj]
- Add CLK_IGNORE_UNUSED flag to pclk_sysreg_* clock for accessing system control register
- Remove duplicate definition on the patch for CMU_BUS{0|1|2} domain

Chanwoo Choi (12):
  clk: samsung: exynos5433: Add clocks using common clock framework
  clk: samsung: exynos5433: Add MUX clocks of CMU_TOP domain
  clk: samsung: exynos5433: Add clocks for CMU_PERIC domain
  clk: samsung: exynos5433: Add clocks for CMU_PERIS domain
  clk: samsung: exynos5433: Add clocks for CMU_G2D domain
  clk: samsung: exynos5433: Add clocks for CMU_MIF domain
  clk: samsung: exynos5433: Add clocks for CMU_DISP domain
  clk: samsung: exynos5433: Add clocks for CMU_AUD domain
  clk: samsung: exynos5433: Add clocks for CMU_BUS{0|1|2} domains
  clk: samsung: exynos5433: Add missing clocks for CMU_FSYS domain
  clk: samsung: exynos5433: Add clocks for CMU_G3D domain
  clk: samsung: exynos5433: Add clocks for CMU_GSCL domain

 .../devicetree/bindings/clock/exynos5433-clock.txt |  167 +
 drivers/clk/samsung/Makefile                       |    1 +
 drivers/clk/samsung/clk-exynos5433.c               | 3395 ++++++++++++++++++++
 include/dt-bindings/clock/exynos5433.h             |  857 +++++
 4 files changed, 4420 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/exynos5433-clock.txt
 create mode 100644 drivers/clk/samsung/clk-exynos5433.c
 create mode 100644 include/dt-bindings/clock/exynos5433.h

-- 
1.8.5.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091AbaEHDtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 23:49:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27395 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaEHDtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 23:49:04 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-b6-536afead964e
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v4 0/4] Introduce new Kconfig for Samsung common clock
Date: Thu, 08 May 2014 13:07:07 +0900
Message-id: <1399522031-3394-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t8zY921/7KCDRa/lbLoXXCVzWLT42us
	Fpd3zWGzmHF+H5PFoq1f2C3Wz3jN4sDmsXlJvUffllWMHp83yQUwR3HZpKTmZJalFunbJXBl
	7Do1i7HgIl/Fhr7p7A2MV7i7GDk5JARMJPa+msoMYYtJXLi3nq2LkYtDSGAZo0Tf/ulsMEX3
	vzyBSkxnlHh0eS6U08YksbzxNlg7m4CuxJP3c8FsEYFsiSuN98FsZoEIiTkb2lhAbGEBN4kv
	P6+CTWURUJVYsesUUJyDg1fAXWLFBCcQU0JAQWLOJBuQ8RICz9kktt64xAxRLiDxbfIhFoga
	WYlNB6COlpQ4uOIGywRGwQWMDKsYRVMLkguKk9KLTPWKE3OLS/PS9ZLzczcxQoJy4g7G+wes
	DzEmA42byCwlmpwPDOq8knhDYzMjC1MTU2Mjc0sz0oSVxHnTHyUFCQmkJ5akZqemFqQWxReV
	5qQWH2Jk4uCUamC0tLgnGcqp/W9mzjO3nN5vwavKf23qvLhp7y7xp2y/pCf8fn+raWfx/kjh
	3kcLU9rE9jv+KTzks3Hhn//z2LQVumWOr+48s9nb+LwYd9HhuCkRt6e2bdtz0nLjg2s1qk9F
	KvIbW73St/b+3ezg/vUiw+LF6i0pXbKrlh5zUV3Ev2beStf5U5+6KLEUZyQaajEXFScCAAwo
	YfVgAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jQd21/7KCDaZtErPoXXCVzWLT42us
	Fpd3zWGzmHF+H5PFoq1f2C3Wz3jN4sDmsXlJvUffllWMHp83yQUwRzUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZuw6NYux4CJfxYa+6ewNjFe4uxg5OSQETCTuf3nCBmGL
	SVy4tx7I5uIQEpjOKPHo8lwop41JYnnjbWaQKjYBXYkn7+eC2SIC2RJXGu+D2cwCERJzNrSx
	gNjCAm4SX35eBZvKIqAqsWLXKaA4BwevgLvEiglOIKaEgILEnEk2Exi5FzAyrGIUTS1ILihO
	Ss810itOzC0uzUvXS87P3cQIDvln0jsYVzVYHGIU4GBU4uHNcM4KFmJNLCuuzD3EKMHBrCTC
	6z8ZKMSbklhZlVqUH19UmpNafIgxGWj3RGYp0eR8YDzmlcQbGpuYGVkamVkYmZibkyasJM57
	sNU6UEggPbEkNTs1tSC1CGYLEwenVANji2qz/gS7h87Hshe/POU/e8sO5ytG5isyPkgrOR3x
	3Hztj8FPz31r2766tzpWFHAFXJlrLCmrdUN66cMjCQpz7e5G750gu2PSxZq5q776yW+fJr26
	0ufotdWuPAtVuzWPFxYuPPPxQEeFcDV7yDv2mV3C0TOsl27Zd6wzq6hx0bYWkzMHPZ1zlFiK
	MxINtZiLihMBTj7AEb0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce a new Kconfig file for Samsung common clock infrastructure
related config options. As current Samsung common clock gets compiled
based on PLAT_SAMSUNG, but moving ahead with ARM64 we can not have any
more such config options, so this patch introduce new COMMON_CLK_SAMSUNG
invisible option. This option also select COMMON_CLK so ARCH Kconfig just
need to select COMMON_CLK_SAMSUNG in case they want to use Samsung common
clock.

This series is based on Kukjin's for-next branch.

I am just respinning this patch after rebasing. I have already addressed
all review comments discussed here [1].

[1]: http://lkml.org/lkml/2014/3/19/216

V4:
 1) Rebased on latest Kukjin's for-next branch.

V3: 
 1) Re-organized patches for preventing bisect issues.
 2) Rebase on top of latest Kukjin's for-next branch.
 3) Compile tested exynos_defconfig, s3c6400_defconfig and s3c2410_defconfig
    after each commit.

V2:
 1) Adding new Kconfig file for Samsung common clock.
 2) Make COMMON_CLK_SAMSUNG option invisible. (as suggested by Tomasz Figa)
 3) Let COMMON_CLK_SAMSUNG select COMMON_CLK. (as suggested by Tomasz Figa)
 4) Move S3C24XX clock config option in new Kconfig file.

Pankaj Dubey (4):
  clk: samsung: add new Kconfig for Samsung common clock option
  ARM: select COMMON_CLK_SAMSUNG for ARCH_EXYNOS and ARCH_S3C64XX
  ARM: S3C24XX: move S3C24XX clock Kconfig options to Samsung clock
    Kconfig file
  drivers: clk: use COMMON_CLK_SAMSUNG for Samsung clock support

 arch/arm/Kconfig              |    4 ++--
 arch/arm/mach-s3c24xx/Kconfig |   14 --------------
 drivers/clk/Kconfig           |    2 ++
 drivers/clk/Makefile          |    2 +-
 drivers/clk/samsung/Kconfig   |   12 ++++++++++++
 5 files changed, 17 insertions(+), 17 deletions(-)
 create mode 100644 drivers/clk/samsung/Kconfig

-- 
1.7.10.4


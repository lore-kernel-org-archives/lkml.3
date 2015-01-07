Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbbAGFj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 00:39:59 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:13956 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbbAGFjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 00:39:20 -0500
X-AuditID: cbfee68f-f791c6d000004834-5c-54acc679a28c
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kgene@kernel.org, linux@arm.linux.org.uk, b.zolnierkie@samsung.com,
        amit.daniel@samsung.com, arnd@arndb.de, thomas.ab@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v2 0/6] samsung: pmu: split up SoC specific PMU data
Date: Wed, 07 Jan 2015 11:01:22 +0530
Message-id: <1420608688-10459-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 2.2.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWyRsSkTrfy2JoQgxnL9C0aroZY/J10jN1i
	44z1rBb9j18zW2x6fI3V4vKuOWwWM87vY7K4fZnXYtHWL+wWHcsYHbg8Wpp72Dx+/5rE6LFp
	VSebx+Yl9R59W1YxenzeJBfAFsVlk5Kak1mWWqRvl8CVsfBJG1PBcZWKVS9uMzYwvpTuYuTk
	kBAwkZi67xMrhC0mceHeerYuRi4OIYGljBJdy+awwBRNPrOVBSIxnVHi4YIVzBDOBCaJ7Z+O
	s4NUsQnoSjx5P5cZxBYRyJbov70arINZYBOjxOvuU2A7hAVcJO6/bwdrYBFQlej4BjKWg4NX
	wEOi66IrxDY5iS23HrGD9EoITGeX+Nl0DqpeQOLb5ENg9RICshKbDjBD1EtKHFxxg2UCo+AC
	RoZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGIGBffrfs/4djHcPWB9iFOBgVOLhLehbEyLE
	mlhWXJl7iNEUaMNEZinR5Hxg/OSVxBsamxlZmJqYGhuZW5opifMulPoZLCSQnliSmp2aWpBa
	FF9UmpNafIiRiYNTqoFx0x4OIdGpT87UT3pSP2NrQOZ8rgQThgM3igvvfxb/21deJn1v84+o
	3RfWrvyzqGvqpd/XlHbP2uLEt527Z0N/jdr1Vg0xxUWTApI5dmdVrb7zTvWIlcvvE1xdKXIV
	1QYPGJvtmRvreO0uTI88FfE8tKav78ADvtDE0O69+U/XMrzedHh5a6a3EktxRqKhFnNRcSIA
	A7HqbWcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t9jQd3KY2tCDP41qFo0XA2x+DvpGLvF
	xhnrWS36H79mttj0+BqrxeVdc9gsZpzfx2Rx+zKvxaKtX9gtOpYxOnB5tDT3sHn8/jWJ0WPT
	qk42j81L6j36tqxi9Pi8SS6ALaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJc
	SSEvMTfVVsnFJ0DXLTMH6C4lhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEN
	Y8bCJ21MBcdVKla9uM3YwPhSuouRk0NCwERi8pmtLBC2mMSFe+vZuhi5OIQEpjNKPFywghnC
	mcAksf3TcXaQKjYBXYkn7+cyg9giAtkS/bdXs4AUMQtsYpR43X2KFSQhLOAicf99O1gDi4Cq
	RMc3kBUcHLwCHhJdF10htslJbLn1iH0CI/cCRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmb
	GMFx80xqB+PKBotDjAIcjEo8vAV9a0KEWBPLiitzDzFKcDArifBadQKFeFMSK6tSi/Lji0pz
	UosPMZoCLZ/ILCWanA+M6bySeENjE3NTY1NLEwsTM0slcV4l+7YQIYH0xJLU7NTUgtQimD4m
	Dk6pBsb0xNcXTK6fWXFuwe62jVWs07XdbhlphVu+6hETrb0yS8jTchdD9L1JljvUFG9PfrB/
	UuaqT9Ny35odq44U5nBvflZ0lo1hd0B4+IYrzhbfn6Z8f97zyuzO6hdLq/5u81p7bpPRrBbJ
	1J7yOdfD1dhYOnLv2djvnPV1n9LKydpyGt9mXZSd8/eXEktxRqKhFnNRcSIAPdJ1VLECAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is a part of continuation work from following series
[1] and [2].

1: exynos: Move pmu driver to driver/soc folder and add exynos7 support
   http://www.spinics.net/lists/linux-samsung-soc/msg39797.html from Amit Daniel Kacchap
2: soc: samsung: pmu: split up SoC specific PMU data
   https://lkml.org/lkml/2014/11/30/175 from me

As there were concerns ([3] and [4]) for moving PMU implementation into
"drivers/soc/samsung/" and using it for ARM64 samsung SoCs

3: https://lkml.org/lkml/2014/11/24/322 from Bartlomiej Zolnierkiewicz
4: http://www.spinics.net/lists/linux-samsung-soc/msg39809.html from Kukjin Kim

To address these concerns I posted patch [5] and splitted up SoC specific PMU
configuration data from exynos-pmu driver, since all changes had been
in single patch, size of patch was too large and it failed to appear on
samsung and arm-linux mailing list, but somehow it appeared on LKML.

5: soc: samsung: pmu: split up SoC specific PMU data
   https://lkml.org/lkml/2014/11/30/175

Here is second attempt for the same, in this series I am splitting up SoC specific
PMU configuration data into mach-exynos folder itself, before moving all of them
under drivers/soc/samsung/. Also instead of making all changes in single patch it has been
broken into SoC specific patches to avoid large size of patch. With this approach there will
not be unwanted big churns just after adding exynos-pmu under drivers/soc/samsung.

All these patches are just refactoring to keep minimal changes while moving
exynos-pmu driver under drivers/soc/samsung/. Support for exynos7 PMU can be added
on top of it, in such a manner that for ARM64 build, ARM related SoC's PMU will not
get compiled and thus unnecessary increasing kernel image size.

I have tested it for normal system booting on Exynos3250 and SMDK5250 boards.
I have verified S2R on SMDK5250 after these patches and it's working fine.

These patches have been prepared on top of Kukjin Kim's for-next
having SHA-ID as 1eeec807bf644a0e691026b2fd and on top of my following accepted patch [6],
to avoid conflict in future.

6: ARM: EXYNOS: Remove i2c sys configuration related code
     http://www.spinics.net/lists/linux-samsung-soc/msg40671.html


Amit Daniel Kachhap (1):
  ARM: EXYNOS: Move pmu specific headers under "linux/soc/samsung"

Pankaj Dubey (5):
  ARCH: EXYNOS: split up exynos3250 SoC specific PMU data
  ARCH: EXYNOS: split up exynos4 SoC specific PMU data
  ARCH: EXYNOS: split up exynos5250 SoC specific PMU data
  ARCH: EXYNOS: split up exynos5420 SoC specific PMU data
  drivers: soc: Add support for Exynos PMU driver

 arch/arm/mach-exynos/Kconfig                       |    1 +
 arch/arm/mach-exynos/Makefile                      |    2 +-
 arch/arm/mach-exynos/exynos.c                      |    2 +-
 arch/arm/mach-exynos/mcpm-exynos.c                 |    2 +-
 arch/arm/mach-exynos/platsmp.c                     |    2 +-
 arch/arm/mach-exynos/pm.c                          |    4 +-
 arch/arm/mach-exynos/pmu.c                         | 1005 --------------------
 arch/arm/mach-exynos/suspend.c                     |    4 +-
 drivers/soc/Kconfig                                |    1 +
 drivers/soc/Makefile                               |    1 +
 drivers/soc/samsung/Kconfig                        |   20 +
 drivers/soc/samsung/Makefile                       |    4 +
 drivers/soc/samsung/exynos-pmu.c                   |  148 +++
 drivers/soc/samsung/exynos-pmu.h                   |   52 +
 drivers/soc/samsung/exynos3250-pmu.c               |  175 ++++
 drivers/soc/samsung/exynos4-pmu.c                  |  223 +++++
 drivers/soc/samsung/exynos5250-pmu.c               |  196 ++++
 drivers/soc/samsung/exynos5420-pmu.c               |  297 ++++++
 .../linux/soc/samsung}/exynos-pmu.h                |    0
 .../linux/soc/samsung/exynos-regs-pmu.h            |    0
 20 files changed, 1126 insertions(+), 1013 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/pmu.c
 create mode 100644 drivers/soc/samsung/Kconfig
 create mode 100644 drivers/soc/samsung/Makefile
 create mode 100644 drivers/soc/samsung/exynos-pmu.c
 create mode 100644 drivers/soc/samsung/exynos-pmu.h
 create mode 100644 drivers/soc/samsung/exynos3250-pmu.c
 create mode 100644 drivers/soc/samsung/exynos4-pmu.c
 create mode 100644 drivers/soc/samsung/exynos5250-pmu.c
 create mode 100644 drivers/soc/samsung/exynos5420-pmu.c
 rename {arch/arm/mach-exynos => include/linux/soc/samsung}/exynos-pmu.h (100%)
 rename arch/arm/mach-exynos/regs-pmu.h => include/linux/soc/samsung/exynos-regs-pmu.h (100%)

-- 
2.2.0


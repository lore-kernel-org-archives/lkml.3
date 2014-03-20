Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751280AbaCTEix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 00:38:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56433 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaCTEiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 00:38:50 -0400
X-AuditID: cbfee68f-b7f156d00000276c-65-532a70d9f507
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 0/4] Introduce new Kconfig for Samsung common clock
Date: Thu, 20 Mar 2014 13:55:21 +0900
Message-id: <1395291325-4043-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
References: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t8zI92bBVrBBjdf81hsenyN1eLyrjls
	FjPO72OyWLT1C7sDi8fmJfUefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfH+9xK2gp88Fe3N
	e1kbGJdwdTFyckgImEicuH+ODcIWk7hwbz2QzcUhJLCMUeLzl6mMMEWXf7xjgkgsYpS48KIB
	ymljkvi+fi0TSBWbgK7Ek/dzmUFsEYFsiUuzbrGA2MwC2hKT97awg9jCAm4SOx6sAYuzCKhK
	zHp8H2w1r4C7xIam30A1HEDbFCTmTLIBCXMKeEjs/HkK7AghoJJdh3ayg+yVEPjOJvHr7XJm
	iDkCEt8mH2KB6JWV2HSAGeJoSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IWK84Mbe4NC9dLzk/
	dxMjJGT7dzDePWB9iDEZaNxEZinR5HxgyOeVxBsamxlZmJqYGhuZW5qRJqwkznv/YVKQkEB6
	YklqdmpqQWpRfFFpTmrxIUYmDk6pBsZ2hYups6fl2D1XmcUQ0/0rfNEmzUMTn0Vb6E6ZHVq/
	8XBst/HFr4pLOEJfxuycsL7g0qxta9nUyy9t9Ojcx5fbZp06r8Vq9fW6TS+z3nXl9F68ZKGb
	9i14z45OvYMbPqwxbTC7ptt01EdntWpyZ3XjIqErpgq/tZ98OWywvP1rQZAR36U/KjeVWIoz
	Eg21mIuKEwEEQYm4bwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAd2bBVrBBpfbOS02Pb7GanF51xw2
	ixnn9zFZLNr6hd2BxWPzknqPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8x4/3sJW8FPnor25r2sDYxLuLoYOTkkBEwkLv94xwRhi0lcuLeerYuRi0NI
	YBGjxIUXDUwQThuTxPf1a8Gq2AR0JZ68n8sMYosIZEtcmnWLBcRmFtCWmLy3hR3EFhZwk9jx
	YA1YnEVAVWLW4/tsIDavgLvEhqbfQDUcQNsUJOZMsgEJcwp4SOz8eYoRxBYCKtl1aCf7BEbe
	BYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCI+KZ9A7GVQ0WhxgFOBiVeHhX7NEMFmJN
	LCuuzD3EKMHBrCTCa+2uFSzEm5JYWZValB9fVJqTWnyIMRnoqInMUqLJ+cBozSuJNzQ2MTOy
	NDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRl/fiFaHqJcnT795KmBw9oSn
	genqVPadqnbJFtrxwp3Jt1V4fPsqI9b85Ay0lxRu7V121s6cM6yiofPHvQ+zsxX9pqU42C1Z
	Ipm5jvOUTVCmsv27ux+crlZ9beL3CjV5Xru8zL73zONLOZUiQfW+fdypF2N5c/uYV3ywrlu6
	ONrDWHrJN04lluKMREMt5qLiRAAjaz5VzAIAAA==
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


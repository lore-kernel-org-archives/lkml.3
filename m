Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaEWKZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:25:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17087 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaEWKZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:25:26 -0400
X-AuditID: cbfee68f-b7fef6d000003970-6b-537f221306aa
From: Jaehoon Chung <jh80.chung@samsung.com>
To: linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>
Subject: [PATCH 0/3] mmc: fixed the mmc_of_parse for dwmmc
Date: Fri, 23 May 2014 19:25:18 +0900
Message-id: <1400840721-11050-1-git-send-email-jh80.chung@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWyRsSkRFdYqT7Y4P9CDYsJl7czWsw/co7V
	4savNlaLy7vmsFkc+d/PaDHj/D4mi0Mzky0+3L/IbHF8bbgDp8eCX1tZPO5c28PmcePVQiaP
	vi2rGD0+b5ILYI3isklJzcksSy3St0vgyri0/iZLwQGuirnHu1kaGF+wdzFyckgImEisuHOM
	CcIWk7hwbz1bFyMXh5DAUkaJWU9vsHQxcoAVPWwUA6kREljEKHFuoSNETRuTRNv1EywgCTYB
	HYnt346DDRIRkJX4+ecC2CBmgdVMEkeX/2YGSQgLWEkcXnQdbDOLgKrE6vsrweK8Am4S+zZc
	YIZYpiAxZ5INSK+EQD+7xI63Oxgh6gUkvk0+BHWQrMSmA8wQR0tKHFxxg2UCo+ACRoZVjKKp
	BckFxUnpRcZ6xYm5xaV56XrJ+bmbGIFBfPrfs/4djHcPWB9iTAYaN5FZSjQ5HxgFeSXxhsZm
	RhamJqbGRuaWZqQJK4nz3n+YFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMfVt4rRQs0+P
	jzy88uLrHNkYi63Tw/Sd/0x5+EqZ+WGUdWv4Q8vfrOv7+9+e/PlyUrRGecZ68wufix5vvziz
	5AxHTP8e4enJ0ZoPWa/fmybZofi/ssHoxo4Uj5Pskxml1ro0Vvdnd79pNjm56Pofri5pBxaV
	oNchj+dEmj+aZdHcPFdsYtWBMCWW4oxEQy3mouJEAHQpDPx4AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t9jAV1hpfpgg8175S0mXN7OaDH/yDlW
	ixu/2lgtLu+aw2Zx5H8/o8WM8/uYLA7NTLb4cP8is8XxteEOnB4Lfm1l8bhzbQ+bx41XC5k8
	+rasYvT4vEkugDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJ
	xSdA1y0zB+geJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGpfU3WQoO
	cFXMPd7N0sD4gr2LkYNDQsBE4mGjWBcjJ5ApJnHh3no2EFtIYBGjxLmFjl2MXEB2G5NE2/UT
	LCAJNgEdie3fjjOB2CICshI//1xgAyliFljNJHF0+W9mkISwgJXE4UXX2UFsFgFVidX3V4LF
	eQXcJPZtuMAMsVhBYs4kmwmM3AsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBMfIM6kd
	jCsbLA4xCnAwKvHwPmCqCxZiTSwrrsw9xCjBwawkwntGtj5YiDclsbIqtSg/vqg0J7X4EGMy
	0PKJzFKiyfnA+M0riTc0NjEzsjQyN7QwMjYnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6p
	BsZpAcFcH72tenzdeA8e5Fu5V7krzdLeuFfVJuvWLbekwPUdTxRnPjoVkcx2u7lsj0v3nou9
	X9K5VfP0kpS2KJ0s2bEsMka9YllVYrti0PKnR20kHBpFLJ6KbVZ9ordi7t+7Z49uke7YK9+2
	q+HlvFm766Wd/Y0nx35Zca9ic8D/HbN0yvUjPZVYijMSDbWYi4oTAfbNQ9TVAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set is fixed the dw-mmc controller problem.
dw-mmc controller have the slot, but mmc_of_parse didn't parse the slot sub-node.
So dw-mmc controller didn't work correctly.

Jaehoon Chung (2):
  mmc: dw_mmc: use the __mmc_of_parse to parse the slot node
  ARM: dts: replace the broken-cd property into slot node for dwmmc.

Ludovic Desroches (1):
  mmc: host: add slot argument to mmc_of_parse

 arch/arm/boot/dts/exynos4412-odroidx.dts      |    2 +-
 arch/arm/boot/dts/exynos4412-origen.dts       |    2 +-
 arch/arm/boot/dts/exynos4412-trats2.dts       |    4 ++--
 arch/arm/boot/dts/exynos5250-arndale.dts      |    2 +-
 arch/arm/boot/dts/exynos5250-cros-common.dtsi |    4 ++--
 arch/arm/boot/dts/exynos5250-smdk5250.dts     |    2 +-
 arch/arm/boot/dts/exynos5420-arndale-octa.dts |    2 +-
 arch/arm/boot/dts/rk3066a-bqcurie2.dts        |    2 +-
 arch/arm/boot/dts/socfpga_arria5.dtsi         |    2 +-
 arch/arm/boot/dts/socfpga_cyclone5.dtsi       |    2 +-
 arch/arm/boot/dts/socfpga_vt.dts              |    2 +-
 drivers/mmc/core/host.c                       |   13 +++++++++----
 drivers/mmc/host/dw_mmc.c                     |   25 ++++++-------------------
 include/linux/mmc/host.h                      |   10 +++++++++-
 14 files changed, 37 insertions(+), 37 deletions(-)

-- 
1.7.9.5


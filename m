Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab3I1QZq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 12:25:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31679 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab3I1QZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 12:25:44 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-f9-52470306a981
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kgene.kim@samsung.com
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        devicetree@vger.kernel.org, m.szyprowski@samsung.com,
        t.figa@samsung.com, b.zolnierkie@samsung.com, k.debski@samsung.com,
        s.nawrocki@samsung.com,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: [PATCH 0/3] Samsung: DT: Add Device tree for S5PC110/S5PV210 Boards
Date: Sat, 28 Sep 2013 18:25:27 +0200
Message-id: <1380385530-28522-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t9jQV12Zvcgg9U3OC02zljPajH/yDlW
	i3OvVjJa/Hh9gc2id8FVNotNj6+xWlzeNYfNYsb5fUwWty/zWpxec4rZYu2Ru+wWS69fZLKY
	MH0ti8XhFQeYLA6/aWe1eHWwjcVi/YzXLA6CHmvmrWH0aGnuYfNY8PkKu8fK5V/YPDYvqfc4
	+G4Pk0ffllWMHp83yXlsnBsawBnFZZOSmpNZllqkb5fAlfH/yg2mgtf8FVfOPGNtYPzH08XI
	ySEhYCLx98hJFghbTOLCvfVsXYxcHEIC0xklNve2sUI47UwSjV/eMoNUsQmYS0x8tgmsQ0RA
	UqKp4Q8zSBGzwGlmiafrz4AlhAV8JJZ/+gRmswioStz8cJMNxOYV8JO42PkKap2CxM/LJ9gm
	MHIvYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcrs+kdjCubLA4xCjAwajEw3tghmuQ
	EGtiWXFl7iFGCQ5mJRFe/xluQUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeWpGan
	phakFsFkmTg4pRoYt64Qs2HVsJ679GnMEyev5yLPbxj/j7Necq/c5oCLZtuOaXMPL3cOW6XR
	ZV0mv+iIBNN2Lhnhhs07hb+tSK1t/JD5QU72a7nQQkY/uzXxnSYZ0xqDipaJ3eU8uq/kkk52
	WVUxh3ODvmz8lS0f5zj+uTHpXmPYuZnsRx+3WVrz+d94JLj75t7zSizFGYmGWsxFxYkA9cwo
	31MCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add initial device tree support for mach s5pv210. It provides 
dts for all old board files and add support for new board: 
Tiny210 from FriendlyARM
This patch series was tested on goni, aquila and tiny210.

Missing features:
 - i2s
 - audio
 - cpufreq
 - camera noon010pc30
 - lcd support(still waiting for Common Display Framework) 
 - touchscreen atmel_mxt_ts
Need to be tested:
 - i2c require touchscreen
 - fimd require lcd
 - fimc require camera
 - mfc require CMA
 - spi 

Mateusz Krawczuk (3):
  ARM: s5pv210: Add board file for boot using Device Tree
  ARM: Samsung: DT: Add Device tree for s5pv210
  ARM: Samsung: DT: Add Device tree for S5PC110/S5PV210 Boards

 arch/arm/boot/dts/Makefile              |   6 +
 arch/arm/boot/dts/s5pv210-aquila.dts    | 407 ++++++++++++++++
 arch/arm/boot/dts/s5pv210-goni.dts      | 486 +++++++++++++++++++
 arch/arm/boot/dts/s5pv210-pinctrl.dtsi  | 820 ++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/s5pv210-smdkc110.dts  | 165 +++++++
 arch/arm/boot/dts/s5pv210-smdkv210.dts  | 273 +++++++++++
 arch/arm/boot/dts/s5pv210-tiny210.dts   | 262 ++++++++++
 arch/arm/boot/dts/s5pv210-torbreck.dts  | 157 ++++++
 arch/arm/boot/dts/s5pv210.dtsi          | 498 +++++++++++++++++++
 arch/arm/mach-s5pv210/Kconfig           |  14 +
 arch/arm/mach-s5pv210/Makefile          |   2 +-
 arch/arm/mach-s5pv210/mach-s5pv210-dt.c |  92 ++++
 12 files changed, 3181 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/boot/dts/s5pv210-aquila.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-goni.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-pinctrl.dtsi
 create mode 100644 arch/arm/boot/dts/s5pv210-smdkc110.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-smdkv210.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-tiny210.dts
 create mode 100644 arch/arm/boot/dts/s5pv210-torbreck.dts
 create mode 100644 arch/arm/boot/dts/s5pv210.dtsi
 create mode 100644 arch/arm/mach-s5pv210/mach-s5pv210-dt.c

-- 
1.8.1.2


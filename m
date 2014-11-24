Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaKXNAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:00:20 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:40137 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbaKXNAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:00:16 -0500
X-AuditID: cbfee68f-f791c6d000004834-f8-54732bde8903
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, pankaj.dubey@samsung.com,
        ulf.hansson@linaro.org, khilman@kernel.org, linux-pm@vger.kernel.org,
        geert@linux-m68k.org, rjw@rjwysocki.net, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH RFC v2 00/12] soc: samsung: Modify and enhance power domain
 driver
Date: Mon, 24 Nov 2014 18:22:40 +0530
Message-id: <1416833572-6880-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWyRsSkSveednGIweQ2YYuGqyEW84+cY7V4
	dmsvk0XvgqtsFk83P2ay2PT4GqvF5V1z2Cw+9x5htJhxfh+TxaKtX9gtzpy+xGpx+E07q8Xx
	teEOvB6bVnWyedy5tofN49DhDkaPzUvqPbZcbWfx6NuyitHj8ya5APYoLpuU1JzMstQifbsE
	royDL+sKpslU9L19wdTAeFu0i5GTQ0LAROLq2WvsELaYxIV769m6GLk4hASWMkocu97J2MXI
	AVa0/4E9RHwRo8SiI7sYIZwJTBKr1k5lA+lmEzCW+LlzPztIg4iAt8Tya4ogNcwCq5kktrZ/
	YAKpERYIkWj/9QWsnkVAVWLdm99gm3kF3CTmf3jOBLFMQWLOJBuQXgmBbewS+86uZYKoF5D4
	NvkQC0SNrMSmA8wQR0tKHFxxg2UCo+ACRoZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGIHB
	f/rfs/4djHcPWB9iFOBgVOLhnbG+KESINbGsuDL3EKMp0IaJzFKiyfnAGMsriTc0NjOyMDUx
	NTYytzRTEuddKPUzWEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjG5tZK8sq/VqjOneWDMVq
	JS5TsaUXD988+Dq68ur1ds5n26YxyE77KCuZ6/wzqsltys4Yl9hUvTNFa79EfRWK2+T0+tKT
	pzmvbbqt7ik3Rdxx215yctKJ1448D3YV2HM2aQfu130g5jhR+2mX/FW1VcePThacsyWnus+G
	5avse/Xg6euF5gsrsRRnJBpqMRcVJwIAcqBxt3kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t9jAd172sUhBj+Pclg0XA2xmH/kHKvF
	s1t7mSx6F1xls3i6+TGTxabH11gtLu+aw2bxufcIo8WM8/uYLBZt/cJuceb0JVaLw2/aWS2O
	rw134PXYtKqTzePOtT1sHocOdzB6bF5S77HlajuLR9+WVYwenzfJBbBHNTDaZKQmpqQWKaTm
	JeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdq6RQlphTChQKSCwuVtK3
	wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMOPiyrmCaTEXf2xdMDYy3RbsYOTgkBEwk9j+w72Lk
	BDLFJC7cW8/WxcjFISSwiFFi0ZFdjBDOBCaJVWunsoFUsQkYS/zcuZ8dpFlEwFti+TVFkBpm
	gdVMElvbPzCB1AgLhEi0//oCVs8ioCqx7s1vdhCbV8BNYv6H50wQixUk5kyymcDIvYCRYRWj
	aGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcGw9k9rBuLLB4hCjAAejEg/vh41FIUKsiWXFlbmH
	GCU4mJVEeMXEikOEeFMSK6tSi/Lji0pzUosPMZoCLZ/ILCWanA+M+7ySeENjE3NTY1NLEwsT
	M0slcd4bN3NDhATSE0tSs1NTC1KLYPqYODilGhhbJeczGUdsPCNxJ1aeZV+S1/O/bdnHCpjf
	e+mm391vcMO/K/hf4UurLfYPXM2FxYp3bZh8MEL18tH1LkU12ids53yvL27r+512JcHkNaev
	byPvHT5lnXBOhwnVx6r3HGVm77KNOjZxv+BnES69MNs8A2nLzJKy1NZdcz9Uz7M7I3s0hFlI
	VomlOCPRUIu5qDgRAGlmZq3DAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Posting this series as RFC to get more clarity as lot of power domain related
discussion is happening in mailing lists.

This patch series[1 - 12] performs several implementations as listed below,

1) Converts power domain driver to platform driver.
2) Registers this driver as MFD client driver.
3) Moves them into driver/soc/samsung folder.
4) Add parent power domain parsing code.
5) Updates the reparenting feature to make it more generic.
6) A feature to turn clocks on during pm domain off/on. There can be
   different set of clocks to be turned on. The patches in Rafael's tree allows
   a single list only.
7) Code added to preserve the clocks rates during power domain on/off
   sequence.
8) Restructured the exynos PD on/off handlers and added exynos7 support.

The power domain DT node may look something like,

mfc_pd: power-domain@10044060 {
	compatible = "samsung,exynos4210-pd", "samsung,exynos7-pd-mfc";
	reg = <0x10044060 0x20>;
	pd-parent-clock-names = "tclk0", "pclk0", "clk0";
	pd-parent-clocks = <&clock CLK_FIN_PLL>, <&clock CLK_MOUT_SW_ACLK333>,
		<&clock CLK_MOUT_USER_ACLK333>;
	pd-on-en-clock-names = "clk0", "clk1";
	pd-on-en-clocks = <&clock CLK_IP1>, <&clock CLK_IP2>,
	pd-off-en-clock-names = "clk0", "clk1", "clk3";
	pd-off-en-clocks = <&clock CLK_IP1>, <&clock CLK_IP2>, <&clock CLK_IP3>;
	pd-rate-clock-names = "clk0", "clk1";
	pd-rate-clocks = <&clock CLK_IP1>, <&clock CLK_IP2>,
	parents = <&pd_top>;
	#power-domain-cells = <0>;
};

Changes from v1:
* Removed PM domain notifier features.
* Removed clock save/restore through those notifiers.
* link for v1 is http://www.spinics.net/lists/linux-samsung-soc/msg38442.html.

This patch series depends on exynos pmu patches posted earlier.
http://lkml.org/lkml/2014/11/23/221

Amit Daniel Kachhap (12):
  arm: exynos: Add platform driver support for power domain driver
  soc: exynos: Move exynos power domain file to driver/soc/samsung
    folder
  soc: samsung: exynos-pmu: Register exynos pd driver as a mfd client
  soc: samsung: Re-structure PMU driver to create pd on/off handlers
  soc: samsung: pm_domain: Use unique compatible name for power domain
  driver: soc: exynos-pmu: Add exynos7 power domain on/off ops
  PM / Domains: export pm_genpd_lookup_name
  soc: samsung: pm_domain: Add support for parent power domain
  drivers: soc: pm_domain: Modify the parent clocks bindings
  drivers: soc: samsung: Add support for clock enabling in power domain
  drivers: soc: samsung: Add support for clock rate save/restore in
    power domain
  arm64: Kconfig: Enable PM_GENERIC_DOMAINS for exynos7

 .../bindings/arm/exynos/power_domain.txt           |   45 +-
 arch/arm/mach-exynos/Makefile                      |    1 -
 arch/arm/mach-exynos/pm_domains.c                  |  166 -------
 arch/arm64/Kconfig                                 |    1 +
 drivers/base/power/domain.c                        |    3 +-
 drivers/soc/samsung/Kconfig                        |    9 +
 drivers/soc/samsung/Makefile                       |    3 +-
 drivers/soc/samsung/exynos-pmu.c                   |  185 +++++++
 drivers/soc/samsung/pm_domains.c                   |  510 ++++++++++++++++++++
 include/linux/pm_domain.h                          |    7 +
 include/linux/soc/samsung/exynos-pmu.h             |   15 +
 include/linux/soc/samsung/exynos-regs-pmu.h        |   26 +
 12 files changed, 794 insertions(+), 177 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/pm_domains.c
 create mode 100644 drivers/soc/samsung/pm_domains.c

-- 
1.7.9.5


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab3FLEJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 00:09:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62676 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab3FLEJO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 00:09:14 -0400
X-AuditID: cbfee68e-b7f276d000002279-b2-51b7f468a93e
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <51B7F461.5040405@samsung.com>
Date: Wed, 12 Jun 2013 13:09:05 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, Kukjin Kim <kgene.kim@samsung.com>,
        jonghwa3.lee@samsung.com
Subject: Re: [PATCH V5 00/30] thermal: exynos: Add thermal driver for exynos5440
References: <1370955220-2949-1-git-send-email-amit.daniel@samsung.com>
In-reply-to: <1370955220-2949-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsWyRsSkQDfjy/ZAg4VLRC0aroZY/Ho3k91i
	zf6fTBadZ58wW/QuuMpmcXnXHDaLz71HGC1mnN/HZPHkYR+bA6fHzll32T0W73nJ5NG3ZRWj
	x/Eb25k8Pm+SC2CN4rJJSc3JLEst0rdL4MrYPfUIU8EO24qpZ2YzNTD+NOhi5OSQEDCRmH2u
	nxnCFpO4cG89WxcjF4eQwFJGiek3nrDCFJ1eM5sdIrGIUeLO++lsIAleAUGJH5PvsYDYzALq
	EpPmLWKGsEUk7i38yAZha0ssW/iaGaL5JaPE3/+TWSCatSTeX2hmArFZBFQllv+fyA5iswnI
	Sbxt+sYIYosKhElcnXAcrF5EwFDi+IGlYOcxC7QxSbRvvQm2QVggQOLV1C1gg4QE3CTaH/0D
	a+AUcJe4v+ovK0iDhMAjdonpWzoZIbYJSHybfAioiAMoISux6QDU/5ISB1fcYJnAKD4LyXOz
	kDw3C8lzs5A8t4CRZRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGYPSe/vesbwfjzQPWhxiT
	gdZPZJYSTc4HRn9eSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanF
	hxiZODilGhgN+jhU2A4KMZ2du4p7a9L7t+Xu076ofZB4aKN37ceqpywr0yIePHDtSzin43zn
	olYd0zKtKTstQk0S5O4diryhnBn3+wpT0PrrE2XVdj3d/3eK80d9Q24rkfl2F7fnTXtpezF2
	U9eaZVK2Xgee/X5n5vb42q6397yO1co1lu+rKns3cd9+E6FuJZbijERDLeai4kQAILdiO/QC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jAd2ML9sDDf7f5rZouBpi8evdTHaL
	Nft/Mll0nn3CbNG74CqbxeVdc9gsPvceYbSYcX4fk8WTh31sDpweO2fdZfdYvOclk0ffllWM
	HsdvbGfy+LxJLoA1qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoICWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxpamX0wF
	y2wrpnziamB8btDFyMkhIWAicXrNbHYIW0ziwr31bF2MXBxCAosYJe68n84GkuAVEJT4Mfke
	SxcjBwezgLzEkUvZIGFmAXWJSfMWMUPUv2SU+Pt/MgtEvZbE+wvNTCA2i4CqxPL/E8EWsAnI
	Sbxt+sYIYosKhElcnXAcrF5EwFDi+IGlYIuZBdqYJNq33gRbLCwQIPFq6hawQUICbhLtj/6B
	NXAKuEvcX/WXdQKjwCwk981CuG8WkvsWMDKvYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiO
	8mfSOxhXNVgcYhTgYFTi4T1gtj1QiDWxrLgy9xCjBAezkgivbi5QiDclsbIqtSg/vqg0J7X4
	EGMy0HcTmaVEk/OBCSivJN7Q2MTMyNLI3NDCyNicNGElcd6DrdaBQgLpiSWp2ampBalFMFuY
	ODilGhj1deX7psjKXH5mr/39sU7N1yCedYcUwxj+lzFvkBNTarv7yCSo06zGY3v5u4gH+3Oj
	jiVyVk8tqXpRq1tiumZ9hsEqj9Ysa8dlnLONzioksD29+Kfs+tyTLyqSl3//JXj7oiY34yS7
	Oglumy13ds6pb2Q9mMvXd9BqZYeuePS0t3WHaj82FiixFGckGmoxFxUnAgCBV0f4NgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 06월 11일 21:53, Amit Daniel Kachhap wrote:

> Most of the changes in this version is as per suggestion from Jonghwa Lee. I
> have retained one to one mapping of platform data with TMU instances as the
> TMU's are different devices. In exynos5440 soc there is some register
> sharing across multiple TMU's but in exynos5420 there is no register between
> multiple TMU's, so the current implementation is useful to support both of the
> above.
> 
> This patch uses localized ARCH_HAS_TMU Kconfig option and is a temporary solution
> until a more generic macro ARCH_HAS_BANDGAP is introduced as per discussion in
> the link https://patchwork.kernel.org/patch/2659001/.
> 
> Changes in V5:
> * trip type is passed as platform data.
> * HW trip is allowed only for maximum level.
> * Platform data structure is now abstracted inside 1 more structure to support
>   strong multiple sensor TMU data. 
> 
> Changes in V4:
>  Almost all the changes in this version is as per suggestion from Eduardo.The
>  major ones are listed below,
> * Added kconfig symbol ARCH_HAS_TMU which needs to be enabled by platform. With
>   this change existing symbol EXYNOS_TMU_DATA is not needed.
> * Movement of freq_clip_table from exynos_tmu.h to exynos_thermal_common.h is
>   explained in the commit logs.
> * Wrote all register description documentation.
> * Split 5440 TMU support patch into controller change, configuration data and
>   feature addition patches.
> * Remove all *LINUX_* in the header files.
> * Still regulator enable is kept optional but a TODO: comment is added to fix
>   it later.
> 
> Changes in V3:
> * Added proper dependency of different exynos thermal Kconfig symbols. Basically 3
>  Kconfig can be enabled now and corresponds to tmu driver. exynos common part
>  and exynos configuration data. This issue was raised by Rui Zhang.
> 
> Changes in V2:
> * Separated SOC data from TMU driver. This is as per suggestion from Eduardo.
> * Merged the new file created for exynos5440 TMU controller with the existing
>  TMU controller code.
> * Removed the DT parsing code as now the SOC specific data are cleanly put
>  inside the data specific file.
> * Even the register definations/bitfields are treated as data as there is
>  some variation across SOC's.
> 
> This patchset adds TMU(Thermal management Unit) driver support for
> exynos5440 platform. There are 3 instances of the TMU controllers so
> necessary cleanup/re-structure is done to handle multiple thermal zone.
> 
> Patch (exynos4: Add documentation for Exynos SoC thermal bindings) from
> Lukasz Majewski is already posted to mainline. Adding it here for completeness.
> (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg17817.html)
> 
> Patch (thermal: exynos: Support thermal tripping ) from Jonghwan Choi is
> added here with some changes.
> (https://patchwork.kernel.org/patch/1668371/)
> 
> Patch (thermal: exynos: Support for TMU regulator defined at device tree)
> is a repost of my earlier patch(https://patchwork-mail1.kernel.org/patch/2510771/) 
> and adds regulator support.
> 
> Patch (ARM: dts: Add device tree node for exynos5440 TMU controller) and
> patch (arm: exynos: enable ARCH_HAS_TMU) can be merged through exynos platform
> maintainer as this can cause merge conflict.
> 
> All these patches are based on thermal maintainers git tree,
> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next.
> 
> Amit Daniel Kachhap (29):
>   thermal: exynos: Moving exynos thermal files into samsung directory
>   thermal: exynos: Add ARCH_HAS_TMU config to know the supported soc's
>   thermal: exynos: Remove CPU_THERMAL dependency for using TMU driver
>   thermal: exynos: Bifurcate exynos thermal common and tmu controller
>     code
>   thermal: exynos: Rename exynos_thermal.c to exynos_tmu.c
>   thermal: exynos: Move exynos_thermal.h from include/* to driver/*
>     folder
>   thermal: exynos: Bifurcate exynos tmu driver and configuration data
>   thermal: exynos: Add missing definations and code cleanup
>   thermal: exynos: Add extra entries in the tmu platform data
>   thermal: exynos: Move register definitions from driver to data file
>   thermal: exynos: Support thermal tripping
>   thermal: exynos: Fix to clear only the generated interrupts
>   thermal: exynos: Add support for instance based register/unregister
>   thermal: exynos: Modify private_data to appropriate name driver_data
>   thermal: exynos: Return success even if no cooling data supplied
>   thermal: exynos: Make the zone handling use trip information
>   thermal: exynos: Remove non DT based support
>   thermal: exynos: Add support to handle many instances of TMU
>   thermal: exynos: Add TMU features to check instead of using SOC type
>   thermal: exynos: use device resource management infrastructure
>   thermal: exynos: Add support to access common register for
>     multistance
>   thermal: exynos: Add driver support for exynos5440 TMU sensor
>   thermal: exynos: Add thermal configuration data for exynos5440 TMU
>     sensor
>   thermal: exynos: Fix to set the second point correction value
>   thermal: exynos: Add hardware mode thermal calibration support
>   Documentation: thermal: Explain the exynos thermal driver model
>   thermal: exynos: Support for TMU regulator defined at device tree
>   ARM: dts: Add device tree node for exynos5440 TMU controller
>   arm: exynos: enable ARCH_HAS_TMU
> 
> Lukasz Majewski (1):
>   ARM: dts: thermal: exynos4: Add documentation for Exynos SoC thermal
>     bindings
> 
>  .../devicetree/bindings/thermal/exynos-thermal.txt |   55 +
>  Documentation/thermal/exynos_thermal               |   43 +-
>  arch/arm/boot/dts/exynos5440.dtsi                  |   30 +
>  arch/arm/mach-exynos/Kconfig                       |    5 +
>  drivers/thermal/Kconfig                            |   14 +-
>  drivers/thermal/Makefile                           |    2 +-
>  drivers/thermal/exynos_thermal.c                   | 1058 --------------------
>  drivers/thermal/samsung/Kconfig                    |   21 +
>  drivers/thermal/samsung/Makefile                   |    7 +
>  drivers/thermal/samsung/exynos_thermal_common.c    |  413 ++++++++
>  drivers/thermal/samsung/exynos_thermal_common.h    |  106 ++
>  drivers/thermal/samsung/exynos_tmu.c               |  750 ++++++++++++++
>  drivers/thermal/samsung/exynos_tmu.h               |  307 ++++++
>  drivers/thermal/samsung/exynos_tmu_data.c          |  250 +++++
>  drivers/thermal/samsung/exynos_tmu_data.h          |  155 +++
>  include/linux/platform_data/exynos_thermal.h       |  119 ---
>  16 files changed, 2140 insertions(+), 1195 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/thermal/exynos-thermal.txt
>  delete mode 100644 drivers/thermal/exynos_thermal.c
>  create mode 100644 drivers/thermal/samsung/Kconfig
>  create mode 100644 drivers/thermal/samsung/Makefile
>  create mode 100644 drivers/thermal/samsung/exynos_thermal_common.c
>  create mode 100644 drivers/thermal/samsung/exynos_thermal_common.h
>  create mode 100644 drivers/thermal/samsung/exynos_tmu.c
>  create mode 100644 drivers/thermal/samsung/exynos_tmu.h
>  create mode 100644 drivers/thermal/samsung/exynos_tmu_data.c
>  create mode 100644 drivers/thermal/samsung/exynos_tmu_data.h
>  delete mode 100644 include/linux/platform_data/exynos_thermal.h
> 


Looks good to me.

Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 



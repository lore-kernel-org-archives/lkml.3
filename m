Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbbASAvD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 19:51:03 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:51009 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbbASAvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 19:51:00 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-10-54bc54f2db25
Message-id: <54BC54F2.8090001@samsung.com>
Date: Mon, 19 Jan 2015 09:50:58 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        b.zolnierkie@samsung.com, robh+dt@kernel.org, inki.dae@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v4 0/9] devfreq: Add generic exynos memory-bus frequency
 driver
References: <1421286657-4720-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1421286657-4720-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWyRsSkSPdTyJ4Qg1l7VSwer1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWq3b9YXQQ8Fgzbw2jx85Zd9k9Fu95yeSxaVUnm8fmJfUefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAlXH5xBumgmkqFd9mHGFtYGyS6WLk5JAQMJE4eXYjI4QtJnHh
	3nq2LkYuDiGBpYwSG7qfMsMUHWmbxQJiCwlMZ5RY02wBUfSaUeLkx61gCV4BLYmvd+ewgtgs
	AqoSK2YvBrPZgOL7X9xgA7FFBcIkVk6/AlUvKPFj8j0wW0RAT6Lz2B52kKHMAt3MEq+3PGAC
	SQgLhEqcOvGbGWKzi8Squ5PBTuUUcJXo+bWfHcRmFtCR2N86jQ3ClpfYvOYtM8ggCYGZHBLX
	t+xlgbhIQOLb5ENANgdQQlZi0wGozyQlDq64wTKBUWwWkptmIRk7C8nYBYzMqxhFUwuSC4qT
	0otM9IoTc4tL89L1kvNzNzECY/z0v2cTdjDeO2B9iFGAg1GJh3eD754QIdbEsuLK3EOMpkBX
	TGSWEk3OByaSvJJ4Q2MzIwtTE1NjI3NLMyVx3tdSP4OFBNITS1KzU1MLUovii0pzUosPMTJx
	cEo1ME57vOOQcHKKo3jh1ltJ7iU6vAWy5vVTbz1Q4sh56lxjOX/bpbT2r/tVnfcv0L91TUlg
	+7EfUWWTT7kcSVMPrrrO2DvdSW0nb0BDu+cajRdfsx5Hip/gc71w6GOIwp/Kukk1ua+rT80M
	V60uPPNm+XyHU7Kzku5v2utkvtNk5olCjvob54/rzFViKc5INNRiLipOBADFg8QN7AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jQd1PIXtCDBatlrZ4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMyyfeMBVMU6n4NuMI
	awNjk0wXIyeHhICJxJG2WSwQtpjEhXvr2UBsIYHpjBJrmi26GLmA7NeMEic/bgUr4hXQkvh6
	dw4riM0ioCqxYvZiMJsNKL7/xQ2wZlGBMImV069A1QtK/Jh8D8wWEdCT6Dy2hx1kKLNAN7PE
	6y0PmEASwgKhEqdO/GaG2OwiseruZEYQm1PAVaLn1352EJtZQEdif+s0NghbXmLzmrfMExgF
	ZiHZMQtJ2SwkZQsYmVcxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBCeQZ1I7GFc2WBxiFOBg
	VOLh5QjYEyLEmlhWXJl7iFGCg1lJhFdGDyjEm5JYWZValB9fVJqTWnyI0RQYBBOZpUST84HJ
	La8k3tDYxMzI0sjc0MLI2FxJnFfJvi1ESCA9sSQ1OzW1ILUIpo+Jg1OqgTE+9fLzqkVf5Rbf
	nZQ5/ezOPUuPHLwQX5mUq/Lwx1aV8Cf7nB7VpadfC/jvz8g2y/RQq998loUPj2efS5t17uCj
	iRcE+S6zbwgPePckS3jhx9T+aTaSyeJNR6buWlf7btsXvx8293Nc331r723vunJx8qrnd9fn
	H2QyrkxdnzknoSk77efel78klFiKMxINtZiLihMB6dzsbjYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Myungjoo and Kukjin,

Could you please review this patchset?

Best Regards,
Chanwoo Choi

On 01/15/2015 10:50 AM, Chanwoo Choi wrote:
> This patch-set adds the generic exynos bus frequency driver for memory bus
> with DEVFREQ framework. The Samsung Exynos SoCs have the common architecture
> for memory bus between DRAM memory and MMC/sub IP in SoC. This driver can
> support the memory bus frequency driver for Exynos SoCs.
> 
> Each memory bus block has a clock for memory bus speed and frequency
> table which is changed according to the utilization of memory bus on runtime.
> And then each memory bus group has the one more memory bus blocks and
> OPP table (including frequency and voltage), regulator, devfreq-event
> devices.
> 
> There are a little difference about the number of memory bus because each Exynos
> SoC have the different sub-IP and different memory bus speed. In spite of this
> difference among Exynos SoCs, we can support almost Exynos SoC by adding
> unique data of memory bus to devicetree file.
> 
> Depend on:
> - [PATCHv8 0/9] devfreq: Add devfreq-event class to provide raw data for devfreq device
>   : https://lkml.org/lkml/2015/1/7/795
> 
> Changelog:
> 
> Changes from v3:
> (https://lkml.org/lkml/2015/1/7/872)
> - Change the driver name and path by comment
>   : drivers/devfreq/exynos-busfreq.c -> drivers/devfreq/exynos/exynos-bus.c
> - Disable regulator when entering suspend state in exynos-bus.c
>   and enable it after wake-up from suspend state.
> - Add 'exynos,saturation-ratio' property to calibrate the performance count
>   against cycle count.
> - Add new patch to remove unused old driver
>   : drivers/devfreq/exynos/exynos4_bus.{c|h}
> - Clean-up code for minor issue
> - Add acked tag by Myungjoo Ham (DEVFREQ maintainer)
> 
> Changes from v2:
> (https://lkml.org/lkml/2014/12/31/2)
> - Support the memory bus frequency feature for Exynos3250-based Monk board
> - Fix build warning about variable uninitialized
> 
> Changes from v1:
> (https://lkml.org/lkml/2014/12/23/178)
> - This patchset is rebased on v3.19-rc2.
> - Fix bug after wake-up from suspend state. If devfreq device fail to get event,
>   exynos-busfreq retry to set the event for starting.
> - Add memory bus group of Exynos4x12/Exynos4210
> - Add divider clock id for Exynos4 memory bus frequency
> - Support memory bus frequency driver on Exynos4412-based TRATS2 board
> - This patch-set has the dependency on following patch-set[1]:
>   [1] [PATCHv6 0/9] devfreq: Add devfreq-event class to provide raw data for devfreq device
>   : https://lkml.org/lkml/2014/12/28/139
> 
> Chanwoo Choi (9):
>   devfreq: exynos: Add generic exynos memory bus frequency driver
>   devfreq: exynos: Add documentation for generic exynos memory bus frequency driver
>   ARM: dts: Add memory bus node for Exynos3250
>   clk: samsung: exynos4: Add divider clock id for memory bus frequency
>   ARM: dts: Add memory bus node for Exynos4x12
>   ARM: dts: Add memory bus node for Exynos4210
>   ARM: dts: Add the support for exynos busfreq on Exynos3250-based Rinato/Monk board
>   ARM: dts: Add the support for exynos busfreq on Exynos4412-based TRATS2 board
>   devfreq: exynos: Remove unused exynos4 memory busfreq driver
> 
>  .../devicetree/bindings/devfreq/exynos-bus.txt     |  188 ++++
>  arch/arm/boot/dts/exynos3250-monk.dts              |   12 +
>  arch/arm/boot/dts/exynos3250-rinato.dts            |   12 +
>  arch/arm/boot/dts/exynos3250.dtsi                  |  125 +++
>  arch/arm/boot/dts/exynos4210.dtsi                  |   93 ++
>  arch/arm/boot/dts/exynos4412-trats2.dts            |   12 +
>  arch/arm/boot/dts/exynos4x12.dtsi                  |  121 +++
>  drivers/clk/samsung/clk-exynos4.c                  |   10 +-
>  drivers/devfreq/Kconfig                            |   17 +-
>  drivers/devfreq/Makefile                           |    1 +
>  drivers/devfreq/exynos/Makefile                    |    2 +-
>  drivers/devfreq/exynos/exynos-bus.c                |  598 +++++++++++
>  drivers/devfreq/exynos/exynos4_bus.c               | 1055 --------------------
>  drivers/devfreq/exynos/exynos4_bus.h               |  110 --
>  include/dt-bindings/clock/exynos4.h                |    7 +-
>  15 files changed, 1184 insertions(+), 1179 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/devfreq/exynos-bus.txt
>  create mode 100644 drivers/devfreq/exynos/exynos-bus.c
>  delete mode 100644 drivers/devfreq/exynos/exynos4_bus.c
>  delete mode 100644 drivers/devfreq/exynos/exynos4_bus.h
> 


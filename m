Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbbAFCAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 21:00:36 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:9439 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbbAFCAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 21:00:31 -0500
X-AuditID: cbfee68e-f79b46d000002b74-7d-54ab41bc7df7
Message-id: <54AB41BB.2040607@samsung.com>
Date: Tue, 06 Jan 2015 11:00:27 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?UTF-8?B?6rmA6rWt7KeE?= <kgene@kernel.org>
Subject: Re: [PATCHv6 0/9] devfreq: Add devfreq-event class to provide raw data
 for devfreq device
References: <1419811453-16160-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1419811453-16160-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsWyRsSkSHeP4+oQg1MTFCwer1nMZHH9y3NW
	i/lHzrFaTLo/gcXi9QtDi94FV9ks+h+/ZrY42/SG3WLT42usFpd3zWGz+Nx7hNFixvl9TBZL
	r19ksrjduILN4vGKt+wWq3b9YXQQ8Fgzbw2jx85Zd9k9Fu95yeSxaVUnm8fmJfUefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAlXF33Xu2gi7PijkLVrI1MB606mLk5JAQMJGYvm85K4QtJnHh
	3nq2LkYuDiGBpYwSp5dcZoEp2rdyKyNEYjqjxLaDu5khnNeMEovWXWEDqeIV0JI48+AZI4jN
	IqAqse78HLA4G1B8/4sbYLaoQJjEyulXWCDqBSV+TL4HZosImEvsWvoTbDWzwCJmiT8T14Ml
	hAVSJJZ8XAJ2n5CAq8T5/wfBbE4BN4k9J24wg9jMAuoSk+YtgrLlJTaveQt2nYTATA6J2wv3
	MkFcJCDxbfIhoKEcQAlZiU0HmCFek5Q4uOIGywRGsVlIbpqFZOwsJGMXMDKvYhRNLUguKE5K
	LzLSK07MLS7NS9dLzs/dxAiM8tP/nvXtYLx5wPoQowAHoxIPr8eJlSFCrIllxZW5hxhNga6Y
	yCwlmpwPTCV5JfGGxmZGFqYmpsZG5pZmSuK8CVI/g4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFw
	SjUwuuT9j/uy9WOx1zOJU24X1sT3xZ9KTZhdMK/apaTdwcV54RzlHZLS3rpPIu+e6Vu7vfSL
	y69/S0Tnzvg0o+RmZptI2dR/rUv4qpfNMvsXc+5f9LX3jg1LPP9p/EvzYz0uWsrwvW7FnDqH
	uGUTvNz7+Gcv5PJtPMN0VSxGJdltd+umcqnt4QErlFiKMxINtZiLihMBjBfvSO0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jQd09jqtDDM7uErV4vGYxk8X1L89Z
	LeYfOcdqMen+BBaL1y8MLXoXXGWz6H/8mtnibNMbdotNj6+xWlzeNYfN4nPvEUaLGef3MVks
	vX6RyeJ24wo2i8cr3rJbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMu+vesxV0eVbMWbCS
	rYHxoFUXIyeHhICJxL6VWxkhbDGJC/fWs3UxcnEICUxnlNh2cDczhPOaUWLRuitsIFW8AloS
	Zx48A+tgEVCVWHd+DlicDSi+/8UNMFtUIExi5fQrLBD1ghI/Jt8Ds0UEzCV2Lf0JtoFZYBGz
	xJ+J68ESwgIpEks+LmEFsYUEXCXO/z8IZnMKuEnsOXGDGcRmFlCXmDRvEZQtL7F5zVvmCYwC
	s5DsmIWkbBaSsgWMzKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxglPIM6kdjCsbLA4xCnAw
	KvHwepxYGSLEmlhWXJl7iFGCg1lJhHfH51UhQrwpiZVVqUX58UWlOanFhxhNgUEwkVlKNDkf
	mN7ySuINjU3MjCyNzA0tjIzNlcR5lezbQoQE0hNLUrNTUwtSi2D6mDg4pRoYk0xPZv5fcE0j
	PFU3zORxgEhNsmFiZufG2Ihr357tbPU526Suf6ghjZen3T2n/Wvq8ct+vw91Zx/hCgv92WB6
	3eTvKhde1zdbp2z4FuVbcSaSMZ/jfKFp7twaoStarN9rXx953B/umJ3hYOa7WN3rwwzplYu0
	96yZtd5mys0fMufqnmqmBxgpsRRnJBpqMRcVJwIAlJtE5DcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Genlty Ping.

Best Regards,
Chanwoo Choi

On 12/29/2014 09:04 AM, Chanwoo Choi wrote:
> This patchset add new devfreq_event class to provide raw data to determine
> current utilization of device  which is used for devfreq governor.
> 
> [Description of devfreq-event class]
> This patchset add new devfreq_event class for devfreq_event device which provide
> raw data (e.g., memory bus utilization/GPU utilization). This raw data from
> devfreq_event data would be used for the governor of devfreq subsystem.
> - devfreq_event device : Provide raw data for governor of existing devfreq device
> - devfreq device       : Monitor device state and change frequency/voltage of device
>                          using the raw data from devfreq_event device
> 
> The devfreq subsystem support generic DVFS(Dynamic Voltage/Frequency Scaling)
> for Non-CPU Devices. The devfreq device would dertermine current device state
> using various governor (e.g., ondemand, performance, powersave). After completed
> determination of system state, devfreq device would change the frequency/voltage
> of devfreq device according to the result of governor.
> 
> But, devfreq governor must need basic data which indicates current device state.
> Existing devfreq subsystem only consider devfreq device which check current system
> state and determine proper system state using basic data. There is no subsystem
> for device providing basic data to devfreq device.
> 
> The devfreq subsystem must need devfreq_event device(data-provider device) for
> existing devfreq device. So, this patch add new devfreq_event class for
> devfreq_event device which read various basic data(e.g, memory bus utilization,
> GPU utilization) and provide measured data to existing devfreq device through
> standard APIs of devfreq_event class.
> 
> The following description explains the feature of two kind of devfreq class:
> - devfreq class (existing)
>  : devfreq consumer device use raw data from devfreq_event device for
>    determining proper current system state and change voltage/frequency
>    dynamically using various governors.
> - devfreq_event class (new)
>  : Provide measured raw data to devfreq device for governor
> 
> Also, the devfreq-event device would support various type event as following:
>  : DEVFREQ_EVENT_TYPE_RAW_DATA
>  : DEVFREQ_EVENT_TYPE_UTILIZATION
>  : DEVFREQ_EVENT_TYPE_BANDWIDTH
>  : DEVFREQ_EVENT_TYPE_LATENCY
> 
> [For example]
> If board dts includes PPMU_DMC0/DMC1/LEFTBUS/RIGHTBUS event node,
> would show following sysfs entry. Also devfreq driver(e.g., exynos4_bus.c)
> can get the instance of devfreq-event device by using provided API and then
> get raw data which reflect the current state of device.
> 
> -sh-3.2# cd /sys/class/devfreq-event/
> -sh-3.2# ls -al
> total 0
> drwxr-xr-x  2 root root 0 Jan  9 16:47 .
> drwxr-xr-x 37 root root 0 Jan  9 16:47 ..
> lrwxrwxrwx  1 root root 0 Jan  9 16:47 event.0 -> ../../devices/soc/106a0000.ppmu_dmc0/devfreq-event/event.0
> lrwxrwxrwx  1 root root 0 Jan  9 16:47 event.1 -> ../../devices/soc/106b0000.ppmu_dmc1/devfreq-event/event.1
> lrwxrwxrwx  1 root root 0 Jan  9 16:47 event.2 -> ../../devices/soc/112a0000.ppmu_rightbus/devfreq-event/event.2
> lrwxrwxrwx  1 root root 0 Jan  9 16:47 event.3 -> ../../devices/soc/116a0000.ppmu_leftbus0/devfreq-event/event.3
> 
> Changes from v5:
> - Rebase these patch-set on v3.19-rc1 and Test it.
> 1. exynos-ppmu.c
> - Change the error value when of_iomap() fail to map the memory
> - Remove owner setting of platform_driver
> - Add exynos_ppmu_disable() function
> 2. exynos dts file
> - Add PPMU node to Exynos3250-based Monk board
> - Remove ppmu_cpu node on Exynos4412-based TRATS2 board and add ppmu_leftbus/rightbus node
> 
> Changes from v4:
> 1. devfreq-event class driver
> - Add devfreq_event_get_edev_count() function
> - Modify the simple description of devfreq-event framework in devfreq-event.c
> - Minimize the usage range of global lock usage in devfreq_event_add_edev()
> - Remove '_is_enabled()' function pointer in devfreq_event_ops structure
> - Add separte CONFIG_PM_DEVFREQ_EVENT configuration
> - Add new devfreq-event.h header file including devfreq-event helper functions
> 2. exynos dts file
> - Add new patch to support PPMU with DEVFREQ-event on Exynos4412-based TRATS2
> 
> Changes from v3:
> 1. devfreq-event class driver
> - Fix return value of devfreq_event_get_event()
> - Add new structure devfreq_event_data for devfreq_event_get_event()
> - Modify the prototype of devfreq_event_get_event() function
> - Call of_node_put after calling of_parse_phandle() to decrement refcount
> 2. exynos-ppmu driver
> - Modify usage of devfreq_event_get_event() function
>   according to new prototype of this funciton
> - Add the additional description to exynos-ppmu.txt how to add PPMU node
>   in board dts file
> - Use 'PPMU_EVENT' macro to remove duplicate codes
> - Add the support of PPMU for Exynos5260
> 3. exynos dts file
> - Add missing PPMU_FSYS node to exynos3250.dtsi
> - Fix 'ppmu_mfc_l' node name as 'ppmu_mfc' because exynos3250 has only one MFC IP.
> - Add missing PPMU_ACP/G3D to exynos4.dtsi
> 4. etc
> - Fix wrong abbreviation of PPMU (PPMU :Platform Performance Monitoring Unit)
> - Add new patch to support the PPMU of Exynos5260 SoC
> 
> Changes from v2:
> 1. devfreq-event class driver
> - Rename all the helper functions of devfreq-event device
> - Add devfreq_event_remove_edev() instead of devfreq_put_event_dev()
> - Add devfreq_event_release_edev() to initialize it before put device
> - Add the detailed description of devfreq-event API
> - Add the attributes of devfreq-event class (enable_count)
> - Check the overflow about event/total_event data in devfreq_event_get_event()
> - Remove the 'exclusive flag' feature
> - Set set_event()/get_event() functions as mandary
> - Add missing of_node_put() call
> - Change variable type of 'get_event()' funciton from 'int' to 'u64'
> 2. exynos-ppmu driver
> - Remove un-used field (struct devfreq)
> - Use 'of_get_child_by_name()' instead of 'of_find_node_by_name()'
> - Add missing of_node_put() call
> - Fix wrong clock control
> - Use devfreq_event_remove_edev() instead of devfreq_remove_device()
> - Add the documentation for exynos-ppmu driver
> - Remove 'enable/disable/is_enabled/reset' function of exynos-ppmu driver
> 3. exynos3250-rinato.dts
> - Add ppmu_{leftbus|rightbus} dt node and remove ppmu_cpu dt node
> 
> Changes from v1:
> - Code clean
> - Add the description of devfreq-event structure
> - Add 'is_enabled' function to devfreq_event_ops structure
> - Add 'enable_count' field to devfreq_event_dev structure
> - Check whether devfreq-event device is enabled or not
>   during calling devfreq_event API
> - Define the type of devfreq-event device as following
>   : DEVFREQ_EVENT_TYPE_RAW_DATA
>   : DEVFREQ_EVENT_TYPE_UTILIZATION
>   : DEVFREQ_EVENT_TYPE_BANDWIDTH
>   : DEVFREQ_EVENT_TYPE_LATENCY
> - Add the exclusive feature of devfreq-event device.
>   If devfreq-event device is used on only on devfreq driver,
>   should used 'devfreq_enable_event_dev_exclusive()' function
> - Add new patch6 for test on Exynos3250-based Rinato board
> 
> Chanwoo Choi (9):
>   devfreq: event: Add new devfreq_event class to provide basic data for devfreq governor
>   devfreq: event: Add the list of supported devfreq-event type
>   devfreq: event: Add exynos-ppmu devfreq-event driver
>   devfreq: event: Add documentation for exynos-ppmu devfreq-event driver
>   ARM: dts: Add PPMU dt node for Exynos3250 SoC
>   ARM: dts: Add PPMU dt node for Exynos4 SoCs
>   ARM: dts: Add PPMU dt node for Exynos5260 SoC
>   ARM: dts: exynos: Add PPMU node to Exynos3250-based Rinato/Monk board
>   ARM: dts: exynos: Add PPMU node for Exynos4412-based TRATS2 board
> 
>  .../bindings/devfreq/event/exynos-ppmu.txt         | 110 +++++
>  arch/arm/boot/dts/exynos3250-monk.dts              |  40 ++
>  arch/arm/boot/dts/exynos3250-rinato.dts            |  40 ++
>  arch/arm/boot/dts/exynos3250.dtsi                  |  74 +++
>  arch/arm/boot/dts/exynos4.dtsi                     | 108 +++++
>  arch/arm/boot/dts/exynos4210.dtsi                  |   8 +
>  arch/arm/boot/dts/exynos4412-trats2.dts            |  40 ++
>  arch/arm/boot/dts/exynos5260.dtsi                  |  90 ++++
>  drivers/devfreq/Kconfig                            |   2 +
>  drivers/devfreq/Makefile                           |   6 +-
>  drivers/devfreq/devfreq-event.c                    | 510 +++++++++++++++++++++
>  drivers/devfreq/event/Kconfig                      |  25 +
>  drivers/devfreq/event/Makefile                     |   2 +
>  drivers/devfreq/event/exynos-ppmu.c                | 410 +++++++++++++++++
>  include/linux/devfreq-event.h                      | 189 ++++++++
>  15 files changed, 1653 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
>  create mode 100644 drivers/devfreq/devfreq-event.c
>  create mode 100644 drivers/devfreq/event/Kconfig
>  create mode 100644 drivers/devfreq/event/Makefile
>  create mode 100644 drivers/devfreq/event/exynos-ppmu.c
>  create mode 100644 include/linux/devfreq-event.h
> 


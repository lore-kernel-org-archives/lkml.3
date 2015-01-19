Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbbASAuf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 19:50:35 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:49285 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbbASAud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 19:50:33 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-8f-54bc54d6e718
Message-id: <54BC54D5.80104@samsung.com>
Date: Mon, 19 Jan 2015 09:50:29 +0900
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
Subject: Re: [PATCHv8 0/9] devfreq: Add devfreq-event class to provide raw data
 for devfreq device
References: <1421066097-26237-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1421066097-26237-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsWyRsSkRPdayJ4Qg+VvZC0er1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWq3b9YXQQ8Fgzbw2jx85Zd9k9Fu95yeSxaVUnm8fmJfUefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAldH9VKvghG3F7Z372BsYZxp2MXJySAiYSPQu3MACYYtJXLi3
	nq2LkYtDSGApo8TpJatYYYpOXnnCDpGYzijRcHsnI4TzmlHi/cmvYFW8AhoSm+/dBrNZBFQl
	nhx/yghiswloSex/cYMNxBYVCJNYOf0KC0S9oMSPyffAbBEBPYnOY3vANjALdDNLvN7ygAkk
	ISyQIvH3xHHmLkYOoG2uEjfW14OEOQXcJN7tXgM2k1lAR2J/6zQoW15i85q3zCBzJATmckh8
	XjwX6iABiW+TD7GAzJEQkJXYdIAZ4jNJiYMrbrBMYBSbheSkWUjGzkIydgEj8ypG0dSC5ILi
	pPQiE73ixNzi0rx0veT83E2MwAg//e/ZhB2M9w5YH2IU4GBU4uHd4LsnRIg1say4MvcQoynQ
	FROZpUST84FpJK8k3tDYzMjC1MTU2Mjc0kxJnPe11M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xM
	HJxSDYxKxctTJ8e4LH7G8SQpr6evt1VXZcuJzVMnbZi2U/LjpTYxhmvmp/9PuHf7zc+HSva5
	3VJWkpIWedPOXLN5WdD4SLH96YPDfTcXbqr+6P98zzzboJ5aR1U9X4eFvzYGPza98nGjzaYr
	RTaBa1pCmrjv9NnPuVrP+dtARf3OH6UlzuIFpdMr8o8osRRnJBpqMRcVJwIAoP7xG+sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jQd1rIXtCDH4eFLZ4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM7qdaBSdsK27v3Mfe
	wDjTsIuRk0NCwETi5JUn7BC2mMSFe+vZuhi5OIQEpjNKNNzeyQjhvGaUeH/yKytIFa+AhsTm
	e7fBbBYBVYknx58ygthsAloS+1/cYAOxRQXCJFZOv8ICUS8o8WPyPTBbREBPovPYHnaQocwC
	3cwSr7c8YAJJCAukSPw9cZy5i5EDaJurxI319SBhTgE3iXe714DNZBbQkdjfOg3KlpfYvOYt
	8wRGgVlIVsxCUjYLSdkCRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHp45nUDsaVDRaH
	GAU4GJV4eDkC9oQIsSaWFVfmHmKU4GBWEuGV0QMK8aYkVlalFuXHF5XmpBYfYjQFhsBEZinR
	5HxgassriTc0NjEzsjQyN7QwMjZXEudVsm8LERJITyxJzU5NLUgtgulj4uCUamCcqDBL+19Q
	vfFn/vs5YZGqP1NNz5j8W/LiyNP8JSyKb4u4yy6bqn1pmTpRSMwnwYuZ0aNqo+6TMO4dEwqL
	X6noPtj3cOerpQoPZ+h6bq6s/Kxaua8g2mHb5uVG6onzFJ1Dd1+Iub3tsYLepN9rI/7I3pPT
	u3ixKSOgeHf305Tk350CpjOOnCtXYinOSDTUYi4qTgQAqiJqTDUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Myungjoo and Kukjin,

Could you please review this patchset?

The some patch of this patchset received the acked message
by Myungjoo Ham (DEVFREQ maintainer). But, this patchset must
need to review. I'd like to merge this patch in next kernel (3.20).

Best Regards,
Chanwoo Choi

On 01/12/2015 09:34 PM, Chanwoo Choi wrote:
> This patchset add new devfreq_event class to provide raw data to determine
> current utilization of device  which is used for devfreq governor.
> 
> The following description explains the feature of two kind of devfreq class:
> - devfreq class (existing)
>  : devfreq consumer device use raw data from devfreq_event device for
>    determining proper current system state and change voltage/frequency
>    dynamically using various governors.
> - devfreq_event class (new)
>  : Provide measured raw data to devfreq device for governor
> 
> ---------
> Changelog:
> 
> Changes from v7:
> (https://lkml.org/lkml/2015/1/7/795)
> - Use EXPORT_SYMBOL_GPL macro instead of EXPORT_SYMBOL
> - Fix the binding document of exynos-ppmu.c driver
> - Drop the devfreq-event type patch because it isnt' clear
> - Fix bug of devfreq_event_add_edev() when fail to execute device_register()
> - Modify resource free operation on following functions:
>   : devfreq_event_remove_edev()
>   : devfreq_event_release_edev()
> 
> Changes from v6:
> (https://lkml.org/lkml/2014/12/28/139)
> - This patchset is based on v3.19-rc3.
> 1. devfreq-event class driver
> - Fix build break if devfreq-event framework is off
> - Add resource-managed function for devfreq-event device
> : devm_devfreq_event_add_edev()
> : devm_devfreq_event_remove_edev()
> 
> Changes from v5:
> (https://lkml.org/lkml/2014/12/22/527)
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
> (https://lkml.org/lkml/2014/12/16/511)
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
> (https://lkml.org/lkml/2014/12/12/219)
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
> (https://lkml.org/lkml/2014/12/9/304)
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
> (https://lkml.org/lkml/2014/9/5/11)
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
>   devfreq: event: Add resource-managed function for devfreq-event device
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
>  drivers/devfreq/devfreq-event.c                    | 511 +++++++++++++++++++++
>  drivers/devfreq/event/Kconfig                      |  25 +
>  drivers/devfreq/event/Makefile                     |   2 +
>  drivers/devfreq/event/exynos-ppmu.c                | 398 ++++++++++++++++
>  include/linux/devfreq-event.h                      | 186 ++++++++
>  15 files changed, 1639 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/devfreq/event/exynos-ppmu.txt
>  create mode 100644 drivers/devfreq/devfreq-event.c
>  create mode 100644 drivers/devfreq/event/Kconfig
>  create mode 100644 drivers/devfreq/event/Makefile
>  create mode 100644 drivers/devfreq/event/exynos-ppmu.c
>  create mode 100644 include/linux/devfreq-event.h
> 


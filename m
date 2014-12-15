Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbaLOM2f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:28:35 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:56142 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaLOM2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 07:28:32 -0500
Date: Mon, 15 Dec 2014 12:28:26 +0000
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: kernel@stlinux.com, tglx@linutronix.de, jason@lakedaemon.net,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v2 0/8] irqchip: New driver for ST's SysCfg controlled
 IRQs
Message-ID: <20141215122826.GB13885@x1>
References: <1416932705-16880-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416932705-16880-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason, would you like me to send this set again?

> This driver enables IRQs which are controlled using System Configuration
> registers.  Without it Performance Monitoring, Core Sight Tracing and some
> L2 Caches will fail to function.
> 
> v1 => v2:
>  - Fixed up Jason's review comments
> 
> Lee Jones (8):
>   dt: bindings: Supply shared ST IRQ defines
>   irqchip: Supply new driver for STi based devices
>   irqchip: irq-st: Add documentation for STi based syscfg IRQs
>   ARM: STi: STiH416: Enable Cortex-A9 PMU support
>   ARM: STi: STiH416: Enable PMU IRQs
>   ARM: STi: STiH407: Enable Cortex-A9 PMU support
>   ARM: STi: STiH407: Enable PMU IRQs
>   ARM: STI: Ensure requested STi's SysCfg Controlled IRQs are enabled at
>     boot
> 
>  .../interrupt-controller/st,sti-irq-syscfg.txt     |  35 ++++
>  arch/arm/boot/dts/stih407.dtsi                     |  16 ++
>  arch/arm/boot/dts/stih416.dtsi                     |  16 ++
>  arch/arm/mach-sti/Kconfig                          |   1 +
>  drivers/irqchip/Kconfig                            |   7 +
>  drivers/irqchip/Makefile                           |   1 +
>  drivers/irqchip/irq-st.c                           | 208 +++++++++++++++++++++
>  include/dt-bindings/interrupt-controller/irq-st.h  |  30 +++
>  8 files changed, 314 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/interrupt-controller/st,sti-irq-syscfg.txt
>  create mode 100644 drivers/irqchip/irq-st.c
>  create mode 100644 include/dt-bindings/interrupt-controller/irq-st.h
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

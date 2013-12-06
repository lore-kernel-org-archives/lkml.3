Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532Ab3LFJJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:09:33 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:53522 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab3LFJJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:09:23 -0500
Date: Fri, 6 Dec 2013 09:09:15 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Milo Kim <milo.kim@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pwm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH RESEND v5 0/4] LP3943 MFD driver for a GPIO expander and
 a PWM generator
Message-ID: <20131206090915.GA12491@lee--X1>
References: <1386296324-23039-1-git-send-email-milo.kim@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386296324-23039-1-git-send-email-milo.kim@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Dec 2013, Milo Kim wrote:

> LP3943 is an integrated device capable of driving 16 output channels.
> It can be used for GPIO expander and PWM generators.
> LP3493 registers are controlled via the I2C interface.
> 
> This patch-set consists of four parts - MFD, GPIO, PWM and documents.
> 
> Update from v4 to v5:
>   Add Thierry's ACK for the PWM driver and the DT documentation
> 
> Milo Kim (4):
>   mfd: add LP3943 MFD driver
>   gpio: add LP3943 I2C GPIO expander driver
>   pwm: add LP3943 PWM driver
>   Documentation: add LP3943 DT bindings and document
> 
>  .../devicetree/bindings/gpio/gpio-lp3943.txt       |   37 +++
>  Documentation/devicetree/bindings/mfd/lp3943.txt   |   33 ++
>  .../devicetree/bindings/pwm/pwm-lp3943.txt         |   58 ++++
>  drivers/gpio/Kconfig                               |    8 +
>  drivers/gpio/Makefile                              |    1 +
>  drivers/gpio/gpio-lp3943.c                         |  242 +++++++++++++++
>  drivers/mfd/Kconfig                                |   11 +
>  drivers/mfd/Makefile                               |    1 +
>  drivers/mfd/lp3943.c                               |  167 +++++++++++
>  drivers/pwm/Kconfig                                |   10 +
>  drivers/pwm/Makefile                               |    1 +
>  drivers/pwm/pwm-lp3943.c                           |  314 ++++++++++++++++++++
>  include/linux/mfd/lp3943.h                         |  114 +++++++
>  13 files changed, 997 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-lp3943.txt
>  create mode 100644 Documentation/devicetree/bindings/mfd/lp3943.txt
>  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-lp3943.txt
>  create mode 100644 drivers/gpio/gpio-lp3943.c
>  create mode 100644 drivers/mfd/lp3943.c
>  create mode 100644 drivers/pwm/pwm-lp3943.c
>  create mode 100644 include/linux/mfd/lp3943.h

Patch-set applied, thanks Milo.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

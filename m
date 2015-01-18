Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbbARSAM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 13:00:12 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:44507 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbbARSAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 13:00:09 -0500
Date: Sun, 18 Jan 2015 18:00:02 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v4 0/4] power: Add max77693 charger driver
Message-ID: <20150118180002.GJ3574@x1>
References: <1420453019-28614-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420453019-28614-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tell us what you need?

> Changes since v3
> ================
> 1. Patch 3/4: Don't create platform data structure for charger settings
>    because driver won't be used on non-DT SoCs (its for Exynos based
>    Trats2).
> 2. Patch 3/4: Drop Sebastian's ack [1] because of change above.
> 
> Changes since v2
> ================
> 1. Add ack from Sebastian Reichel (charger driver).
> 2. Drop patch "mfd: max77693: Map charger device to its own of_node"
>    (applied by Lee Jones).
> 
> 
> Changes since v1
> ================
> 1. Add patch 2/5: mfd: max77693: Map charger device to its own of_node
>    (forgot to send it in v1)
> 2. Remove patches for DTS and configs. I'll send them later.
> 3. Add ack from Lee Jones (patch 3/5).
> 
> 
> Description
> ===========
> The patchset adds max77693 charger driver present on Trats2 board
> (and Galaxy S III). The driver configures battery charger and exposes
> power supply interface.
> 
> Driver is necessary to provide full charging stack on Trats2 device
> (extcon, charger-manager etc.).
> 
> [1] https://lkml.org/lkml/2014/10/27/774
> 
> 
> Best regards,
> Krzysztof
> 
> 
> 
> Krzysztof Kozlowski (4):
>   devicetree: power/mfd: max77693: Document new bindings for charger
>   mfd: max77693: Add defines for MAX77693 charger driver
>   power: max77693: Add charger driver for Maxim 77693
>   Documentation: power: max77693-charger: Document exported sysfs entry
> 
>  Documentation/ABI/testing/sysfs-class-power        |  42 ++
>  Documentation/devicetree/bindings/mfd/max77693.txt |  45 ++
>  drivers/power/Kconfig                              |   6 +
>  drivers/power/Makefile                             |   1 +
>  drivers/power/max77693_charger.c                   | 758 +++++++++++++++++++++
>  include/linux/mfd/max77693-private.h               | 108 +++
>  6 files changed, 960 insertions(+)
>  create mode 100644 drivers/power/max77693_charger.c
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

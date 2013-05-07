Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab3EGHFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 03:05:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24813 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab3EGHFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 03:05:36 -0400
X-AuditID: cbfee68f-b7f066d000003683-f3-5188a7becd66
Message-id: <5188A7BE.4080509@samsung.com>
Date: Tue, 07 May 2013 16:05:34 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: myungjoo.ham@samsung.com, balbi@ti.com, ldewangan@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, gg@slimlogic.co.uk,
        ruchika@ti.com, tony@atomide.com, sameo@linux.intel.com,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH v4] extcon: Palmas Extcon Driver
References: <1362662506-14823-4-git-send-email-kishon@ti.com>
 <1367846225-15685-1-git-send-email-kishon@ti.com>
 <51889AD9.9030902@samsung.com> <51889E55.8090306@ti.com>
 <5188A5EC.8020705@samsung.com>
In-reply-to: <5188A5EC.8020705@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42JZI2JSrLtveUegwdpPOhYH79db/Jt9is3i
	wOyHrBb9W1wsDvzZwWhx4WkPm8XSfatZLBa2LWGxuLxrDpvF7cYVbBaHVxxgslj3cjqLxduF
	t1ksTnezWuy/4uXA7/Ht6yQWjwWfr7B7vFo9k9XjzrU9bB7zTgZ6nJ+xkNGjt/kdm8fLib/Z
	PPq2rGL0mDrlL6PH8RvbmTw+b5IL4InisklJzcksSy3St0vgyrh56B5LwV6Jim0vFrA1MJ4T
	6mLk5JAQMJFY+O0YO4QtJnHh3nq2LkYuDiGBpYwSs9s2s8MULV2yihUiMZ1R4lffJaiqF4wS
	F+68ZgOp4hXQknj0cyIriM0ioCrR+HwbWDcbUHz/ixtgNaICYRIrp19hgagXlPgx+R6YLQJU
	c3rnD2aQocwCt5kk1t67C5YQBlr98fdBZohtZxklvlxfAbaBU0BbYtbya4wgNrOAjsT+1mls
	ELa8xOY1b8EaJAR2cEjs+PiHHeIkAYlvkw8BTeUASshKbDrADPGbpMTBFTdYJjCKzUJy1Cwk
	Y2chGbuAkXkVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRmAiOP3vWf8OxrsHrA8xJgOtnMgs
	JZqcD0wkeSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9iZOLg
	lGpgnBrWyhG+9Hp3ieump4fOf2NY+te+YoXq21PRrgVGJfvf3+dKC/WKkDMOU/dPzBAT239i
	/YN9bYb/01T3iim0rPBos43jr1uRK/PxyDaDVMbWatEvk3lTT66ty1/gLepz9FDtxgOp75fn
	qywpMNNSirzf2yUc5x74oKmp8BOHtcJdrZLQO9pKLMUZiYZazEXFiQDYb4h9GgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsVy+t9jQd19yzsCDXY+VrI4eL/e4t/sU2wW
	B2Y/ZLXo3+JiceDPDkaLC0972CyW7lvNYrGwbQmLxeVdc9gsbjeuYLM4vOIAk8W6l9NZLN4u
	vM1icbqb1WL/FS8Hfo9vXyexeCz4fIXd49Xqmawed67tYfOYdzLQ4/yMhYwevc3v2DxeTvzN
	5tG3ZRWjx9Qpfxk9jt/YzuTxeZNcAE9UA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGu
	oaWFuZJCXmJuqq2Si0+ArltmDtA3SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM
	0EDCGsaMm4fusRTslajY9mIBWwPjOaEuRk4OCQETiaVLVrFC2GISF+6tZ+ti5OIQEpjOKPGr
	7xKU84JR4sKd12wgVbwCWhKPfk4E62ARUJVofL6NHcRmA4rvf3EDrEZUIExi5fQrLBD1ghI/
	Jt8Ds0WAak7v/MEMMpRZ4DaTxNp7d8ESwkBnfPx9kBli21lGiS/XV4Bt4BTQlpi1/BojiM0s
	oCOxv3UaG4QtL7F5zVvmCYwCs5AsmYWkbBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLz
	czcxgtPMM+kdjKsaLA4xCnAwKvHwKpxqDxRiTSwrrsw9xCjBwawkwiut3REoxJuSWFmVWpQf
	X1Sak1p8iDEZGAYTmaVEk/OBKTCvJN7Q2MTMyNLI3NDCyNicNGElcd6DrdaBQgLpiSWp2amp
	BalFMFuYODilGhhZt088y/S7+q3BTtt70+2sSiYKRbHZrN+3yOFz32vHxUv3zz6WEs/+zq5N
	xeJjToNiQ/23L3G7NGr3Pc25z7XeyCNQ7rHLy2DX7yJ/UpsWlDxY/y31TSnr5qDaoy0mt9S2
	ZpotMT8vZHJyz51Ac5sKJ1P3xurvh+POFu8KP5onYJe+4/r3t21KLMUZiYZazEXFiQCem0UM
	dwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 03:57 PM, Chanwoo Choi wrote:
> diff --git a/include/linux/extcon/extcon_palmas.h b/include/linux/extcon/extcon_palmas.h
> new file mode 100644
> index 0000000..a5119c9
> --- /dev/null
> +++ b/include/linux/extcon/extcon_palmas.h
> @@ -0,0 +1,26 @@
> +/*
> + * extcon_palmas.h - palmas extcon driver to detect VBUS or ID events
> + *
> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * Author: Kishon Vijay Abraham I <kishon@ti.com>
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __EXTCON_PALMAS_H__
> +#define __EXTCON_PALMAS_H__
> +
> +#define    PALMAS_USB_STATE_DISCONNECT    0x0
> +#define    PALMAS_USB_STATE_VBUS        BIT(0)
> +#define    PALMAS_USB_STATE_ID        BIT(1)
> +
>>> The defined variable in extcon_palmas.h is used only on extcon-palmas.c.
>>> So, I would like to move definition from extcon_palmas.h to extcon-palmas.c
>>> and remove extcon_palmas.h header file.
>> Actually it has to be used in dwc3-omap.c (that was in a different patch).
>>
> Should detect the state of USB/USB-HOST on dwc3-omap driver?
>
> If yes, dwc3-omap driver can immediately detect the changed state of USB/USB-HOST
> by using excon_register_interest() function which is defined in extcon-class.c
>
> I explain simple usage of extcon_register_interest()
> to receive newly state of USB cable on dwc3-omap driver.
> -----------
>     struct extcon_specific_cable_nb extcon_notifier
>     struct notifier_block extcon_notifier;
>
>      /* ... */
>
>     extcon_notifier.notifier_call = omap_extcon_notifier;
>     ret = extcon_register_interest(&extcon_dev, "USB", &extcon_notifier);
    Fix usage of extcon_register_interest() as following:

    ret = extcon_register_interest(&extcon_dev, NULL, "USB", &extcon_notifier); or
    ret = extcon_register_interest(&extcon_dev, "palmas-usb", "USB", &extcon_notifier);
>     /* ... */
>
>     int omap_extcon_notifier(struct notifier_block *self,
>                                                 unsigned long event, void *ptr)
>     {
>             int usb_state;
>
>             usb_state = event;                                   
>
>             /* if usb_state is 1, PALMAS_USB_STATE_VBUS  */
>             /* if usb_state is 0, PALMAS_USB_STATE_DISCONNECT */
>
>             /* TODO */
>
>     }
> -----------
>
> If dwc3-omap driver use extcon_register_interest(), following defined variables
> are able to be removed.
>     PALMAS_USB_STATE_DISCONNECT
>     PALMAS_USB_STATE_VBUS
>     PALMAS_USB_STATE_ID
>
> Thanks,
> Chanwoo Choi
>


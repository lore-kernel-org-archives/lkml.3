Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbbASHkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 02:40:35 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34658 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbbASHkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 02:40:33 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-44-54bcb4eef4ce
Message-id: <1421653226.4247.5.camel@AMDC1943>
Subject: Re: [PATCH v4 0/4] power: Add max77693 charger driver
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-api@vger.kernel.org
Date: Mon, 19 Jan 2015 08:40:26 +0100
In-reply-to: <20150118180002.GJ3574@x1>
References: <1420453019-28614-1-git-send-email-k.kozlowski@samsung.com>
 <20150118180002.GJ3574@x1>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t/xa7rvtuwJMXixidVi0pP3zBbzj5xj
	tZi4cjKzxf2vRxktNn/vYLO4vGsOm8Xn3iOMFqe7WS1O7y5x4PTYOesuu8fmFVoem1Z1snnc
	ubaHzWPeyUCPz5vkAtiiuGxSUnMyy1KL9O0SuDIOnb7GXvBBtGL9gk3sDYyHBLoYOTkkBEwk
	9n/Zxwphi0lcuLeerYuRi0NIYCmjxKwFl1khnM+MEj/bZ7KBVPEK6ElMebKSEcQWFrCT+Hzu
	A5jNJmAssXn5EqAaDg4RARWJc2/MQXqZBWYxSVx7+BCshkVAVWJF9yswm1NAXeLqrPtgM4UE
	UiS+tMwCu4IZKD5p3iJmkDkSAsoSjf1uEGsFJX5MvscCUSIvsXnNW+YJjAKzkHTMQlI2C0nZ
	AkbmVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghof9lB+PiY1aHGAU4GJV4eDVy9oQIsSaW
	FVfmHmKU4GBWEuHlWw8U4k1JrKxKLcqPLyrNSS0+xMjEwSnVwFhqrJgZtYrDYb0X69Tdiy/4
	2jhXrPb6JKWyukugvf+3zp6qG2eT9Lecq5LqebEgt/xsWNwv/o0CM0O/vzVzu6Nop5/hxRnc
	5HLDRadiQbahl3ZhbuJ0plfP664J+3sraOyTn8zzzdX81ZI7iRtOtj4Kk9r/TqmSx/I699a/
	u2aWTPy3LPNDlBJLcUaioRZzUXEiAELvkyhbAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On nie, 2015-01-18 at 18:00 +0000, Lee Jones wrote:
> Tell us what you need?

Hi Lee,


All I need is... acks or applying of patchset by Sebastian. Sebastian
acked main patch (3/4) but then I changed it [1].

You already acked the MFD change (patch 2/4: mfd: max77693: Add defines
for MAX77693 charger driver).

The patch with bindings (1/4: devicetree: power/mfd: max77693: Document
new bindings for charger) actually adds bindings for charger so rather
Sebastian's opinion is needed.

Other patches are from power supply subsystem.
Thanks for asking!


Dear Sebastian,

You already looked at the patchset [1], so maybe you could pick it up?

[1] https://lkml.org/lkml/2014/10/27/774

Best regards,
Krzysztof

> 
> > Changes since v3
> > ================
> > 1. Patch 3/4: Don't create platform data structure for charger settings
> >    because driver won't be used on non-DT SoCs (its for Exynos based
> >    Trats2).
> > 2. Patch 3/4: Drop Sebastian's ack [1] because of change above.
> > 
> > Changes since v2
> > ================
> > 1. Add ack from Sebastian Reichel (charger driver).
> > 2. Drop patch "mfd: max77693: Map charger device to its own of_node"
> >    (applied by Lee Jones).
> > 
> > 
> > Changes since v1
> > ================
> > 1. Add patch 2/5: mfd: max77693: Map charger device to its own of_node
> >    (forgot to send it in v1)
> > 2. Remove patches for DTS and configs. I'll send them later.
> > 3. Add ack from Lee Jones (patch 3/5).
> > 
> > 
> > Description
> > ===========
> > The patchset adds max77693 charger driver present on Trats2 board
> > (and Galaxy S III). The driver configures battery charger and exposes
> > power supply interface.
> > 
> > Driver is necessary to provide full charging stack on Trats2 device
> > (extcon, charger-manager etc.).
> > 
> > [1] https://lkml.org/lkml/2014/10/27/774
> > 
> > 
> > Best regards,
> > Krzysztof
> > 
> > 
> > 
> > Krzysztof Kozlowski (4):
> >   devicetree: power/mfd: max77693: Document new bindings for charger
> >   mfd: max77693: Add defines for MAX77693 charger driver
> >   power: max77693: Add charger driver for Maxim 77693
> >   Documentation: power: max77693-charger: Document exported sysfs entry
> > 
> >  Documentation/ABI/testing/sysfs-class-power        |  42 ++
> >  Documentation/devicetree/bindings/mfd/max77693.txt |  45 ++
> >  drivers/power/Kconfig                              |   6 +
> >  drivers/power/Makefile                             |   1 +
> >  drivers/power/max77693_charger.c                   | 758 +++++++++++++++++++++
> >  include/linux/mfd/max77693-private.h               | 108 +++
> >  6 files changed, 960 insertions(+)
> >  create mode 100644 drivers/power/max77693_charger.c
> > 
> 


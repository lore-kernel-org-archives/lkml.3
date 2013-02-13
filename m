Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab3BMGb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 01:31:26 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:14859 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab3BMGbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 01:31:24 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-a4-511b333a9b3d
From: kgene@kernel.org
To: "'Vivek Gautam'" <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, gregkh@linuxfoundation.org,
        balbi@ti.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        sylvester.nawrocki@gmail.com, tomasz.figa@gmail.com,
        av.tikhomirov@samsung.com, dianders@chromium.org, p.paneri@samsung.com
References: <1360068256-19602-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1360068256-19602-1-git-send-email-gautam.vivek@samsung.com>
Subject: RE: [PATCH v5 0/2] Adding USB 3.0 DRD-phy support for exynos5250
Date: Tue, 12 Feb 2013 22:31:00 -0800
Message-id: <1e3101ce09b3$b2e178c0$18a46a40$@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGdP9pAoehraQMbYmiujF5PDt+QSZjY5vug
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t8zfV0rY+lAgyfP9S0u75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIzisklJzcksSy3St0vgymj8/pu9YBJPRdfFKywNjGc5uxg5OSQETCQa
	bj1ggrDFJC7cW8/WxcjFISSwjFFi//FbQAkOsKJvswoh4tMZJW6+ecsK4fxllPj29xIzSBEb
	UPfUJ9Igg4QFtCQWbmliAbFFBDwk7h5bzg5iMwucZpLoep0IYgsBxSe93MIK0sop4Clxps0f
	otVT4tHqqWDlLAKqEpcnLWQEKeEVsJBYeVoCJMwrICjxY/I9FoiJWhLrdx5ngrDlJTavecsM
	8YqCxI6zrxkhLjCSeHD6BhtEjbjEpAcP2UGulxDYxy5xbsMyVohdAhLfJh9igXhXVmLTAag5
	khIHV9xgmcAoOQvJ6llIVs9CsnoWkhULGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYoRE
	oPQOxlUNFocYBTgYlXh4HUKkAoVYE8uKK3MPMUpwMCuJ8E7gkA4U4k1JrKxKLcqPLyrNSS0+
	xJgMdOxEZinR5HxgcsgriTc0NjYxMzE1Mbc0NTclTVhJnJfx1JMAIYH0xJLU7NTUgtQimC1M
	HJxSDYyMj5TXc3w7HLSmOFDhssYshswjHaJc3suMnQX0Dmt/XGwYo39DfnZATHpIYuzyDSXb
	P6hx6qfeX5e7Y6Zs92c3xfptISbGdX6Vk8Ov5XT+anNzCWzTnetqpRZbLZ2z4cvNtf9FJYQz
	dSKFXllemZ04n+PmkQvLvJdzvu9Z1PSULXzRVZ7lW5RYijMSDbWYi4oTAdwArtkEAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jQV0rY+lAgw+btSwu75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIxqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
	tVVy8QnQdcvMAZqvpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8xo/P6b
	vWAST0XXxSssDYxnObsYOTgkBEwkvs0q7GLkBDLFJC7cW8/WxcjFISQwnVHi5pu3rBDOX0aJ
	b38vMYM0sAFVTX0iDdIgLKAlsXBLEwuILSLgIXH32HJ2EJtZ4DSTRNfrRBBbCCg+6eUWVpBW
	TgFPiTNt/hCtnhKPVk8FK2cRUJW4PGkhI0gJr4CFxMrTEiBhXgFBiR+T77FATNSSWL/zOBOE
	LS+xec1bZoiTFSR2nH3NCHGBkcSD0zfYIGrEJSY9eMg+gVF4FpJRs5CMmoVk1CwkLQsYWVYx
	iqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMf3M+kdjKsaLA4xCnAwKvHwOoRIBQqxJpYVV+Ye
	YpTgYFYS4Z3AIR0oxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnA1JNXEm9obGJmZGlkZmFk
	Ym5OmrCSOC/jqScBQgLpiSWp2ampBalFMFuYODilGhjn3rBXuX8xO+6niLBn0fIjt8wemjjF
	9Vx9GZS8VcnkX/j6ewsaFdeFWHUuK4yzkch6u+GQz6TatnUvM/neqi69KdnhtYllg/RvuapN
	TkfiJPYxJuV9uGah8jJ5pmrtrtp1s2+/LP+T/vwG96c1TwL+OtjFdkdtV9ypeNarZI3tqh1c
	H2VebtytxFKckWioxVxUnAgA7QXeFzMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Gautam wrote:
> 
> Based on 'usb-next'
> 
> Changes from v4:
>  - Modifying function names and driver names to follow a common
>    naming convention.
>         "usb2phy" for samsung-usb2phy driver
>         "usb3phy" for samsung-usb3phy driver
>  - Changing file names "samsung-usb2.c" to "samsung-usb2phy.c" and,
>    "samsung-usb3.c" to "samsung-usb3phy.c"
>  - Removing dependencies for SAMSUNG_USB2PHY and
> SAMSUNG_USB3PHY.
>  - Arranging SAMSUNG_USB2PHY and SAMSUNG_USB3PHY to select
> SAMSUNG_USBPHY,
>    which is the usb-phy helper driver.
> 
> Vivek Gautam (2):
>   usb: phy: samsung: Common out the generic stuff
>   usb: phy: samsung: Add PHY support for USB 3.0 controller
> 
>  drivers/usb/phy/Kconfig           |   25 +-
>  drivers/usb/phy/Makefile          |    2 +
>  drivers/usb/phy/samsung-usb2phy.c |  511
> ++++++++++++++++++++++++++
>  drivers/usb/phy/samsung-usb3phy.c |  349 ++++++++++++++++++
>  drivers/usb/phy/samsung-usbphy.c  |  717
+------------------------------------
>  drivers/usb/phy/samsung-usbphy.h  |  328 +++++++++++++++++
>  6 files changed, 1219 insertions(+), 713 deletions(-)
>  create mode 100644 drivers/usb/phy/samsung-usb2phy.c
>  create mode 100644 drivers/usb/phy/samsung-usb3phy.c
>  create mode 100644 drivers/usb/phy/samsung-usbphy.h
> 
> --
> 1.7.6.5

For now, looks good to me, and if any enhancement is required, it can be
done next time.

Felipe, please go ahead with my ack :-)
Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

- Kukjin


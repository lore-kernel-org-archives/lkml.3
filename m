Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbaGJEX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 00:23:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26629 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbaGJEXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 00:23:49 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-bd-53be1553726d
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, m.szyprowski@samsung.com, broonie@linaro.org,
        tobetter@gmail.com, jy0922.shim@samsung.com
Subject: [PATCH 3/3] USB: add reset resume quirk for usb3503
Date: Thu, 10 Jul 2014 13:23:48 +0900
Message-id: <1404966228-29133-3-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1404966228-29133-1-git-send-email-jy0922.shim@samsung.com>
References: <1404966228-29133-1-git-send-email-jy0922.shim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWyRsSkWDdYdF+wwcP/xhabrl9ntWhevJ7N
	4sW9iywWl3fNYbNYtKyV2WLtkbvsFvser2F2YPfYOesuu8eda3vYPPbPXcPu0bdlFaPH501y
	AaxRXDYpqTmZZalF+nYJXBlrV29gKVjFW9H3tJmlgfEZVxcjJ4eEgInE3RebGSFsMYkL99az
	dTFycQgJLGWU6NmxjgmmaOqLc6wgtpDAIkaJ5d+rIYpamSRerHjDApJgE9CTuLPtOFADB4eI
	gLVE38EgkDCzQLXE//X3wOYIC9hInPx6HWwZi4CqxKkLvWCtvALuEu/mz4LapSDx8/IJNhCb
	U8BD4vaGnywQe90lVpxvYQfZKyEwj13i4xsQB2SQgMS3yYdYQPZKCMhKbDrADDFHUuLgihss
	ExiFFzAyrGIUTS1ILihOSi8y1StOzC0uzUvXS87P3cQIDPLT/55N3MF4/4D1IcZkoHETmaVE
	k/OBUZJXEm9obGZkYWpiamxkbmlGmrCSOG/6o6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxS
	DYx107TVTnvU5+48tl79+AsHf3unBZ1vb8tczu4o6PtvfOzF1B9Tird6atyYt+10vMqhz7s/
	9zMEa4g6GTP8z3smOPnWpLuiOtWLrSN/zNv+q3NGlEAEs490q/Zx77k2ttb7uj23MCtNdou4
	bva2NDJ0beRamY4vLt63iort54tNKy97f6I7+qMSS3FGoqEWc1FxIgDYFMXYiAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t9jAd1g0X3BBnf36Vhsun6d1aJ58Xo2
	ixf3LrJYXN41h81i0bJWZou1R+6yW+x7vIbZgd1j56y77B53ru1h89g/dw27R9+WVYwenzfJ
	BbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMWLt6A0vBKt6KvqfNLA2M
	z7i6GDk5JARMJKa+OMcKYYtJXLi3ng3EFhJYxCix/Ht1FyMXkN3KJPFixRsWkASbgJ7EnW3H
	mboYOThEBKwl+g4GgYSZBaol/q+/xwRiCwvYSJz8ep0RxGYRUJU4daEXrJVXwF3i3fxZTBC7
	FCR+Xj4BtotTwEPi9oafLBB73SVWnG9hn8DIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+
	7iZGcAw9k97BuKrB4hCjAAejEg9vQ8/eYCHWxLLiytxDjBIczEoivB7/gUK8KYmVValF+fFF
	pTmpxYcYTYGumsgsJZqcD4zvvJJ4Q2MTMyNLI3NDCyNjcyVx3oOt1oFCAumJJanZqakFqUUw
	fUwcnFINjCH763+o8gf8cH/3/Um6uIz0ktqCT8maPCY1n9a9XX+h/FDwdQdPi07jv9fvyJ7/
	xqQa8aP8t0Lx7+snqzImfJzwcPuGj1Pi7FSEHIpVIj0YAy1PL1krVLz3Zv7suXMv6Z/+xP58
	Z2xpcJxSj8qLfxuZm0VWbPdeMWvpc80Hpp+f+vY+0whYY6PEUpyRaKjFXFScCADsSqFbtwIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usb device will autoresume from choose_wakeup() if it is
autosuspended with the wrong wakeup setting, but below errors occur
because usb3503 misc driver will switch to standby mode when suspended.

As add USB_QUIRK_RESET_RESUME, it can stop setting wrong wakeup from
autosuspend_check().

[    7.734717] usb 1-3: reset high-speed USB device number 3 using exynos-ehci
[    7.854658] usb 1-3: device descriptor read/64, error -71
[    8.079657] usb 1-3: device descriptor read/64, error -71
[    8.294664] usb 1-3: reset high-speed USB device number 3 using exynos-ehci
[    8.414658] usb 1-3: device descriptor read/64, error -71
[    8.639657] usb 1-3: device descriptor read/64, error -71
[    8.854667] usb 1-3: reset high-speed USB device number 3 using exynos-ehci
[    9.264598] usb 1-3: device not accepting address 3, error -71
[    9.374655] usb 1-3: reset high-speed USB device number 3 using exynos-ehci
[    9.784601] usb 1-3: device not accepting address 3, error -71
[    9.784838] usb usb1-port3: device 1-3 not suspended yet

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 739ee8e..2c9ba407 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -152,6 +152,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* USB3503 */
+	{ USB_DEVICE(0x0424, 0x3503), .driver_info = USB_QUIRK_RESET_RESUME },
+
 	{ }  /* terminating entry must be last */
 };
 
-- 
1.8.1.2


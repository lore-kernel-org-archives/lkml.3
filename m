Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190AbaGJFWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 01:22:39 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36699 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaGJFWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 01:22:37 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-7d-53be231b995e
From: Joonyoung Shim <jy0922.shim@samsung.com>
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, m.szyprowski@samsung.com, broonie@linaro.org,
        tobetter@gmail.com, jy0922.shim@samsung.com
Subject: [PATCH 2/2] USB: add reset resume quirk for usb3503
Date: Thu, 10 Jul 2014 14:22:35 +0900
Message-id: <1404969755-30555-2-git-send-email-jy0922.shim@samsung.com>
X-Mailer: git-send-email 1.8.1.2
In-reply-to: <1404969755-30555-1-git-send-email-jy0922.shim@samsung.com>
References: <1404969755-30555-1-git-send-email-jy0922.shim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWyRsSkWFdaeV+wwfP3Chabrl9ntWhevJ7N
	4sW9iywWl3fNYbNYtKyV2WLtkbvsFvser2F2YPfYOesuu8eda3vYPPbPXcPu0bdlFaPH501y
	AaxRXDYpqTmZZalF+nYJXBlrV29gKVjFW9H3tJmlgfEZVxcjJ4eEgInEmbX7mCFsMYkL99az
	dTFycQgJLGWUWNZ3ihGmaNfTT6wQiemMEv82LWaCcFqZJHp/vANrZxPQk7iz7ThQgoNDRMBa
	ou9gEEiYWaBa4v/6e0wgtrCAjcT/26fYQGwWAVWJM1PugNm8Au4Sy863MUEsU5D4efkEWJxT
	wEPibc98sCOEgGq+T/oPVTOPXeLJbWeIOQIS3yYfYgFZKyEgK7HpANQzkhIHV9xgmcAovICR
	YRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZGYJCf/vesdwfj7QPWhxiTgcZNZJYSTc4HRkle
	SbyhsZmRhamJqbGRuaUZacJK4rxJD5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTB2zky9
	V22nfevGTu6Pq3MuGbuK8DJ+kdVcuNTzYrnsi1fhUSvUMvY91mHdGLDqfCb34V/Kz3YEfeC/
	XXS+LOVhY+E3oRUNW08sETwnurfsUOv/BDW9z3YGi7KlV2/4+iF+vcP3iCus/C2ms7ik7xet
	Z9p1d0PIz92XeA425SmpOLY/t5y3uTZViaU4I9FQi7moOBEApDH3AIgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t9jQV1p5X3BBifXSlpsun6d1aJ58Xo2
	ixf3LrJYXN41h81i0bJWZou1R+6yW+x7vIbZgd1j56y77B53ru1h89g/dw27R9+WVYwenzfJ
	BbBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMWLt6A0vBKt6KvqfNLA2M
	z7i6GDk5JARMJHY9/cQKYYtJXLi3nq2LkYtDSGA6o8S/TYuZIJxWJoneH++YQarYBPQk7mw7
	DpTg4BARsJboOxgEEmYWqJb4v/4eE4gtLGAj8f/2KTYQm0VAVeLMlDtgNq+Au8Sy821MEMsU
	JH5ePgEW5xTwkHjbM58RxBYCqvk+6T/TBEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNz
	NzGCo+iZ1A7GlQ0WhxgFOBiVeHgbevYGC7EmlhVX5h5ilOBgVhLh9fgPFOJNSaysSi3Kjy8q
	zUktPsRoCnTVRGYp0eR8YITnlcQbGpuYGVkamRtaGBmbK4nzHmi1DhQSSE8sSc1OTS1ILYLp
	Y+LglGpg5ND/sN0hf5LmJ9+NLDq7Y19NiA+fwaAuv+rcuVUTBN7dfvXy/ffsrsqXzz58m9B/
	S2jdXk25H5VxO1n/X8m3Obrdb75L0aUjDBnrjhntZDDOPvhdiyHN9cSpvYHOTo9WbduoqeIY
	Z8LSsHGVh/LkVdteMcVv0rq+VGt/6ZEtWxofxK1Zkar7/JkSS3FGoqEWc1FxIgB1sPLjuAIA	AA==
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


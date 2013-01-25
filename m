Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab3AYLQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:16:17 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:61166 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab3AYLPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:15:02 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-00-510269347a33
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com
Subject: [PATCH 2/2] usb: dwc3: host: Change platform device ID for xhci-hcd to
 AUTO
Date: Fri, 25 Jan 2013 16:52:02 +0530
Message-id: <1359112922-2247-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1359112922-2247-1-git-send-email-gautam.vivek@samsung.com>
References: <1359112922-2247-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsWyRsSkVtc0kynQ4NA+JovLu+awWcxe0s9i
	sWhZK7MDs8fnTXIBjFFcNimpOZllqUX6dglcGXOWzGUvmMZWcXPTHqYGxj7WLkZODgkBE4lJ
	n1dC2WISF+6tZ+ti5OIQEljKKDFl4hpGmKIN59exQiQWMUps2rgXypnMJHF5yjY2kCo2AV2J
	pre7wDpEBGQlDl/5zdzFyMHBLJAhMeMC2AZhgTCJifN3sIGEWQRUJa4/tgAJ8wq4S/y++5EN
	YpeCxJvbz8A6OQU8JJb+DwQJCwGV3D6wCWyrhMBjNomPy46A1bMICEh8m3yIBaReAmjrpgPM
	EGMkJQ6uuMEygVF4ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzAkDz975nUDsaVDRaH
	GAU4GJV4eC3SGAOFWBPLiitzDzFKcDArifDKmDAFCvGmJFZWpRblxxeV5qQWH2JMBlo+kVlK
	NDkfGC95JfGGxibmpsamlkZGZqampAkrifMynnoSICSQnliSmp2aWpBaBLOFiYNTqoGxSYx1
	XYRMvYNx7lHBaCelkJvNgTx1neFb5i4qOJqptH7ZroP7twhyKCgWNJ7Tmbsms+SERMVzDh/T
	k8Ztyh7Hyh37L83ru/Bivbmm6vfvNy+K5dlPW3NOZkKSX8gR7t/z2TWOxB+7Ziyx9Yi8311n
	tg0et74Ftyec9kzbdTnvZ2J/jN+j+mIlluKMREMt5qLiRAD8S+QFjQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t9jAV2TTKZAgyd7jSwu75rDZjF7ST+L
	xaJlrcwOzB6fN8kFMEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam
	2iq5+AToumXmAM1XUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGbMWTKX
	vWAaW8XNTXuYGhj7WLsYOTkkBEwkNpxfB2WLSVy4t56ti5GLQ0hgEaPEpo17WSGcyUwSl6ds
	YwOpYhPQlWh6u4sRxBYRkJU4fOU3cxcjBwezQIbEjAtgg4QFwiQmzt/BBhJmEVCVuP7YAiTM
	K+Au8fvuRzaIXQoSb24/A+vkFPCQWPo/ECQsBFRy+8Am1gmMvAsYGVYxiqYWJBcUJ6XnGuoV
	J+YWl+al6yXn525iBAf8M6kdjCsbLA4xCnAwKvHwWqQxBgqxJpYVV+YeYpTgYFYS4ZUxYQoU
	4k1JrKxKLcqPLyrNSS0+xJgMdNNEZinR5HxgNOaVxBsam5ibGptamliYmFmSJqwkzst46kmA
	kEB6YklqdmpqQWoRzBYmDk6pBsY986S/rPnLfzxzqTunVBiDutaH/F1bbNnv6zn7SB5/V6j4
	1qntnU1q44TewKvv/uxc6t6f1ZCc4FLDffXRWd+sfe0cHhFnkrL5TgitnFPuWmQcsPG3wdX1
	aTx9BtEqp7fsvnzhqmFRWUTl5AM9V7/HHJizgPu96C1JsQ0PJnBY1DAmiB57t1yJpTgj0VCL
	uag4EQArtidAvAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple dwc3 controllers will try to allocate multiple xhci-hcd
interfaces.
Changing platform device IDs from NONE to AUTO to support
such cases.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/dwc3/host.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
index 56a6234..0fa1846 100644
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -44,7 +44,7 @@ int dwc3_host_init(struct dwc3 *dwc)
 	struct platform_device	*xhci;
 	int			ret;
 
-	xhci = platform_device_alloc("xhci-hcd", -1);
+	xhci = platform_device_alloc("xhci-hcd", PLATFORM_DEVID_AUTO);
 	if (!xhci) {
 		dev_err(dwc->dev, "couldn't allocate xHCI device\n");
 		ret = -ENOMEM;
-- 
1.7.6.5


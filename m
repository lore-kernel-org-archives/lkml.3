Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab3A1Lio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:38:44 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:27128 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757106Ab3A1Lij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:38:39 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-e4-5106633ea96a
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com,
        dianders@chromium.org, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com
Subject: [PATCH 2/4] USB: dwc3: Adjust runtime pm the dwc3 driver to allow
 runtime suspend
Date: Mon, 28 Jan 2013 17:12:26 +0530
Message-id: <1359373348-18320-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
References: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42JZI2JSo2uXzBZosOOtqsXlXXPYLGYv6Wex
	mHF+H5PFomWtzA4sHp83yQUwRnHZpKTmZJalFunbJXBlLOw/xlbQzlsx+fJp5gbG21xdjJwc
	EgImEut6L7BD2GISF+6tZ+ti5OIQEljKKLH0xRVGmKKpbbfYIRKLGCUa5swG6xASmMwkceyk
	IojNJqAr0fR2F1iDiICsxOErv5lBGpgFJjJJ9CxqYAJJCAvESJzuncQKYrMIqErcm9bHDGLz
	CnhIHDx4mRVim4LEm9vPwOKcAp4Skx+cgVrmITFz0XwWkKESAq/ZJO5tXsIMMUhA4tvkQ0AJ
	DqCErMSmA8wQcyQlDq64wTKBUXgBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjMAQPf3v
	mfQOxlUNFocYBTgYlXh4f6SxBAqxJpYVV+YeYpTgYFYS4RWIYQsU4k1JrKxKLcqPLyrNSS0+
	xJgMtHwis5Rocj4wfvJK4g2NTcxNjU0tjYzMTE1JE1YS52U89SRASCA9sSQ1OzW1ILUIZgsT
	B6dUA6PBzG+b6p/psJ7yrThoXqRakX71vPQ0hSV3+WXF/lm8ZdGes++CeUqwlP0fHeWQKQ7T
	/FkX2SktmfUzRDP2ZWyDhjl3Xw3DblPn6893agg8fNYUen7L934+E5lpe+oSb/PbuO5Stn3R
	5G/LoJq41W11/pxzV1ZXTZxw3diPy26p7eeHwr15u5VYijMSDbWYi4oTAUKn7jWVAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t9jAV27ZLZAgydHpCwu75rDZjF7ST+L
	xYzz+5gsFi1rZXZg8fi8SS6AMaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJc
	SSEvMTfVVsnFJ0DXLTMHaImSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCG
	MWNh/zG2gnbeismXTzM3MN7m6mLk5JAQMJGY2naLHcIWk7hwbz1bFyMXh5DAIkaJhjmzwRJC
	ApOZJI6dVASx2QR0JZre7mIEsUUEZCUOX/nNDNLALDCRSaJnUQMTSEJYIEbidO8kVhCbRUBV
	4t60PmYQm1fAQ+LgwcusENsUJN7cfgYW5xTwlJj84AzUMg+JmYvms0xg5F3AyLCKUTS1ILmg
	OCk910ivODG3uDQvXS85P3cTIzgCnknvYFzVYHGIUYCDUYmH90caS6AQa2JZcWXuIUYJDmYl
	EV6BGLZAId6UxMqq1KL8+KLSnNTiQ4zJQFdNZJYSTc4HRmdeSbyhsYm5qbGppYmFiZklacJK
	4ryMp54ECAmkJ5akZqemFqQWwWxh4uCUamBcohLx/q0pP19dS7PMXu4d01QvKpow3XDfqZYZ
	M6v654nNNzc/KhOIs5MTbWz7u3mh7v5lPBf37OxiO/V+ubdZ/M/jvrcEzrnsNLvov3Vmspvy
	2znSH2ZWp6UXTTDhnsMsv2DPxeyHT+b5qXccWdQrFMBbNqvlVe/8QE9VZbeXXyQmz1eY63dE
	iaU4I9FQi7moOBEAqHQEBsQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code in the dwc3 probe effectively disables runtime pm
from ever working because it calls a get() that was never put() until
device removal.  Change the runtime pm code to match the standard
formula and allow runtime pm to function.

Note that this doesn't enable full runtime pm on the DWC3 device in
that the port isn't put into a lower power mode when not used.
However it does allow users of dwc3 (like dwc3-exynos) to do some
amount of runtime power management.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/usb/dwc3/core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 3a4004a..59c2494 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -453,6 +453,7 @@ static int dwc3_probe(struct platform_device *pdev)
 	if (of_get_property(node, "tx-fifo-resize", NULL))
 		dwc->needs_fifo_resize = true;
 
+	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 	pm_runtime_get_sync(dev);
 	pm_runtime_forbid(dev);
@@ -517,6 +518,7 @@ static int dwc3_probe(struct platform_device *pdev)
 		goto err2;
 	}
 
+	pm_runtime_put(dev);
 	pm_runtime_allow(dev);
 
 	return 0;
@@ -543,6 +545,7 @@ err1:
 
 err0:
 	dwc3_free_event_buffers(dwc);
+	pm_runtime_disable(&pdev->dev);
 
 	return ret;
 }
@@ -554,7 +557,6 @@ static int dwc3_remove(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	dwc3_debugfs_exit(dwc);
-- 
1.7.6.5


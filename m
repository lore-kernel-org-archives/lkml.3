Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab3CFH5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:57:44 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:47500 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab3CFH5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:57:41 -0500
X-AuditID: cbfee68d-b7f636d0000009be-ad-5136f6f4712b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 30/30] rtc: rtc-wm831x: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:57:37 +0900
Message-id: <009801ce1a40$46b3f130$d41bd390$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAWkzQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zQ90v38wCDY4vsLC4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZjT8nsxVs4ag4MqeXuYHxN1sXIyeHhICJxJN1jcwQtpjEhXvr
	geJcHEICyxgldrT/Y4Epmvb/MpgtJLCIUeLoEgWIotlMEgsXPmEFSbAJqEl8+XKYvYuRg0NE
	QF+irUUDpIZZoJdR4kzvbrC4kICtRM88HpByTgE7iSkTH7OD2MICnhIHP89nArFZBFQlZi88
	ChbnBSo/cnQPE4QtKPFj8j2wG5gFtCTW7zzOBGHLS2xe85YZZLyEgLrEo7+6IGERASOJN69n
	MEKUiEjse/GOEeQcCYFl7BJ/755mhtglIPFt8iEWiF5ZiU0HoOEgKXFwxQ2WCYwSs5BsnoVk
	8ywkm2chWbGAkWUVo2hqQXJBcVJ6kaFecWJucWleul5yfu4mRkhc9e5gvH3A+hBjMtD6icxS
	osn5wLjMK4k3NDY2MTMxNTG3NDU3JU1YSZxX7pJMoJBAemJJanZqakFqUXxRaU5q8SFGJg5O
	qQZG8efV7PM3TnjHwGavIyLDZOJXHx1j8OC21raI/Mj3Vy/0xE+WXHBz7uzkqH+MmTrJXoXh
	OSyfjXW3lZeyrd3tErAnYaXWxuwp+en34n1c9RTPBdU/XbQ2WmL1oXfOu+PY5xxclSC9j8//
	rOuc+TZfIqyzfh55K7Ivd83Hp5bFgVo2V0NPHXuhxFKckWioxVxUnAgAuA5BA8ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO6Xb2aBBtd+GVlc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjMafk9kKtnBUHJnTy9zA
	+Juti5GTQ0LARGLa/8ssELaYxIV768HiQgKLGCWOLlHoYuQCsmczSSxc+IQVJMEmoCbx5cth
	9i5GDg4RAX2JthYNkBpmgV5GiTO9u8HiQgK2Ej3zeEDKOQXsJKZMfMwOYgsLeEoc/DyfCcRm
	EVCVmL3wKFicF6j8yNE9TBC2oMSPyffA7mEW0JJYv/M4E4QtL7F5zVtmkPESAuoSj/7qgoRF
	BIwk3ryewQhRIiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0
	L10vOT93EyM4ap9J72Bc1WBxiFGAg1GJh3eCilmgEGtiWXFl7iFGCQ5mJRFerjNAId6UxMqq
	1KL8+KLSnNTiQ4zJQI9OZJYSTc4HJpS8knhDYxMzI0sjMwsjE3Nz0oSVxHkZTz0JEBJITyxJ
	zU5NLUgtgtnCxMEp1cCotffL381fetdPU/0UluR3cd67j3ErtF9pnlxlwHOyjeF1SIRM29pG
	Swsh5sD+5Mp0O93H2zMnp8bLpDWt91/V95SxZ9/yx1v0zCpm3guTfND12kRdllWUeYZOe8Kf
	aL++/F2sT5rKFpVP9S35xSezU+XehynZ96W1p60MdRDq0nrUJrvqgboSS3FGoqEWc1FxIgAU
	YDevHgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- used 'struct device *dev' as the first argument

 drivers/rtc/rtc-wm831x.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-wm831x.c b/drivers/rtc/rtc-wm831x.c
index 2f0ac7b..8d65b94 100644
--- a/drivers/rtc/rtc-wm831x.c
+++ b/drivers/rtc/rtc-wm831x.c
@@ -436,7 +436,7 @@ static int wm831x_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	wm831x_rtc->rtc = rtc_device_register("wm831x", &pdev->dev,
+	wm831x_rtc->rtc = devm_rtc_device_register(&pdev->dev, "wm831x",
 					      &wm831x_rtc_ops, THIS_MODULE);
 	if (IS_ERR(wm831x_rtc->rtc)) {
 		ret = PTR_ERR(wm831x_rtc->rtc);
@@ -462,10 +462,6 @@ err:
 
 static int wm831x_rtc_remove(struct platform_device *pdev)
 {
-	struct wm831x_rtc *wm831x_rtc = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(wm831x_rtc->rtc);
-
 	return 0;
 }
 
-- 
1.7.2.5



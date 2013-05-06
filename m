Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab3EFER0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:17:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31429 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab3EFERZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:17:25 -0400
X-AuditID: cbfee690-b7f136d000000fea-7b-51872ed48b46
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "Jett.Zhou" <jtzhou@marvell.com>
Subject: [PATCH 2/8] 88pm860x_charger: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 13:17:24 +0900
Message-id: <003701ce4a10$9c4a72e0$d4df58a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KEIjZw7ixEiUvTlaErnVXeU/qFg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zI90reu2BBqe/iFsc3KppMXHlZGaL
	ZX8eMltc3jWHzYHFY0L/J0aPzSu0PCYvvMjs8XmTXABLFJdNSmpOZllqkb5dAlfGwc6nrAX7
	2StOnX/J2MC4iq2LkZNDQsBEovv0FlYIW0ziwr31QHEuDiGBZYwSfR97mboYOcCKbn8pgohP
	Z5SY93gzVNEvRom511eBdbMJqEl8+XKYHcQWEdCQaFs9hQXEZhbIlTi75hkTiC0sECBxcddh
	MJtFQFXi2v1ZYL28ApYSx49vZIOwBSV+TL4H1aslsX7ncSYIW15i85q3zBCXKkjsOPuaEWKX
	nsSZky9ZIWpEJPa9eMcIcpyEwDp2iY0TH0ItE5D4NvkQC8Q3shKbDkDNkZQ4uOIGywRGsVlI
	Vs9CsnoWktWzkKxYwMiyilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMkxibsYLx3wPoQYzLQ
	+onMUqLJ+cAYzSuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QDIyeryNfwzqcPSrdELmkJedUj73ulrzS5Jpoz6IbJ4wm3vRLk2pZPTWTWXHqvrZD5
	hX/NT3mTO/PeT/qaezRfIybnBrfbsbdSn9JZ3u2zWfNq89bos7+PnXRc89ubZ5HqsQNP3xkJ
	3HqStPdPgWG9/T6z6OIZ1S+fzbeLX6Hs5D8h3DbwnnSaqxJLcUaioRZzUXEiAO//d2LHAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jQd0reu2BBtunilgc3KppMXHlZGaL
	ZX8eMltc3jWHzYHFY0L/J0aPzSu0PCYvvMjs8XmTXABLVAOjTUZqYkpqkUJqXnJ+SmZeuq2S
	d3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QRiWFssScUqBQQGJxsZK+HaYJoSFuuhYw
	jRG6viFBcD1GBmggYR1jxsHOp6wF+9krTp1/ydjAuIqti5GDQ0LAROL2l6IuRk4gU0ziwr31
	QGEuDiGB6YwS8x5vhnJ+MUrMvb6KFaSKTUBN4suXw+wgtoiAhkTb6iksIDazQK7E2TXPmEBs
	YYEAiYu7DoPZLAKqEtfuzwLr5RWwlDh+fCMbhC0o8WPyPaheLYn1O48zQdjyEpvXvGWGuEhB
	YsfZ14wQu/Qkzpx8yQpRIyKx78U7xgmMArOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddI
	rzgxt7g0L10vOT93EyM4gp9J72Bc1WBxiFGAg1GJh7fgSVugEGtiWXFl7iFGCQ5mJRFen71A
	Id6UxMqq1KL8+KLSnNTiQ4zJQJ9OZJYSTc4HJpe8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloH
	CgmkJ5akZqemFqQWwWxh4uCUamBs3Bu0IXoO286Tv37sTzrmoGzj3s2W5zt7qnayqZC61QmP
	6FIb/mumFuKnY64nMaz4FHhSel/gT/db1t6X4p+9zFBzvTevyOzqgujUHdmzWLfr2mwwYnVK
	3f+tI67gaJuGy5lM9wUVp49HsKjGthx5eLPQO1X79/L8vb/n89qft10dvHyKR7cSS3FGoqEW
	c1FxIgDls3luJAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/88pm860x_charger.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/power/88pm860x_charger.c b/drivers/power/88pm860x_charger.c
index 36fb4b5..ffff66b 100644
--- a/drivers/power/88pm860x_charger.c
+++ b/drivers/power/88pm860x_charger.c
@@ -722,7 +722,6 @@ static int pm860x_charger_remove(struct platform_device *pdev)
 	struct pm860x_charger_info *info = platform_get_drvdata(pdev);
 	int i;
 
-	platform_set_drvdata(pdev, NULL);
 	power_supply_unregister(&info->usb);
 	free_irq(info->irq[0], info);
 	for (i = 0; i < info->irq_nums; i++)
-- 
1.7.2.5



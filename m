Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762471Ab3ECGRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:17:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19284 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762085Ab3ECGRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:17:52 -0400
X-AuditID: cbfee691-b7fe56d000004b96-aa-5183568e545a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        jgunthorpe@obsidianresearch.com
Subject: [PATCH 2/4] backlight: ep93xx: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:17:50 +0900
Message-id: <000c01ce47c5$f063e110$d12ba330$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HxeHaJT0uBjU+Q7WTT0XINo44BA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zY92+sOZAg7M7jCzmrF/DZvH9hqnF
	5V1z2Cx273rK6sDicWLGbxaP7zt6GT32zP/B6vF5k1wASxSXTUpqTmZZapG+XQJXxq9LN9kK
	/rJVtHy6y97A+Im1i5GTQ0LAROJ1wx4oW0ziwr31bF2MXBxCAssYJZ7MucwMU3R+3RSoxCJG
	iSvT5rBAOL8YJZ4fP8cEUsUmoCbx5cth9i5GDg4RAX2JthYNkDCzQJHE4wMQG4QFgiV+TD8B
	Vs4ioCqx/2gDI4jNK2Ap8WX6AyhbUOLH5HssEL1aEut3HmeCsOUlNq95C3WQgsSOs6/B6kUE
	9CS+zTjJDFEjIrHvxTtGiJp17BJPLipC7BKQ+Db5EAvIaRICshKbDkCNkZQ4uOIGywRGsVlI
	Ns9CsnkWks2zkGxYwMiyilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMkxibuYLx/wPoQYzLQ
	+onMUqLJ+cAYzSuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QD44oLR98zPQ35EvfYo8/79OXdXZ2Lb0UeeB+VuzA9QDnukvvRhQo/hQ4fuu0SLp1j
	oaJRzNoWsXCj1ZnTO2L/lH//c+O+GpPeUesJjK9LFsj8iz6mY5aXXhshabpYqtPo9ocwpg+2
	e/xqlJ6t+Nx9dfGK24fn806bX1HYtHFH6P2Y/fqnTj+uP6TEUpyRaKjFXFScCABlwUJWxwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jAd2+sOZAg3vv9CzmrF/DZvH9hqnF
	5V1z2Cx273rK6sDicWLGbxaP7zt6GT32zP/B6vF5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8avSzfZCv6yVbR8usvewPiJtYuRk0NCwETi/LopbBC2mMSFe+uB
	bC4OIYFFjBJXps1hgXB+MUo8P36OCaSKTUBN4suXw+xdjBwcIgL6Em0tGiBhZoEiiccH9oAN
	FRYIlvgx/QRYOYuAqsT+ow2MIDavgKXEl+kPoGxBiR+T77FA9GpJrN95nAnClpfYvOYtM8RB
	ChI7zr4GqxcR0JP4NuMkM0SNiMS+F+8YJzAKzEIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0
	XCO94sTc4tK8dL3k/NxNjOAYfia9g3FVg8UhRgEORiUeXoWWpkAh1sSy4srcQ4wSHMxKIrxu
	P4BCvCmJlVWpRfnxRaU5qcWHGJOBPp3ILCWanA9ML3kl8YbGJmZGlkZmFkYm5uakCSuJ8x5s
	tQ4UEkhPLEnNTk0tSC2C2cLEwSnVwMh+91NUQ2Lu7BsR4fpb1FR7zu9gPlOgvkrx3MeDCau4
	1ibe3PNMaf+/dWyVgm4dySL8xm5Zn/YJJzJy//62RUHq9KvULftqpvc5ObX5p/9qND28u9vh
	96SdRu5pu818Ihz4ShkF1nVFz/qw8Ncdu8hzAc6f4lYfjO5psU0zuqtrsfxy4e6J6UosxRmJ
	hlrMRcWJALGGYUElAwAA
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
 drivers/video/backlight/ep93xx_bl.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
index 3345582..018368b 100644
--- a/drivers/video/backlight/ep93xx_bl.c
+++ b/drivers/video/backlight/ep93xx_bl.c
@@ -111,7 +111,6 @@ static int ep93xxbl_remove(struct platform_device *dev)
 	struct backlight_device *bl = platform_get_drvdata(dev);
 
 	backlight_device_unregister(bl);
-	platform_set_drvdata(dev, NULL);
 	return 0;
 }
 
-- 
1.7.2.5



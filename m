Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3EFEM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:12:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:47736 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3EFEM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:12:26 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-3d-51872da8560b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 6/8] mfd: t7l66xb: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 13:12:24 +0900
Message-id: <003301ce4a0f$e9a1c120$bce54360$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KD5r57CoXUK6gT66oMVn/IV2qPg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t8zfd0Vuu2BBtteqVtcXniJ1eLyrjls
	Fqe7WR2YPeadDPTo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujEO/dzAWHGWrONYyl6WBcQ9r
	FyMHh4SAiUTrm7guRk4gU0ziwr31bF2MXBxCAssYJeY+fMgMkTCR+LfjIhNEYhGjxKn3y1kh
	nF+MEnePbGYFqWITUJP48uUwO4gtIqAl0X3sPBuIzSzgJPFzy0wWEFtYwEfizcZdTCA2i4Cq
	xLwZd8HqeQUsJfYf2soIYQtK/Jh8jwWiV0ti/c7jTBC2vMTmNW+hLlKQ2HH2NSPELj2JafeP
	s0PUiEjse/GOEeQ4CYF57BKrF/YxQywTkPg2+RALxMuyEpsOQM2RlDi44gbLBEaxWUhWz0Ky
	ehaS1bOQrFjAyLKKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIySe+nYw3jxgfYgxGWj9RGYp
	0eR8YDzmlcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNT
	qoGxn6/ULGqH99WywzYSqUuz1qUZiAeIL74xJd3oWnKH+BLuOZqq2z06kq41tX7dveNY/4aT
	xxcJLKtYLBxYHLLnQMG9VzNelsr4cWydcOnBVu+1fvKewrzdO+2Dclb4cE40C3/1Sfj2phjb
	9Ji1d84qlUmk7n62kZXr9vYqryeVledbFZzrIqYpsRRnJBpqMRcVJwIAf9gmP70CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xgO4K3fZAgylLVSwuL7zEanF51xw2
	i9PdrA7MHvNOBnr0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6h
	pYW5kkJeYm6qrZKLT4CuW2YO0B4lhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZo
	IGEdY8ah3zsYC46yVRxrmcvSwLiHtYuRk0NCwETi346LTBC2mMSFe+vZuhi5OIQEFjFKnHq/
	nBXC+cUocffIZrAONgE1iS9fDrOD2CICWhLdx86zgdjMAk4SP7fMZAGxhQV8JN5s3AU2lUVA
	VWLejLtg9bwClhL7D21lhLAFJX5MvscC0aslsX7ncSYIW15i85q3zBAXKUjsOPuaEWKXnsS0
	+8fZIWpEJPa9eMc4gVFgFpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn
	525iBMfrM+kdjKsaLA4xCnAwKvHwFjxpCxRiTSwrrsw9xCjBwawkwuuzFyjEm5JYWZValB9f
	VJqTWnyIMRno04nMUqLJ+cBUklcSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC
	1CKYLUwcnFINjFx6b2b5PVHkU4v266mX2u4/aRH/nDNXf76J0t1mMfth+unJDOpzJ19/trs1
	i+vKc7bL0ge0/D0so6w+b3htVLpxqXDNUg5GpotVa9zCjJ92t58PO8R/T/LN+YdCdVL2p0q0
	YpjjzyS6novdXh1vt7tYZbpg02H/Wz6PRD++/pTJeOiA+DzfWCWW4oxEQy3mouJEAEpOj5cb	AwAA
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
 drivers/mfd/t7l66xb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
index b32940e..a21bff2 100644
--- a/drivers/mfd/t7l66xb.c
+++ b/drivers/mfd/t7l66xb.c
@@ -422,7 +422,6 @@ static int t7l66xb_remove(struct platform_device *dev)
 	iounmap(t7l66xb->scr);
 	release_resource(&t7l66xb->rscr);
 	mfd_remove_devices(&dev->dev);
-	platform_set_drvdata(dev, NULL);
 	kfree(t7l66xb);
 
 	return ret;
-- 
1.7.2.5



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab3EFEOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:14:16 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43516 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3EFEOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:14:15 -0400
X-AuditID: cbfee690-b7f136d000000fea-ac-51872e16f8e5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 8/8] mfd: tc6393xb: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 13:14:14 +0900
Message-id: <003501ce4a10$2b326c20$81974460$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KEAqzsvYFrAIwSvuLmiCEVAB6Fg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t8zA10xvfZAg5071C0uL7zEanF51xw2
	i9PdrA7MHvNOBnr0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxq9JM9kKrrNVtG3ZzdLAeJ61
	i5GTQ0LARGL+51OMELaYxIV769m6GLk4hASWMUrs/vqTBaZo17dTLBCJ6YwSDx5Mg6r6xSix
	/WwnE0gVm4CaxJcvh9lBbBEBLYnuY+fZQGxmASeJn1tmgk0SFvCVOLvrNFg9i4CqxJZ1vcwg
	Nq+ApcTCQ7+gbEGJH5PvsUD0akms33mcCcKWl9i85i0zxEUKEjvOvmaE2KUnsfjET0aIGhGJ
	fS/eMYIcJyEwj13i36TpLBDLBCS+TT4EZHMAJWQlNh2AmiMpcXDFDZYJjGKzkKyehWT1LCSr
	ZyFZsYCRZRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGSERN2MF474D1IcZkoPUTmaVEk/OB
	EZlXEm9obGZkYWpiamxkbmlGmrCSOK96i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkau
	jXlxe45O5/txpFS5Iu2U8JMS/eyNRT7KooIW8iGK2yxsX/VNOp3Yrn/jfB6TQNVSn8d7rYtm
	HXzx7M6iI8m7FBt46voML6uvzThSX7vz3XeRKxUT3z5U3R5v9zaS0XLvKQul/pCPS/dxaZ2K
	jfaZKSL3Y/LTWbLVnxfP+WvunVD2M1zEr0mJpTgj0VCLuag4EQARM22VvgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xoK6YXnugweMGFYvLCy+xWlzeNYfN
	4nQ3qwOzx7yTgR59W1YxenzeJBfAHNXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGto
	aWGupJCXmJtqq+TiE6DrlpkDtEdJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEa
	SFjHmPFr0ky2gutsFW1bdrM0MJ5n7WLk5JAQMJHY9e0UC4QtJnHh3nq2LkYuDiGB6YwSDx5M
	g3J+MUpsP9vJBFLFJqAm8eXLYXYQW0RAS6L72Hk2EJtZwEni55aZYJOEBXwlzu46DVbPIqAq
	sWVdLzOIzStgKbHw0C8oW1Dix+R7LBC9WhLrdx5ngrDlJTavecsMcZGCxI6zrxkhdulJLD7x
	kxGiRkRi34t3jBMYBWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7u
	JkZwvD6T2sG4ssHiEKMAB6MSD2/Bk7ZAIdbEsuLK3EOMEhzMSiK8PnuBQrwpiZVVqUX58UWl
	OanFhxiTgT6dyCwlmpwPTCV5JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgt
	gtnCxMEp1cDouOKq1TyHGoYuDo3PGptm1qx7tGeB2azli+bwbRX5/snzoUDl1MkyHg6aEeEf
	ll8racg6NuE8g+kGud0XnRb7+tfP5XrDlBop42kYVXT78wLWp4x7nm1PbHs176qXStGsZsEj
	gfPmzD63dZUJZ9E2Zt7Xu2d+Ezu8ICXCx3ZBlc2zqUZ90QVdSizFGYmGWsxFxYkAuejiWxsD	AAA=
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
 drivers/mfd/tc6393xb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
index 15e1463..a563dfa 100644
--- a/drivers/mfd/tc6393xb.c
+++ b/drivers/mfd/tc6393xb.c
@@ -756,7 +756,6 @@ static int tc6393xb_remove(struct platform_device *dev)
 	clk_disable(tc6393xb->clk);
 	iounmap(tc6393xb->scr);
 	release_resource(&tc6393xb->rscr);
-	platform_set_drvdata(dev, NULL);
 	clk_put(tc6393xb->clk);
 	kfree(tc6393xb);
 
-- 
1.7.2.5



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3IWBi2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 21:38:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33016 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab3IWBi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 21:38:27 -0400
X-AuditID: cbfee68e-b7f756d000004512-26-523f9b928073
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003101ceb7fd$21e97540$65bc5fc0$%han@samsung.com>
In-reply-to: <003101ceb7fd$21e97540$65bc5fc0$%han@samsung.com>
Subject: [PATCH 4/4] misc: pti: remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 10:38:26 +0900
Message-id: <003501ceb7fd$98fc3f00$caf4bd00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac63/SHKB4kHrvrSQPCGprHejMhtRAAAFNLQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zI91Js+2DDP6tELH4O+kYu0Xz4vVs
	FpcXXmK1uLxrDpsDi8fvX5MYPfbPXcPu0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBnrFr1m
	KZjFWvHr1UHWBsaFLF2MnBwSAiYSt1/2sULYYhIX7q1n62Lk4hASWMYo8fvASkaYot8XbjGB
	2EIC0xklln63gij6xSixt/MwO0iCTUBN4ssXCFtEwFRi4/spYM3MAukSd452QjXbSizduJQZ
	xOYUsJN49/MnmC0s4CKx89w+sBoWAVWJtqYLYHFeoPoLf++yQdiCEj8m32OBmKklsX7ncSYI
	W15i85q3QPUcQIeqSzz6qwtxgpHE3D9ToMpFJPa9eMcIcrOEwDF2icW7/7BC7BKQ+Db5EAtE
	r6zEpgPMEP9KShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJReZKRXnJhbXJqX
	rpecn7uJERKVfTsYbx6wPsSYDLR+IrOUaHI+MKrzSuINjc2MLExNTI2NzC3NSBNWEudVa7EO
	FBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDYeu+87jXDV5sOCD9WqXoZVMqQIGxvVTv1Q8/+
	iBd3/XZcvZAz45uC7t6C5c3ntppN9khZEafsdfUe5wlO2wUL34m1iocEMXg8UrLY6hkvrN/U
	2nPt7wTph5GFt0QjfUQvaAZtS/dWdcvP5D7Ub36g6UBznzvLrx6h+b8nrjHx0l9l8WRfNIsS
	S3FGoqEWc1FxIgD901DI4AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQd1Js+2DDOa8FbD4O+kYu0Xz4vVs
	FpcXXmK1uLxrDpsDi8fvX5MYPfbPXcPu0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZ6xa9ZimYxVrx69VB1gbGhSxdjJwcEgImEr8v3GKCsMUkLtxb
	zwZiCwlMZ5RY+t2qi5ELyP7FKLG38zA7SIJNQE3iyxcIW0TAVGLj+ymMIDazQLrEnaOdTBDN
	thJLNy5lBrE5Bewk3v38CWYLC7hI7Dy3D6yGRUBVoq3pAlicF6j+wt+7bBC2oMSPyfdYIGZq
	SazfeZwJwpaX2LzmLVA9B9Ch6hKP/upCnGAkMffPFKhyEYl9L94xTmAUmoVk0iwkk2YhmTQL
	ScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMEx/0x6B+OqBotDjAIcjEo8vJGJ9kFC
	rIllxZW5hxglOJiVRHibOoFCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9MR3kl8YbGJmZG
	lkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwDjZbsm1+GmJH5Y92tBieEd/
	bebeY0mx5+c0PC6bICP4K6BAx4j7OOe13Ruv7pT7X2i4u+Cx9fPSKHXh3ie1iwzO6C5pePar
	RCJtdifX93kH1hk+5U4NO3giLbDM4LNjZtejA5+Mv6+13uYTz2W0xuycq8G27TxnHJ9+Ptg9
	f5HiOw6d2a4GF5YqsRRnJBpqMRcVJwIAikVlpD0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/misc/pti.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/misc/pti.c b/drivers/misc/pti.c
index f84ff0c..eda38cb 100644
--- a/drivers/misc/pti.c
+++ b/drivers/misc/pti.c
@@ -892,7 +892,6 @@ static void pti_pci_remove(struct pci_dev *pdev)
 	}
 
 	iounmap(drv_data->pti_ioaddr);
-	pci_set_drvdata(pdev, NULL);
 	kfree(drv_data);
 	pci_release_region(pdev, 1);
 	pci_disable_device(pdev);
-- 
1.7.10.4



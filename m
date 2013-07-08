Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3GHF2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 01:28:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48232 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3GHF2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 01:28:18 -0400
X-AuditID: cbfee68f-b7f436d000000f81-5d-51da4defd9d9
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: "'Bjorn Helgaas'" <bhelgaas@google.com>
References: 
In-reply-to: 
Subject: [PATCH]  PCI: fix typo in iov.c
Date: Mon, 08 Jul 2013 14:28:14 +0900
Message-id: <00a301ce7b9b$f1c9bac0$d55d3040$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqg8eAAkzGCMAAA5gYwAMf3LxAFffBYYAICyd8w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zI933vrcCDS4dZbdY0pRhsaSZ2+Ly
	rjlsDsweCzaVevRtWcXo8XmTXABzFJdNSmpOZllqkb5dAldG9+yPrAXrWSs65pU1MK5n6WLk
	5JAQMJFYeWwVO4QtJnHh3no2EFtIYBmjxMN7mjA11/9/Ze5i5AKKLwKKLz8M5fxllLj0/QYT
	SBWbgK7EsfVbWEFsEQFviVNTfgEVcXAwC2hKHPjvCWIKCXBLrG4OAqngFOCRWPenkxnEFhbQ
	kJi/pgXsBhYBVYmPL1eC2bwCdhJH5k9jgrAFJX5Mvgd2M7OAlsT6nceZIGx5ic1r3oJtkhBQ
	l3j0VxfkMhGBGYwS//4dY4WoEZHY9+IdI0hCQmAfu0Rv0xYWiGUCEt8mH2KBaJaV2HSAGeJf
	SYmDK26wTGCUmIVk9Swkq2chWT0LyYoFjCyrGEVTC5ILipPSi4z1ihNzi0vz0vWS83M3MULi
	rn8H490D1ocYk4HWT2SWEk3OB8ZtXkm8obGZkYWpiamxkbmlGWnCSuK8ai3WgUIC6Yklqdmp
	qQWpRfFFpTmpxYcYmTg4pRoY1Xe8WG6Zr7HK+/epVdrWTKlVEVoMJRV5JjHMB/b1531cJhrM
	X35c2eJ+pHQX0+SrtvLTX1aEf+lWt2UtFgwP+ZMd4vxi/UsxPpfnXgu4H9z+OGlCQmjLkeuP
	hP/drbBkOHU79kHPn52qxW+OVLVd+fvkji9retiLKeWzX0rsymn+XnJ/pVKsEktxRqKhFnNR
	cSIAYlx7JNECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAd33vrcCDRpaWSyWNGVYLGnmtri8
	aw6bA7PHgk2lHn1bVjF6fN4kF8Ac1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hp
	Ya6kkJeYm2qr5OIToOuWmQO0RkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpI
	WMeY0T37I2vBetaKjnllDYzrWboYOTkkBEwkrv//ygxhi0lcuLeerYuRi0NIYBGjxMPlh5kh
	nL+MEpe+32ACqWIT0JU4tn4LK4gtIuAtcWrKL6AiDg5mAU2JA/89QUwhAW6J1c1BIBWcAjwS
	6/50gs0XFtCQmL+mhR3EZhFQlfj4ciWYzStgJ3Fk/jQmCFtQ4sfke2C3MQtoSazfeZwJwpaX
	2LzmLdgmCQF1iUd/dUEuExGYwSjx798xVogaEYl9L94xTmAUmoVk1Cwko2YhGTULScsCRpZV
	jKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFx/Ux6B+OqBotDjAIcjEo8vBKnbwYKsSaWFVfm
	HmKU4GBWEuEVZ70VKMSbklhZlVqUH19UmpNafIgxGejTicxSosn5wJSTVxJvaGxiZmRpZGZh
	ZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MJlU9H4V/Mx9/cGpvpP363x9umXsw
	5rOc6JmcW/OQ5WT4w2WLerwUe/eUuD8MkZn7h814E/+XSI6SnoWr0i3bP1ozyN9yXqO6MWGv
	kfLuoJuejsseu1z+trfl1iElrveHVXv4RE6snrFa89opnVA5hlrllLsXj9XVRR+wzY9Keq3k
	oujQtLJHiaU4I9FQi7moOBEAg8EMLS8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devic3 should be device.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/pci/iov.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index de8ffac..de4034e 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -786,7 +786,7 @@ int pci_sriov_set_totalvfs(struct pci_dev *dev, u16
numvfs)
 EXPORT_SYMBOL_GPL(pci_sriov_set_totalvfs);
 
 /**
- * pci_sriov_get_totalvfs -- get total VFs supported on this devic3
+ * pci_sriov_get_totalvfs -- get total VFs supported on this device
  * @dev: the PCI PF device
  *
  * For a PCIe device with SRIOV support, return the PCIe
-- 
1.7.9.5


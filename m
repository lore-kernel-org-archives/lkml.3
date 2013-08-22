Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab3HVCMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:12:45 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32595 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab3HVCMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:12:43 -0400
X-AuditID: cbfee691-b7fef6d000002d62-b3-521573903c1e
From: Jingoo Han <jg1.han@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Maxim Levitsky'" <maximlevitsky@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] memstick: host: remove unnecessary platform_set_drvdata()
Date: Thu, 22 Aug 2013 11:12:31 +0900
Message-id: <002301ce9edd$0f2f4440$2d8dccc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6e3Q8Wpd2WZNbQTZahX9LJB086yQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zQ90JxaJBBkc2yVjMWb+GzeLywkus
	Fpd3zWGzeHNyEbsDi8fOWXfZPU7M+M3i0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBlnVzYy
	Fyxlq1gwezlLA+MS1i5GTg4JAROJ3pOLGSFsMYkL99azdTFycQgJLGOUOHxyAyNM0a2TO1gg
	EtMZJW6+2c8E4fxilNjb84oZpIpNQE3iy5fD7CC2iICuxKrnu8DizAJFErse7mMCsYUFvCSe
	338KZHNwsAioSpxvlwYJ8wrYSmxues8CYQtK/Jh8jwWiVUti/c7jTBC2vMTmNW+ZQVolBNQl
	Hv3VhdikJ9H3bxVUiYjEvhfvGEFOkxDYxC7Rcugj2JcsAgIS3yYfYoHolZXYdIAZ4i9JiYMr
	brBMYBSbhWTzLCSbZyHZPAvJigWMLKsYRVMLkguKk9KLTPWKE3OLS/PS9ZLzczcxQqJs4g7G
	+wesDzEmA62fyCwlmpwPjNK8knhDYzMjC1MTU2Mjc0sz0oSVxHnVW6wDhQTSE0tSs1NTC1KL
	4otKc1KLDzEycXBKNTD2/F34/M9mTw/pIsdX7GzdzZsXrrPiKdkSdq8wtjmJL2Bl9B7PKwVb
	ZjtuXDlpZYXk/+dtj1X8tncvOWXDdOGFwHu/xtun+SXSgvdt+3LTimdK4H925w1nf31SZo/r
	NqoL/Sc870Lh5A3lEV1mSR7tObN6fEvzedY32f62CZ++s+fmAwXBJ95KLMUZiYZazEXFiQAj
	VO3ryAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQd0JxaJBBo8vSljMWb+GzeLywkus
	Fpd3zWGzeHNyEbsDi8fOWXfZPU7M+M3i0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZZ1c2MhcsZatYMHs5SwPjEtYuRk4OCQETiVsnd7BA2GISF+6t
	Z+ti5OIQEpjOKHHzzX4mCOcXo8TenlfMIFVsAmoSX74cZgexRQR0JVY93wUWZxYoktj1cB8T
	iC0s4CXx/P5TIJuDg0VAVeJ8uzRImFfAVmJz03sWCFtQ4sfkeywQrVoS63ceZ4Kw5SU2r3nL
	DNIqIaAu8eivLsQmPYm+f6ugSkQk9r14xziBUWAWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQn
	peca6RUn5haX5qXrJefnbmIEx/Az6R2MqxosDjEKcDAq8fBe2CkSJMSaWFZcmXuIUYKDWUmE
	V1pLNEiINyWxsiq1KD++qDQntfgQYzLQnxOZpUST84HpJa8k3tDYxMzI0sjMwsjE3Jw0YSVx
	3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGBeHu27YxOc/+8hXG+e19rvTeI58WKxu7eL/nnEy
	14ZHIS4XFUJCPs2dOFVI2kVM0nuumOwxZ59jt93yZKy8OyTbDkkwSd27+D4l9MN92a4DIhzM
	nG41jzakvV23QUez/6GZwc8cs62C6TKqtrF5nNbZTlksfSsfll99ud51E/+EKn7BpY0LlViK
	MxINtZiLihMB+EcvmCUDAAA=
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
 drivers/memstick/host/rtsx_pci_ms.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/memstick/host/rtsx_pci_ms.c b/drivers/memstick/host/rtsx_pci_ms.c
index 64a779c..5c3ca40 100644
--- a/drivers/memstick/host/rtsx_pci_ms.c
+++ b/drivers/memstick/host/rtsx_pci_ms.c
@@ -613,8 +613,6 @@ static int rtsx_pci_ms_drv_remove(struct platform_device *pdev)
 	memstick_remove_host(msh);
 	memstick_free_host(msh);
 
-	platform_set_drvdata(pdev, NULL);
-
 	dev_dbg(&(pdev->dev),
 		": Realtek PCI-E Memstick controller has been removed\n");
 
-- 
1.7.10.4



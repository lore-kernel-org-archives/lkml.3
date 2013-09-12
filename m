Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab3ILGja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:39:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:37391 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab3ILGj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:39:28 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-92-5231619e1917
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Hans J. Koch'" <hjk@hansjkoch.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001001ceaf82$978a36f0$c69ea4d0$%han@samsung.com>
In-reply-to: <001001ceaf82$978a36f0$c69ea4d0$%han@samsung.com>
Subject: [PATCH 4/5] uio: uio_netx: remove unnecessary pci_set_drvdata()
Date: Thu, 12 Sep 2013 15:39:26 +0900
Message-id: <001301ceaf82$d3344330$799cc990$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6vgpOjT534nRYfSDiuPQlOOHeZTQAADIqA
Content-language: ko
x-cr-hashedpuzzle: JbFl MG3c QzPx Sn2a arJj cp6E fLbI guOc jVHq jmj3 kjzR oUzi
 pvnb rABK t/Pc
 ufCH;4;ZwByAGUAZwBrAGgAQABsAGkAbgB1AHgAZgBvAHUAbgBkAGEAdABpAG8AbgAuAG8AcgBnADsAaABqAGsAQABoAGEAbgBzAGoAawBvAGMAaAAuAGQAZQA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnAA==;Sosha1_v1;7;{C674905B-E3F5-4B2B-A380-91B633E3761B};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 12 Sep 2013 06:39:19
 GMT;WwBQAEEAVABDAEgAIAA0AC8ANQBdACAAdQBpAG8AOgAgAHUAaQBvAF8AbgBlAHQAeAA6ACAAcgBlAG0AbwB2AGUAIAB1AG4AbgBlAGMAZQBzAHMAYQByAHkAIABwAGMAaQBfAHMAZQB0AF8AZAByAHYAZABhAHQAYQAoACkA
x-cr-puzzleid: {C674905B-E3F5-4B2B-A380-91B633E3761B}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t8zfd15iYZBBr/ni1g0L17PZnH07HR2
	i8sLL7FaXN41h82BxWP+Qy+P/XPXsHv0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxqVDLYwF
	x1grGl8LNzCeY+li5OSQEDCRePW8H8oWk7hwbz1bFyMXh5DAMkaJrplfmWGKVpzczg6RWMQo
	8ajrDyNIQkjgF6PEpv1yIDabgJrEly+H2UFsEQFTiY3vp4DVMAtkSxz7/pcFot5W4v3XJUwg
	NqeAncSUVSfAFggLeEisXn0brJ5FQFXi376pYPW8QPVT179lhrAFJX5MvscCMVNLYv3O40wQ
	trzE5jUgNRxAh6pLPPqrC3GCkUT71eVsECUiEvtevGMEuV9CYAqrxPaza9kg6k0lfmy1hIg/
	Ypd4deMhC8QNAhLfJh9igaiRldh0ABoOkhIHV9xgmcAoNQvJRbOQXDQLyUWzkKxewMiyilE0
	tSC5oDgpvchErzgxt7g0L10vOT93EyMkgifsYLx3wPoQYzLQ+onMUqLJ+cAEkFcSb2hsZmRh
	amJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxk6mE2sYZ+T3c1fy
	r3//bq7o7v8nz7ucPrdxkaSUA9+bq19OpNzZvfNf9sc5ExsXcIYzfxBUlVc/ZXbvW4moGL9p
	/OzNMgn8Bm2BQQIZlsGX4tVvfql+ej577tWgA8EMHzyZZz6YmLv9zRWHpRuEE+wDzt+xva5w
	ae08b93HmSZng/QzTv/ccUqJpTgj0VCLuag4EQCVngeO9gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAKsWRmVeSWpSXmKPExsVy+t9jAd15iYZBBtc2Clg0L17PZnH07HR2
	i8sLL7FaXN41h82BxWP+Qy+P/XPXsHv0bVnF6PF5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8alQy2MBcdYKxpfCzcwnmPpYuTkkBAwkVhxcjs7hC0mceHeerYu
	Ri4OIYFFjBKPuv4wgiSEBH4xSmzaLwdiswmoSXz5chisQUTAVGLj+ylgNcwC2RLHvv9lgai3
	lXj/dQkTiM0pYCcxZdUJZhBbWMBDYvXq22D1LAKqEv/2TQWr5wWqn7r+LTOELSjxY/I9FoiZ
	WhLrdx5ngrDlJTavAanhADpUXeLRX12IE4wk2q8uZ4MoEZHY9+IdI8j9EgJTWCW2n13LBlFv
	KvFjq+UERpFZSDbMQrJhFpINs5CMWsDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOD08
	k9rBuLLB4hCjAAejEg9vxyyDICHWxLLiytxDjBIczEoivPHmhkFCvCmJlVWpRfnxRaU5qcWH
	GJOBATCRWUo0OR+YuvJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJ
	g1OqgbHzV3/Wo3taFQ+5s57NvtlyykRBaKuBed5HPcPM32e/3Lr07B27rJ/xl6wua99wB6Pj
	zhaJ3x9ctd/Vsr5qVmpRCj/75D1BbC5nDDrmPNFkyHE5diZ8Z7F649UnWT9ubbY1K1FPjrVb
	6bEm9six+l2bt1VcKVKacVRft/epEeekPt0Ip8vf/iuxFGckGmoxFxUnAgA1wqVNUwMAAA==
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
 drivers/uio/uio_netx.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/uio/uio_netx.c b/drivers/uio/uio_netx.c
index 28a766b..4c345db 100644
--- a/drivers/uio/uio_netx.c
+++ b/drivers/uio/uio_netx.c
@@ -127,7 +127,6 @@ static void netx_pci_remove(struct pci_dev *dev)
 	uio_unregister_device(info);
 	pci_release_regions(dev);
 	pci_disable_device(dev);
-	pci_set_drvdata(dev, NULL);
 	iounmap(info->mem[0].internal_addr);
 
 	kfree(info);
-- 
1.7.10.4



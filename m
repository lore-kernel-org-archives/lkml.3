Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3HVCJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:09:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:47727 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab3HVCJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:09:16 -0400
X-AuditID: cbfee691-b7fef6d000002d62-e5-521572c84d0a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Hans J. Koch'" <hjk@hansjkoch.de>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] uio: uio_pruss: remove unnecessary platform_set_drvdata()
Date: Thu, 22 Aug 2013 11:09:12 +0900
Message-id: <002101ce9edc$981bb730$c8532590$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6e3JgCvWQxASzhTqmsbhxwneNENw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zI90TRaJBBldWyFs0L17PZnH07HR2
	i8sLL7FaXN41h82BxWP+Qy+P/XPXsHv0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxv+2j+wF
	61krnq4ya2DczNLFyMkhIWAicXZ/HzOELSZx4d56ti5GLg4hgWWMEj//b2eEKfq/fykTRGIR
	o8S33n9MIAkhgV+MEnvvO4DYbAJqEl++HGbvYuTgEBFQl/jZEgdiMgtUSizujgGpEBbwkri9
	+yTYXhYBVYk5Mz6zgpTwCthKHNteBRLmFRCU+DH5HlgJs4CWxPqdx5kgbHmJzWveMoOUSwAN
	f/RXFyQsIqAnsejEH1aIEhGJfS/eMYIcKSGwjV3iwItljBCrBCS+TT7EAtErK7HpANS3khIH
	V9xgmcAoNgvJ5llINs9CsnkWkhULGFlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYoTE1sQd
	jPcPWB9iTAZaP5FZSjQ5HxibeSXxhsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJpCeWpGanphak
	FsUXleakFh9iZOLglGpgXJ4hOpWhTrJF/s62i6yTvONWcJ2zrPoZ/2JpHp/Wq5sn1h9xvvTh
	wBP2uV4BF6e+XXz+htLzm3pb9nzxdGl+Hxde0zLzb5KmZcl8q46iTT/O3tWReyrQsGZ7xyTr
	H1ukrTMO5bzXvmg7/8n9ly8Wb70pIlT1QbzgU1qlTZG8/YlVN0su1Jcf2aPEUpyRaKjFXFSc
	CAC7UY1hwwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgO6JItEgg2uPpS2aF69nszh6djq7
	xeWFl1gtLu+aw+bA4jH/oZfH/rlr2D36tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMeN/20f2gvWsFU9XmTUwbmbpYuTkkBAwkfi/fykThC0mceHeerYu
	Ri4OIYFFjBLfev+BJYQEfjFK7L3vAGKzCahJfPlymL2LkYNDREBd4mdLHIjJLFApsbg7BqRC
	WMBL4vbuk2DjWQRUJebM+MwKUsIrYCtxbHsVSJhXQFDix+R7YCXMAloS63ceZ4Kw5SU2r3nL
	DFIuATT80V9dkLCIgJ7EohN/WCFKRCT2vXjHOIFRYBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQX
	FCel5xrpFSfmFpfmpesl5+duYgRH7jPpHYyrGiwOMQpwMCrx8F7YKRIkxJpYVlyZe4hRgoNZ
	SYRXWks0SIg3JbGyKrUoP76oNCe1+BBjMtCfE5mlRJPzgUklryTe0NjEzMjSyMzCyMTcnDRh
	JXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYO6Qbfv3VWClas14mfMrMlxNDX/2cteX16mi5
	PsGl++qUH+mJnChqCn42sW/2G4b8C9lPI9ecs/nA9s7Ha6+3zQV2w5d/1W+71xwLsHtYveR6
	7WyLDvdnEqqNrbI9fou1r7VtvnfijdGzaeaNj1/2/f+ueFW9/Vem4zx2Vq/Av1fi5nVp8bQL
	KbEUZyQaajEXFScCAJgnGtwgAwAA
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
 drivers/uio/uio_pruss.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/uio/uio_pruss.c b/drivers/uio/uio_pruss.c
index 21f7a72..df75346 100644
--- a/drivers/uio/uio_pruss.c
+++ b/drivers/uio/uio_pruss.c
@@ -224,7 +224,6 @@ static int pruss_remove(struct platform_device *dev)
 	struct uio_pruss_dev *gdev = platform_get_drvdata(dev);
 
 	pruss_cleanup(dev, gdev);
-	platform_set_drvdata(dev, NULL);
 	return 0;
 }
 
-- 
1.7.10.4



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab3EXBKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 21:10:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54878 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757810Ab3EXBKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 21:10:16 -0400
X-AuditID: cbfee691-b7fef6d000002d62-26-519ebdf67298
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vinod Koul'" <vinod.koul@intel.com>
Cc: "'Dan Williams'" <djbw@fb.com>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>, Li Yang <leoli@freescale.com>,
        "'Zhang Wei'" <zw@zh-kernel.org>
Subject: [PATCH] dma: use platform_{get,set}_drvdata()
Date: Fri, 24 May 2013 10:10:13 +0900
Message-id: <000301ce581b$720da060$5628e120$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5YGzy0MzAEpuBrR7C8ZQAi8AcgiQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zfd1ve+cFGjybJWqxuf8Bm8XlhZdY
	LX49ELK4vGsOm8XLvv0sFrcOfWR0YPOY2PyO3ePf4X4mj8V7XjJ59G1ZxejxeZOcx91pLxgD
	2KK4bFJSczLLUov07RK4MpY/fMZUcEO44s61s+wNjLsFuhg5OCQETCTWNCd3MXICmWISF+6t
	ZwOxhQSWMUqcO1oNETeRWHCjibmLkQsovohR4um8lawQzi9GieNXT7OCVLEJqEl8+XKYHWSo
	iIC6xNLrMiA1zAKLGSUWPd7BDBIXFjCTeHmtAqScRUBVYsmVs2DLeAUsJX5ubWCGsAUlfky+
	xwJiMwtoSazfeZwJwpaX2LzmLTPEQQoSO86+ZgSxRQT0JLperYCqEZHY9+IdI8heCYFL7BIH
	OjYxQSwTkPg2+RALxMOyEpsOQM2RlDi44gbLBEaxWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmg
	OCm9yFSvODG3uDQvXS85P3cTIyQSJ+5gvH/A+hBjMtD6icxSosn5wEjOK4k3NDYzsjA1MTU2
	Mrc0I01YSZxXvcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANj4fGn5pqyyzexqW8+YHGS
	vZOv9/XVd5MiFoiG96vlqRWe5ZXedPnXuxbPee9e9m+UE90+cVqaUYjBpPJ5woIGSvU5Eu/u
	bL+88/+fx0cN13IyPpD+rL5U//2r/Xu6FAxe51zcdnVuw/u726I8Vxkplqx7u9H3leX7yFk3
	anXyrJI+BZedKZ9xVomlOCPRUIu5qDgRAJvS+qjaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAd1ve+cFGkzsEbTY3P+AzeLywkus
	Fr8eCFlc3jWHzeJl334Wi1uHPjI6sHlMbH7H7vHvcD+Tx+I9L5k8+rasYvT4vEnO4+60F4wB
	bFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGco
	KZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDOWP3zGVHBDuOLOtbPsDYy7
	BboYOTkkBEwkFtxoYoawxSQu3FvP1sXIxSEksIhR4um8lawQzi9GieNXT7OCVLEJqEl8+XKY
	vYuRg0NEQF1i6XUZkBpmgcWMEose72AGiQsLmEm8vFYBUs4ioCqx5MpZNhCbV8BS4ufWBmYI
	W1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveQh2kILHj7GtGEFtEQE+i69UKqBoRiX0v3jFOYBSY
	hWTULCSjZiEZNQtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwbH+THoH46oGi0OM
	AhyMSjy8M3TmBQqxJpYVV+YeYpTgYFYS4S0MAwrxpiRWVqUW5ccXleakFh9iTAb6dCKzlGhy
	PjAN5ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo6inVKTw
	7PJpu4qmGXEdTlNSZ+N05mOQ/aF2/taDig0t/GpnI/NueairGR4tu1Bxk79+KePcSOsame98
	PV964+8mh808pzJNd+8mr89zolW0RAJP2df8TuqedbEqMvr+k2sbr1Xw1Z/1vcc+zSCH+eSu
	Q78nROQGqL9qjjlVrbQ1UzbpY/F+JZbijERDLeai4kQA2aukyDkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Also, unnecessary dev_set_drvdata() is removed, because the driver core
clears the driver data to NULL after device_release or on probe failure.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/dma/fsldma.c      |    5 ++---
 drivers/dma/ppc4xx/adma.c |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 4fc2980..49e8fbd 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1368,7 +1368,7 @@ static int fsldma_of_probe(struct platform_device *op)
 
 	dma_set_mask(&(op->dev), DMA_BIT_MASK(36));
 
-	dev_set_drvdata(&op->dev, fdev);
+	platform_set_drvdata(op, fdev);
 
 	/*
 	 * We cannot use of_platform_bus_probe() because there is no
@@ -1417,7 +1417,7 @@ static int fsldma_of_remove(struct platform_device *op)
 	struct fsldma_device *fdev;
 	unsigned int i;
 
-	fdev = dev_get_drvdata(&op->dev);
+	fdev = platform_get_drvdata(op);
 	dma_async_device_unregister(&fdev->common);
 
 	fsldma_free_irqs(fdev);
@@ -1428,7 +1428,6 @@ static int fsldma_of_remove(struct platform_device *op)
 	}
 
 	iounmap(fdev->regs);
-	dev_set_drvdata(&op->dev, NULL);
 	kfree(fdev);
 
 	return 0;
diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index 5d3d955..e68c51d 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -4481,7 +4481,7 @@ static int ppc440spe_adma_probe(struct platform_device *ofdev)
 	adev->dev = &ofdev->dev;
 	adev->common.dev = &ofdev->dev;
 	INIT_LIST_HEAD(&adev->common.channels);
-	dev_set_drvdata(&ofdev->dev, adev);
+	platform_set_drvdata(ofdev, adev);
 
 	/* create a channel */
 	chan = kzalloc(sizeof(*chan), GFP_KERNEL);
@@ -4594,14 +4594,13 @@ out:
  */
 static int ppc440spe_adma_remove(struct platform_device *ofdev)
 {
-	struct ppc440spe_adma_device *adev = dev_get_drvdata(&ofdev->dev);
+	struct ppc440spe_adma_device *adev = platform_get_drvdata(ofdev);
 	struct device_node *np = ofdev->dev.of_node;
 	struct resource res;
 	struct dma_chan *chan, *_chan;
 	struct ppc_dma_chan_ref *ref, *_ref;
 	struct ppc440spe_adma_chan *ppc440spe_chan;
 
-	dev_set_drvdata(&ofdev->dev, NULL);
 	if (adev->id < PPC440SPE_ADMA_ENGINES_NUM)
 		ppc440spe_adma_devices[adev->id] = -1;
 
-- 
1.7.10.4



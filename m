Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab3HUJv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:51:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16649 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab3HUJv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:51:57 -0400
X-AuditID: cbfee68f-b7f436d000000f81-ca-52148dbcf516
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vinod Koul'" <vinod.koul@intel.com>
Cc: "'Dan Williams'" <djbw@fb.com>, linux-kernel@vger.kernel.org,
        "'Andy Shevchenko'" <andriy.shevchenko@linux.intel.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Fabio Estevam'" <fabio.estevam@freescale.com>,
        "'Shawn Guo'" <shawn.guo@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] dma: sh: remove unnecessary platform_set_drvdata()
Date: Wed, 21 Aug 2013 18:51:56 +0900
Message-id: <003001ce9e54$12595950$370c0bf0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6eVBJCjqGwerJCRDunQU2+zBWtCg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zI909vSJBBufWyFj0Nk1nstjc/4DN
	YlaXrsXlhZdYLS7vmsNm8XTdEmaLl337WRzYPSY2v2P3+He4n8lj8Z6XTB53ru1h85h3MtCj
	b8sqRo/Pm+QC2KO4bFJSczLLUov07RK4Mpbf+cdc0MhT0bPvDHsDYwtXFyMHh4SAicSaq4Zd
	jJxAppjEhXvr2boYuTiEBJYxSjRum8UEkTCRmPb6MTtEYjqjxK7pS6GcX4wSn56dZwOpYhNQ
	k/jy5TA7yFQRAXWJpddlQGqYBWYwSRxrPs8CUiMs4Cxxbf8vVhCbRUBV4vq0H4wgNq+ArcSn
	py9YIWxBiR+T74HVMwtoSazfeZwJwpaX2LzmLTPE1eoSj/7qgoRFBPQkDi36AVUiIrHvxTtG
	kL0SAvfYJS71bIfaJSDxbfIhFoheWYlNB5ghHpOUOLjiBssERrFZSDbPQrJ5FpLNs5CsWMDI
	sopRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJDr7dzDePWB9iDEZaP1EZinR5HxgdOeVxBsa
	mxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTHw1Qdhju0M
	jSk7Jp/bLFqadvTUJkmeDaIzFs3ZyK4aabRbw+FHgqePkVZlIZNPIq/ib3Z+uxld5TVrDp7P
	v/s59thJJT6Lj29v8sjs23f/w07f0w37b1Ux5N640neh5cK7vc8b7sVfNX11wHXxrse1lw3X
	9pU94NAOYjZ++uZLd4/BHtF4azElluKMREMt5qLiRACJ1fQB5AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsVy+t9jQd09vSJBBtO6JCx6m6YzWWzuf8Bm
	MatL1+LywkusFpd3zWGzeLpuCbPFy779LA7sHhOb37F7/Dvcz+SxeM9LJo871/awecw7GejR
	t2UVo8fnTXIB7FENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkou
	PgG6bpk5QPcoKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDOW3/nHXNDI
	U9Gz7wx7A2MLVxcjJ4eEgInEtNeP2SFsMYkL99azdTFycQgJTGeU2DV9KTuE84tR4tOz82wg
	VWwCahJfvhwGSnBwiAioSyy9LgNSwywwg0niWPN5FpAaYQFniWv7f7GC2CwCqhLXp/1gBLF5
	BWwlPj19wQphC0r8mHwPrJ5ZQEti/c7jTBC2vMTmNW+ZQeZLAM1/9FcXJCwioCdxaNEPqBIR
	iX0v3jFOYBSYhWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwdH/
	THoH46oGi0OMAhyMSjy8F5RFgoRYE8uKK3MPMUpwMCuJ8C6qBgrxpiRWVqUW5ccXleakFh9i
	TAZ6dCKzlGhyPjAx5ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMH
	p1QDo/2P04luE7/4mRw2ylBZ7bZeuLig86unkNbS3Ml9jI5qGv+LHEOUZsU7ZH7t3/9Mi591
	z7WvDs/dLhUo/rpXJfrIRnniQbN9YV1H7hw0FtAwszr9g3nLsW8Hp9Zm5Dy4G7fyetzMUIs5
	Hib9v9jZ0/e1bjum3fu76XT38V8+D84l771srzT3thJLcUaioRZzUXEiAP9DQvZCAwAA
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
 drivers/dma/sh/shdma.c  |    3 ---
 drivers/dma/sh/sudmac.c |    2 --
 2 files changed, 5 deletions(-)

diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
index 211e2f1..208de0f 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdma.c
@@ -873,7 +873,6 @@ rst_err:
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
-	platform_set_drvdata(pdev, NULL);
 	shdma_cleanup(&shdev->shdma_dev);
 eshdma:
 	if (dmars)
@@ -917,8 +916,6 @@ static int sh_dmae_remove(struct platform_device *pdev)
 		iounmap(shdev->dmars);
 	iounmap(shdev->chan_reg);
 
-	platform_set_drvdata(pdev, NULL);
-
 	synchronize_rcu();
 	kfree(shdev);
 
diff --git a/drivers/dma/sh/sudmac.c b/drivers/dma/sh/sudmac.c
index c494417..23fffc8 100644
--- a/drivers/dma/sh/sudmac.c
+++ b/drivers/dma/sh/sudmac.c
@@ -393,7 +393,6 @@ static int sudmac_probe(struct platform_device *pdev)
 chan_probe_err:
 	sudmac_chan_remove(su_dev);
 
-	platform_set_drvdata(pdev, NULL);
 	shdma_cleanup(&su_dev->shdma_dev);
 
 	return err;
@@ -407,7 +406,6 @@ static int sudmac_remove(struct platform_device *pdev)
 	dma_async_device_unregister(dma_dev);
 	sudmac_chan_remove(su_dev);
 	shdma_cleanup(&su_dev->shdma_dev);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.10.4



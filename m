Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab3HZAcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 20:32:11 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43081 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab3HZAcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 20:32:09 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-b6-521aa2053e96
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vinod Koul'" <vinod.koul@intel.com>
Cc: "'Dan Williams'" <djbw@fb.com>, linux-kernel@vger.kernel.org,
        "'Simon Horman'" <horms@verge.net.au>,
        "'Andy Shevchenko'" <andriy.shevchenko@linux.jf.intel.com>,
        "'Fabio Estevam'" <fabio.estevam@freescale.com>,
        "'Shawn Guo'" <shawn.guo@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH RESEND] dma: sh: remove unnecessary platform_set_drvdata()
Date: Mon, 26 Aug 2013 09:32:05 +0900
Message-id: <001e01cea1f3$b0d5a780$1280f680$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6h87CIMxTc7SpdQ1iNk4kBfwjmEQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t8zI13WRVJBBtN3mVq82vmI3WJz/wM2
	i1lduhbNW78yWlxeeInV4vKuOWwWT9ctYbZ42befxYHDY2LzO3aPf4f7mTwW73nJ5HHn2h42
	jzc3b7F69G1Zxegx5+c3Fo/Pm+QCOKK4bFJSczLLUov07RK4Mk7tms5acIqn4u7Zt0wNjKe4
	uhg5OSQETCQm31jPDGGLSVy4t56ti5GLQ0hgGaPE4XdTmWCK9kw6wgiRmM4ocefHORYI5xej
	xP8FLYwgVWwCahJfvhxm72Lk4BARUJdYel0GpIZZYA6TxOGdT8FWCAt4SWy98IYNxGYRUJVo
	+3KMDaSeV8BW4utmNZAwr4CgxI/J91hAbGYBLYnN25pYIWx5ic1r3jKDlEsAjX/0VxckLCKg
	JzFz6maochGJfS/egd0pIfCVXeLatInsEKsEJL5NPsQC0SsrsekA1MOSEgdX3GCZwCg2C8nm
	WUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525ihMTsxB2M9w9YH2JMBlo/
	kVlKNDkfGPN5JfGGxmZGFqYmpsZG5pZmpAkrifOqt1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk
	4uCUamA8rCz3Ze2b4JTrxcsOG5fkvFYx8NVSKw+XEWvm3PJw+Sel8w4Ms+bJblu9h/+R33op
	FbYFs0t2z4pdnbfxO9Ox5H9nra8FHXj8uUhl0byHZ4pV5xouvJYwJVozVGHaF55X9/pPKvT6
	ia/5JW8qNrHXkyP9R5hZx5mXtY83eprdXaTY9i3RNnSTEktxRqKhFnNRcSIAL7CKLu8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jQV3WRVJBBtfeG1i82vmI3WJz/wM2
	i1lduhbNW78yWlxeeInV4vKuOWwWT9ctYbZ42befxYHDY2LzO3aPf4f7mTwW73nJ5HHn2h42
	jzc3b7F69G1Zxegx5+c3Fo/Pm+QCOKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUN
	LS3MlRTyEnNTbZVcfAJ03TJzgE5TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SA
	BhLWMWac2jWdteAUT8Xds2+ZGhhPcXUxcnJICJhI7Jl0hBHCFpO4cG89WxcjF4eQwHRGiTs/
	zrFAOL8YJf4vaAGrYhNQk/jy5TB7FyMHh4iAusTS6zIgNcwCc5gkDu98ygxSIyzgJbH1whs2
	EJtFQFWi7csxNpB6XgFbia+b1UDCvAKCEj8m32MBsZkFtCQ2b2tihbDlJTavecsMUi4BNP7R
	X12QsIiAnsTMqZuhykUk9r14xziBUWAWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn
	5haX5qXrJefnbmIEJ4Rn0jsYVzVYHGIU4GBU4uFdUSQVJMSaWFZcmXuIUYKDWUmE19VBMkiI
	NyWxsiq1KD++qDQntfgQYzLQnxOZpUST84HJKq8k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFC
	AumJJanZqakFqUUwW5g4OKUaGKu9w2/3e7zfwGO1LXfhL/bsz1+lb+e/aW3qNsri3rbP0t5s
	spvshl0582Zuez8lRKaqdqZMfOz2kt/Xy+ZqW+Uo6/5wOi65daJub27WvHmS5/8H8EQJ1j5N
	5zApzcrbaMkpsviq5Nyc/aJ6fpN23hU9uL11Sf/LbTP1iifd6k1e9YzjbzijoBJLcUaioRZz
	UXEiAHNyIppMAwAA
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
Acked-by: Simon Horman <horms+renesas@verge.net.au>
---
 drivers/dma/sh/shdmac.c |    3 ---
 drivers/dma/sh/sudmac.c |    2 --
 2 files changed, 5 deletions(-)

diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
index c7faded..282e93f 100755
--- a/drivers/dma/sh/shdmac.c
+++ b/drivers/dma/sh/shdmac.c
@@ -882,7 +882,6 @@ rst_err:
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
-	platform_set_drvdata(pdev, NULL);
 	shdma_cleanup(&shdev->shdma_dev);
 eshdma:
 	synchronize_rcu();
@@ -911,8 +910,6 @@ static int sh_dmae_remove(struct platform_device *pdev)
 	sh_dmae_chan_remove(shdev);
 	shdma_cleanup(&shdev->shdma_dev);
 
-	platform_set_drvdata(pdev, NULL);
-
 	synchronize_rcu();
 
 	return 0;
diff --git a/drivers/dma/sh/sudmac.c b/drivers/dma/sh/sudmac.c
index 3c7d2b8..bf85b8e 100755
--- a/drivers/dma/sh/sudmac.c
+++ b/drivers/dma/sh/sudmac.c
@@ -391,7 +391,6 @@ static int sudmac_probe(struct platform_device *pdev)
 chan_probe_err:
 	sudmac_chan_remove(su_dev);
 
-	platform_set_drvdata(pdev, NULL);
 	shdma_cleanup(&su_dev->shdma_dev);
 
 	return err;
@@ -405,7 +404,6 @@ static int sudmac_remove(struct platform_device *pdev)
 	dma_async_device_unregister(dma_dev);
 	sudmac_chan_remove(su_dev);
 	shdma_cleanup(&su_dev->shdma_dev);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.10.4



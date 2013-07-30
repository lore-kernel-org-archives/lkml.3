Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab3G3IJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:09:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:57676 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab3G3IJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:09:14 -0400
X-AuditID: cbfee691-b7fef6d000002d62-19-51f774a7080f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vinod Koul'" <vinod.koul@intel.com>
Cc: "'Dan Williams'" <djbw@fb.com>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 17/35] dma: use dev_get_platdata()
Date: Tue, 30 Jul 2013 17:09:11 +0900
Message-id: <004201ce8cfc$12990af0$37cb20d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6M+/IF2b5EIzAcTTemjL0U7gB7Aw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zA93lJd8DDV7skrXY3P+AzeLywkus
	Fpd3zWGzeNm3n8WBxWNi8zt2j8V7XjJ59G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8a+tivM
	BR/sK67MXsLSwNhq1sXIwSEhYCIxb71MFyMnkCkmceHeerYuRi4OIYFljBLTN05lh0iYSDTf
	6YRKTGeUWNayEMr5xSix6lUXE0gVm4CaxJcvh9lBpooIqEssvQ42lVkgSWLFxGusIGFhASOJ
	rjeGIGEWAVWJvXPusILYvAKWEkfmzWOGsAUlfky+xwLRqiWxfudxJghbXmLzmrfMEPcoSOw4
	+5oRxBYR0JO4fGUnVI2IxL4X7xghajaxS/TMc4HYJSDxbfIhFoh/ZSU2HYAaIylxcMUNlgmM
	YrOQbJ6FZPMsJJtnIdmwgJFlFaNoakFyQXFSepGpXnFibnFpXrpecn7uJkZIhE3cwXj/gPUh
	xmSg9ROZpUST84ERmlcSb2hsZmRhamJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlO
	avEhRiYOTqkGxn1PJxtX8mznUJCceuPnxsLLCxfwZDzjef1p7kJenhgDw2U/A07uTTr2run0
	/zKmmP2r79wOXhZqaHlJwOGGdE9Ai/HnpRc0N+UyPjgmo6VnfMGHnaHS40Ta9PV5K5+dT2zt
	/RHe0HTXp+3Xf7dnr3ZtDHZ6NPPWge3TJznlqe7M1D9V+1fne6MSS3FGoqEWc1FxIgCxCVtG
	xgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQd3lJd8DDY69l7DY3P+AzeLywkus
	Fpd3zWGzeNm3n8WBxWNi8zt2j8V7XjJ59G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPGvrYrzAUf7CuuzF7C0sDYatbFyMkhIWAi0Xynkw3CFpO4cG89
	kM3FISQwnVFiWctCKOcXo8SqV11MIFVsAmoSX74cZu9i5OAQEVCXWHpdBiTMLJAksWLiNVaQ
	sLCAkUTXG0OQMIuAqsTeOXdYQWxeAUuJI/PmMUPYghI/Jt9jgWjVkli/8zgThC0vsXnNW2aI
	exQkdpx9zQhiiwjoSVy+shOqRkRi34t3jBMYBWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFS
	eq6hXnFibnFpXrpecn7uJkZwDD+T2sG4ssHiEKMAB6MSD++Ggm+BQqyJZcWVuYcYJTiYlUR4
	WW4AhXhTEiurUovy44tKc1KLDzEmA306kVlKNDkfmF7ySuINjU3MjCyNzCyMTMzNSRNWEuc9
	0GodKCSQnliSmp2aWpBaBLOFiYNTqoFRh+NNEkPRHt2Ys3MNL6VyRyRk/WV5UHkjkLPydHDL
	l8qa76u+tfHtP/+jLshT+ozFsn8MC0Kmhkn6xDm9bi3p/Nj4MPDn5SvblLkbbbk2JjGUz7+6
	7FfQjktmgfNemf2Wnq34+uBcprOOtRbv21M6pPwDjpbfbtv+U0Z1zcSvOq/3XFzzcX+yEktx
	RqKhFnNRcSIAxjOIdCUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/dma/imx-sdma.c    |    2 +-
 drivers/dma/iop-adma.c    |    6 +++---
 drivers/dma/mv_xor.c      |    2 +-
 drivers/dma/pl330.c       |    2 +-
 drivers/dma/sh/shdma-of.c |    2 +-
 drivers/dma/sh/shdma.c    |    2 +-
 drivers/dma/sh/sudmac.c   |    4 ++--
 drivers/dma/ste_dma40.c   |    4 ++--
 drivers/dma/timb_dma.c    |    2 +-
 drivers/dma/txx9dmac.c    |    9 +++++----
 10 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index f45e092..b331ebb 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1332,7 +1332,7 @@ static int __init sdma_probe(struct platform_device *pdev)
 	int ret;
 	int irq;
 	struct resource *iores;
-	struct sdma_platform_data *pdata = pdev->dev.platform_data;
+	struct sdma_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	int i;
 	struct sdma_engine *sdma;
 	s32 *saddr_arr;
diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index cc727ec..dd8b44a 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -518,7 +518,7 @@ static int iop_adma_alloc_chan_resources(struct dma_chan *chan)
 	struct iop_adma_desc_slot *slot = NULL;
 	int init = iop_chan->slots_allocated ? 0 : 1;
 	struct iop_adma_platform_data *plat_data =
-		iop_chan->device->pdev->dev.platform_data;
+		dev_get_platdata(&iop_chan->device->pdev->dev);
 	int num_descs_in_pool = plat_data->pool_size/IOP_ADMA_SLOT_SIZE;
 
 	/* Allocate descriptor slots */
@@ -1351,7 +1351,7 @@ static int iop_adma_remove(struct platform_device *dev)
 	struct iop_adma_device *device = platform_get_drvdata(dev);
 	struct dma_chan *chan, *_chan;
 	struct iop_adma_chan *iop_chan;
-	struct iop_adma_platform_data *plat_data = dev->dev.platform_data;
+	struct iop_adma_platform_data *plat_data = dev_get_platdata(&dev->dev);
 
 	dma_async_device_unregister(&device->common);
 
@@ -1376,7 +1376,7 @@ static int iop_adma_probe(struct platform_device *pdev)
 	struct iop_adma_device *adev;
 	struct iop_adma_chan *iop_chan;
 	struct dma_device *dma_dev;
-	struct iop_adma_platform_data *plat_data = pdev->dev.platform_data;
+	struct iop_adma_platform_data *plat_data = dev_get_platdata(&pdev->dev);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
diff --git a/drivers/dma/mv_xor.c b/drivers/dma/mv_xor.c
index 200f1a3..b09c07c 100644
--- a/drivers/dma/mv_xor.c
+++ b/drivers/dma/mv_xor.c
@@ -1166,7 +1166,7 @@ static int mv_xor_probe(struct platform_device *pdev)
 {
 	const struct mbus_dram_target_info *dram;
 	struct mv_xor_device *xordev;
-	struct mv_xor_platform_data *pdata = pdev->dev.platform_data;
+	struct mv_xor_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct resource *res;
 	int i, ret;
 
diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 4ad13eb..74ee257 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2934,7 +2934,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	int i, ret, irq;
 	int num_chan;
 
-	pdat = adev->dev.platform_data;
+	pdat = dev_get_platdata(&adev->dev);
 
 	/* Allocate a new DMAC and its Channels */
 	pdmac = devm_kzalloc(&adev->dev, sizeof(*pdmac), GFP_KERNEL);
diff --git a/drivers/dma/sh/shdma-of.c b/drivers/dma/sh/shdma-of.c
index 11bcb05..966aaab 100644
--- a/drivers/dma/sh/shdma-of.c
+++ b/drivers/dma/sh/shdma-of.c
@@ -42,7 +42,7 @@ static struct dma_chan *shdma_of_xlate(struct of_phandle_args *dma_spec,
 
 static int shdma_of_probe(struct platform_device *pdev)
 {
-	const struct of_dev_auxdata *lookup = pdev->dev.platform_data;
+	const struct of_dev_auxdata *lookup = dev_get_platdata(&pdev->dev);
 	int ret;
 
 	if (!lookup)
diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
index b67f45f..b388b12 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdma.c
@@ -660,7 +660,7 @@ static const struct shdma_ops sh_dmae_shdma_ops = {
 
 static int sh_dmae_probe(struct platform_device *pdev)
 {
-	struct sh_dmae_pdata *pdata = pdev->dev.platform_data;
+	struct sh_dmae_pdata *pdata = dev_get_platdata(&pdev->dev);
 	unsigned long irqflags = IRQF_DISABLED,
 		chan_flag[SH_DMAE_MAX_CHANNELS] = {};
 	int errirq, chan_irq[SH_DMAE_MAX_CHANNELS];
diff --git a/drivers/dma/sh/sudmac.c b/drivers/dma/sh/sudmac.c
index e7c94bb..c494417 100644
--- a/drivers/dma/sh/sudmac.c
+++ b/drivers/dma/sh/sudmac.c
@@ -335,7 +335,7 @@ static const struct shdma_ops sudmac_shdma_ops = {
 
 static int sudmac_probe(struct platform_device *pdev)
 {
-	struct sudmac_pdata *pdata = pdev->dev.platform_data;
+	struct sudmac_pdata *pdata = dev_get_platdata(&pdev->dev);
 	int err, i;
 	struct sudmac_device *su_dev;
 	struct dma_device *dma_dev;
@@ -373,7 +373,7 @@ static int sudmac_probe(struct platform_device *pdev)
 		return err;
 
 	/* platform data */
-	su_dev->pdata = pdev->dev.platform_data;
+	su_dev->pdata = dev_get_platdata(&pdev->dev);
 
 	platform_set_drvdata(pdev, su_dev);
 
diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 5ab5880..0036756 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3139,7 +3139,7 @@ static int __init d40_phy_res_init(struct d40_base *base)
 
 static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 {
-	struct stedma40_platform_data *plat_data = pdev->dev.platform_data;
+	struct stedma40_platform_data *plat_data = dev_get_platdata(&pdev->dev);
 	struct clk *clk = NULL;
 	void __iomem *virtbase = NULL;
 	struct resource *res = NULL;
@@ -3535,7 +3535,7 @@ static int __init d40_of_probe(struct platform_device *pdev,
 
 static int __init d40_probe(struct platform_device *pdev)
 {
-	struct stedma40_platform_data *plat_data = pdev->dev.platform_data;
+	struct stedma40_platform_data *plat_data = dev_get_platdata(&pdev->dev);
 	struct device_node *np = pdev->dev.of_node;
 	int ret = -ENOENT;
 	struct d40_base *base = NULL;
diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 0ef43c1..28af214 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -669,7 +669,7 @@ static irqreturn_t td_irq(int irq, void *devid)
 
 static int td_probe(struct platform_device *pdev)
 {
-	struct timb_dma_platform_data *pdata = pdev->dev.platform_data;
+	struct timb_dma_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct timb_dma *td;
 	struct resource *iomem;
 	int irq;
diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index 59357db..71e8e77 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -1117,9 +1117,10 @@ static void txx9dmac_off(struct txx9dmac_dev *ddev)
 
 static int __init txx9dmac_chan_probe(struct platform_device *pdev)
 {
-	struct txx9dmac_chan_platform_data *cpdata = pdev->dev.platform_data;
+	struct txx9dmac_chan_platform_data *cpdata =
+			dev_get_platdata(&pdev->dev);
 	struct platform_device *dmac_dev = cpdata->dmac_dev;
-	struct txx9dmac_platform_data *pdata = dmac_dev->dev.platform_data;
+	struct txx9dmac_platform_data *pdata = dev_get_platdata(&dmac_dev->dev);
 	struct txx9dmac_chan *dc;
 	int err;
 	int ch = pdev->id % TXX9_DMA_MAX_NR_CHANNELS;
@@ -1202,7 +1203,7 @@ static int txx9dmac_chan_remove(struct platform_device *pdev)
 
 static int __init txx9dmac_probe(struct platform_device *pdev)
 {
-	struct txx9dmac_platform_data *pdata = pdev->dev.platform_data;
+	struct txx9dmac_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct resource *io;
 	struct txx9dmac_dev *ddev;
 	u32 mcr;
@@ -1281,7 +1282,7 @@ static int txx9dmac_resume_noirq(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct txx9dmac_dev *ddev = platform_get_drvdata(pdev);
-	struct txx9dmac_platform_data *pdata = pdev->dev.platform_data;
+	struct txx9dmac_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	u32 mcr;
 
 	mcr = TXX9_DMA_MCR_MSTEN | MCR_LE;
-- 
1.7.10.4



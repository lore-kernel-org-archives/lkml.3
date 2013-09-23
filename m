Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab3IWJuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:50:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30072 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab3IWJut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:50:49 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-77-52400ef22bba
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Atsushi Nemoto'" <anemo@mba.ocn.ne.jp>
References: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
In-reply-to: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
Subject: [PATCH 13/15] rtc: rtc-rs5c348: use dev_get_platdata()
Date: Mon, 23 Sep 2013 18:50:42 +0900
Message-id: <002901ceb842$5df961e0$19ec25a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64QJVrtN1IW24fTFCn/tCGU7Py3AAAacJQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zQ91PfA5BBht/y1gsuXiV3WLO+jVs
	Fksnh1hcXniJ1eLyrjlsFvs7Oxgd2Dz2TDzJ5nFixm8Wj4vTmT36tqxi9Jg+7yeTx+dNcgFs
	UVw2Kak5mWWpRfp2CVwZO6Z8Zypo4KzY2fScqYHxAHsXIyeHhICJxMcLE1ggbDGJC/fWs3Ux
	cnEICSxjlLi49SsbTFHDw252iMQiRom2+b0sEM4vRonmXT/BRrEJqEl8+XIYyObgEBHQl2hr
	0QCpYRbYzigx//EbsBVCArYSE6d9ZQKxOQXsJNZ8XgZmCwvYS8zp+gK2jUVAVeLGoRtgM3mB
	6p93nmCCsAUlfky+BzaHWUBLYvO2JlYIW15i85q3zCB7JQTUJR791QUJiwgYSbx8uYIZokRE
	Yt+Ld4wg90gIvGSX+PXxNdQuAYlvkw+xQPTKSmw6wAzxsKTEwRU3WCYwSsxCsnkWks2zkGye
	hWTFAkaWVYyiqQXJBcVJ6UWmesWJucWleel6yfm5mxghsTtxB+P9A9aHGJOB1k9klhJNzgfG
	fl5JvKGxmZGFqYmpsZG5pRlpwkrivOot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGNfv
	f33ro4BXiH3HvoxrFnM2KsY2nuVeVT9xTa6rVtsP3qMs+9SkeWLTszezJ1b8zk++e7WfKePI
	ZLcVByMufW8J2JbzneOc67d3FopVpXIbzyzXWlEt90yXd1pwxe17RxULqkU/38mQ2vFuaeBp
	7kt1SXM/Hal9YD3naFSUzIkZbWpPzq8qW6nEUpyRaKjFXFScCABcKRDm8wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jAd1PfA5BBuu7JS2WXLzKbjFn/Ro2
	i6WTQywuL7zEanF51xw2i/2dHYwObB57Jp5k8zgx4zeLx8XpzB59W1Yxekyf95PJ4/MmuQC2
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGTumfGcqaOCs2Nn0nKmB8QB7
	FyMnh4SAiUTDw24oW0ziwr31bF2MXBxCAosYJdrm97JAOL8YJZp3/QSrYhNQk/jy5TCQzcEh
	IqAv0daiAVLDLLCdUWL+4zcsIDVCArYSE6d9ZQKxOQXsJNZ8XgZmCwvYS8zp+sIGYrMIqErc
	OHQDbCYvUP3zzhNMELagxI/J98DmMAtoSWze1sQKYctLbF7zlhlkr4SAusSjv7ogYREBI4mX
	L1cwQ5SISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vO
	z93ECE4Mz6R2MK5ssDjEKMDBqMTDG5FoHyTEmlhWXJl7iFGCg1lJhNeP1SFIiDclsbIqtSg/
	vqg0J7X4EGMy0KMTmaVEk/OBSSuvJN7Q2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2amp
	BalFMFuYODilGhh3vzHncFlsr8Nt4cb9Kk70p/Rs07uP9r79kOpmI+mypdjXtjvok9JnH/H2
	OLtpSk+urVF1tN+mo8FnfrN8ttl2twON92wr7gmKz13scKBSNNLDs3bGUf7I21z+nyc/tuI4
	1vk5RC1XpErYPUXFL+iOT44n9/+PSr9q7kU2r5P+vbJ75rZMaSWW4oxEQy3mouJEANa5I4dQ	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-rs5c348.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-rs5c348.c b/drivers/rtc/rtc-rs5c348.c
index f7a90a1..090a101 100644
--- a/drivers/rtc/rtc-rs5c348.c
+++ b/drivers/rtc/rtc-rs5c348.c
@@ -64,7 +64,7 @@ static int
 rs5c348_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct spi_device *spi = to_spi_device(dev);
-	struct rs5c348_plat_data *pdata = spi->dev.platform_data;
+	struct rs5c348_plat_data *pdata = dev_get_platdata(&spi->dev);
 	u8 txbuf[5+7], *txp;
 	int ret;
 
@@ -100,7 +100,7 @@ static int
 rs5c348_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct spi_device *spi = to_spi_device(dev);
-	struct rs5c348_plat_data *pdata = spi->dev.platform_data;
+	struct rs5c348_plat_data *pdata = dev_get_platdata(&spi->dev);
 	u8 txbuf[5], rxbuf[7];
 	int ret;
 
-- 
1.7.10.4



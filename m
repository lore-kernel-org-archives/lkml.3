Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab3BSCCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:02:17 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43690 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758027Ab3BSCCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:02:14 -0500
X-AuditID: cbfee68e-b7fc26d000001938-d0-5122dd210a02
From: Boojin Kim <boojin.kim@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Dan Williams'" <djbw@fb.com>, "'Vinod Koul'" <vinod.koul@intel.com>,
        "'Jaswinder Singh'" <jassi.brar@samsung.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>
References: 
In-reply-to: 
Subject: [PATCH 2/2] ARM: EXYNOS: support burst mode for for dev-to-mem and
 dev-to-mem transmit
Date: Tue, 19 Feb 2013 11:02:09 +0900
Message-id: <00eb01ce0e45$20223c90$6066b5b0$%kim@samsung.com>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ORNEloL6pleRKSRCwKBmaENW5EwAAAdYQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t8zI13Fu0qBBq9bTS0u75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDImzDjPVnCRr+LUlTbGBsbVPF2MnBwSAiYS++d9ZIGw
	xSQu3FvP1sXIxSEksIxRYvnOdWwwRYfvzYRKLAJKTH7LCuH8ZZSYcOASM0gVm4CmxIzv09lB
	bBGBbIkrjfeZQYqYBV4yStzadgOonQOog1tidXMQSA2nAI/Euj+dYL3CAokSF2+sBLNZBFQl
	rvZMA7N5BWwlZt5YxwzSKiGgLvHory7EeCOJB+s7wI5jFhCR2PfiHSPIKgmB32wSxxdsgZoj
	IPFt8iEWiF5ZiU0HmCGekZQ4uOIGywRG0VlI2hcwMq5iFE0tSC4oTkovMtIrTswtLs1L10vO
	z93ECAnqvh2MNw9YH2JMBho9kVlKNDkfGBV5JfGGxsYmZiamJuaWpuampAkrifPKX5IJFBJI
	TyxJzU5NLUgtii8qzUktPsTIxMEp1cCYVCye/7H2uv/8e3JuV7o9vr7v2enzuHOucISiy5J3
	ufnzs0LusmVMOur76kb+vIgeue1ie79nHO3oZAz/b6HSrSqvzp1RJXzjmLG7d0zIJ8tb7ELf
	t3FEPF0WrC5q4/KGzanUqseO5/xyphxdy7x3Fu1Czx7Hmx9mZD/tpHZIbabeSen5v5RYijMS
	DbWYi4oTATyDO5qAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t9jAV3Fu0qBBh9/6llc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmTJhxnq3gIl/F
	qSttjA2Mq3m6GDk5JARMJA7fm8kGYYtJXLi3Hsjm4hASWMQosXzyW1YI5y+jxIQDl5hBqtgE
	NCVmfJ/ODmKLCGRLXGm8zwxSxCzwklHi1rYbQO0cQB3cEqubg0BqOAV4JNb96QTrFRZIlLh4
	YyWYzSKgKnG1ZxqYzStgKzHzxjpmkFYJAXWJR391IcYbSTxY3wF2HLOAiMS+F+8YJzDyz0Li
	LmBkXMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHDPPpHcwrmqwOMQowMGoxMP7wVEpUIg1
	say4MvcQowQHs5IIb0c7UIg3JbGyKrUoP76oNCe1+BBjMtCBE5mlRJPzgfGcVxJvaGxiZmRp
	ZGZhZGJuTpqwkjgv46knAUIC6YklqdmpqQWpRTBbmDg4pRoYK35u/3OnynAiE8N5t/0Tlx+f
	+s4xT+vSC6X92afzuqYmPRR7ZNBg97p3j8x1pm+z25e1aut3rtqe/dhn6tSmbVu5vOdmcp2J
	CDx3/8rZrl+cTyY1zwttWNXkVBy806ayyfzajYeb7I+v6X3jMufzk5/NT9e9VJXOnT4t84b1
	HeOwPK6FRy+9r1ZiKc5INNRiLipOBADu6Dlx3QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds to support burst mode for for dev-to-mem and dev-to-mem transmit

Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
---
 arch/arm/plat-samsung/dma-ops.c              |   10 ++++++++--
 arch/arm/plat-samsung/include/plat/dma-ops.h |    1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-samsung/dma-ops.c b/arch/arm/plat-samsung/dma-ops.c
index d088afa..c25e842 100644
--- a/arch/arm/plat-samsung/dma-ops.c
+++ b/arch/arm/plat-samsung/dma-ops.c
@@ -54,14 +54,20 @@ static int samsung_dmadev_config(unsigned ch,
 		slave_config.direction = param->direction;
 		slave_config.src_addr = param->fifo;
 		slave_config.src_addr_width = param->width;
-		slave_config.src_maxburst = 1;
+		if (param->maxburst)
+			slave_config.src_maxburst = param->maxburst;
+		else
+			slave_config.src_maxburst = 1;
 		dmaengine_slave_config(chan, &slave_config);
 	} else if (param->direction == DMA_MEM_TO_DEV) {
 		memset(&slave_config, 0, sizeof(struct dma_slave_config));
 		slave_config.direction = param->direction;
 		slave_config.dst_addr = param->fifo;
 		slave_config.dst_addr_width = param->width;
-		slave_config.dst_maxburst = 1;
+		if (param->maxburst)
+			slave_config.dst_maxburst = param->maxburst;
+		else
+			slave_config.dst_maxburst = 1;
 		dmaengine_slave_config(chan, &slave_config);
 	} else {
 		pr_warn("unsupported direction\n");
diff --git a/arch/arm/plat-samsung/include/plat/dma-ops.h b/arch/arm/plat-samsung/include/plat/dma-ops.h
index f5144cd..95893c7 100644
--- a/arch/arm/plat-samsung/include/plat/dma-ops.h
+++ b/arch/arm/plat-samsung/include/plat/dma-ops.h
@@ -35,6 +35,7 @@ struct samsung_dma_prep {
 struct samsung_dma_config {
 	enum dma_transfer_direction direction;
 	enum dma_slave_buswidth width;
+	u32 maxburst;
 	dma_addr_t fifo;
 };

--
1.7.5.4




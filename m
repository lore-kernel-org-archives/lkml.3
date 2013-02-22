Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3BVIFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:05:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:11350 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab3BVIFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:05:36 -0500
X-AuditID: cbfee68f-b7f656d000000d78-f4-512726cff0d9
From: Boojin Kim <boojin.kim@samsung.com>
To: "'Boojin Kim'" <boojin.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, alsa-devel@alsa-project.org
Cc: "'Vinod Koul'" <vinod.koul@intel.com>, "'Dan Williams'" <djbw@fb.com>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Sangbeom Kim'" <sbkim73@samsung.com>
References: 
In-reply-to: 
Subject: [PATCH v2 2/4] ARM: EXYNOS: support burst mode for for dev-to-mem and
 mem-to-dev transmit
Date: Fri, 22 Feb 2013 17:05:35 +0900
Message-id: <001a01ce10d3$64b4afb0$2e1e0f10$%kim@samsung.com>
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Q0zRNgYHsZtryQK2Zcgnt7X5e4wAABD9g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t8zY93zauqBBqfWsVpc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWsnnqGtWAvb8X0V39ZGhh3cHcxcnJICJhItO98wAZh
	i0lcuLceyObiEBJYxihxvvM4C0xR38QDUIlFjBKzP+xjhHD+Mkp0dGxhBKliE9CUmPF9OjtI
	QkTgFqNE6/xHYA6zwGkmiQWX25m7GDmAWrglVjcHgTRwCvBIrPvTyQxiCwukSNyYNAnsDhYB
	VYk9R9exgti8ArYSD/a+BmuVEFCXePRXFyQsImAkMWP6BbByZgERiX0v3jFCXPqfTWJXlyfE
	GAGJb5MPsUC0ykpsOsAMUSIpcXDFDZYJjKKzkHQvYGRcxSiaWpBcUJyUXmSsV5yYW1yal66X
	nJ+7iRES1P07GO8esD7EmAw0eiKzlGhyPjAq8kriDY2NTcxMTE3MLU3NTUkTVhLnlb8kEygk
	kJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB0Ta0dEfHoa2Pkk+2ecyt2fS0cIregbWd5284Hz+X
	Vi9RwrCLX+9SeUFmt6e548OH0i0LU4POPuAPEC5byrssd85PmfNv5Hw6NRVffVb5k+R+La0+
	meFO0AJxt/qHgVPff7E/+Fvx7FyJV/NzdrJ+5Nj6Nbyg/emCkH2Nk9u3BT/1ZFvb7HdbSIml
	OCPRUIu5qDgRAH66Ex6AAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t9jAd1zauqBBudmWVtc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmrJ56hrVgL2/F
	9Fd/WRoYd3B3MXJySAiYSPRNPMAGYYtJXLi3Hsjm4hASWMQoMfvDPkYI5y+jREfHFkaQKjYB
	TYkZ36ezgyREBG4xSrTOfwTmMAucZpJYcLmduYuRA6iFW2J1cxBIA6cAj8S6P53MILawQIrE
	jUmTwNaxCKhK7Dm6jhXE5hWwlXiw9zVYq4SAusSjv7ogYREBI4kZ0y+AlTMLiEjse/GOcQIj
	/ywk7gJGxlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwVHzTHoH46oGi0OMAhyMSjy8Hd5q
	gUKsiWXFlbmHGCU4mJVEeBcpqAcK8aYkVlalFuXHF5XmpBYfYkwGOnAis5Rocj4wovNK4g2N
	TcyMLI3MLIxMzM1JE1YS52U89SRASCA9sSQ1OzW1ILUIZgsTB6dUA2OT5twTAWvKXl5mPRo5
	dX5y0bH1kSuWuTjYei78tOvD7albA+pzGZpMZm1Q+29gtkbncE2S664/SXWeSwrP6H1eePWj
	6VHWae2yOw/Ia3yOed3DUqHpuXuq4PVjxz54i2woFTvDcFxh9vSWjP13p4hoLAtZ9czoRcn8
	ki23eqR8LBrPnysLeKKrxFKckWioxVxUnAgAjlqkI94CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds to support burst mode for for dev-to-mem and dev-to-mem transmit

Signed-off-by: Boojin Kim <boojin.kim@samsung.com>
---
 arch/arm/plat-samsung/dma-ops.c              |    4 ++--
 arch/arm/plat-samsung/include/plat/dma-ops.h |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-samsung/dma-ops.c b/arch/arm/plat-samsung/dma-ops.c
index 71d58dd..6c90c16 100644
--- a/arch/arm/plat-samsung/dma-ops.c
+++ b/arch/arm/plat-samsung/dma-ops.c
@@ -60,14 +60,14 @@ static int samsung_dmadev_config(unsigned ch,
 		slave_config.direction = param->direction;
 		slave_config.src_addr = param->fifo;
 		slave_config.src_addr_width = param->width;
-		slave_config.src_maxburst = 1;
+		slave_config.src_maxburst = param->maxburst;
 		dmaengine_slave_config(chan, &slave_config);
 	} else if (param->direction == DMA_MEM_TO_DEV) {
 		memset(&slave_config, 0, sizeof(struct dma_slave_config));
 		slave_config.direction = param->direction;
 		slave_config.dst_addr = param->fifo;
 		slave_config.dst_addr_width = param->width;
-		slave_config.dst_maxburst = 1;
+		slave_config.dst_maxburst = param->maxburst;
 		dmaengine_slave_config(chan, &slave_config);
 	} else {
 		pr_warn("unsupported direction\n");
diff --git a/arch/arm/plat-samsung/include/plat/dma-ops.h b/arch/arm/plat-samsung/include/plat/dma-ops.h
index 1141782..383bd6d 100644
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




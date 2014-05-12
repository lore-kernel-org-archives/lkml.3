Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaELGQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:16:49 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35459 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaELGQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:16:38 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-69-537067418bf8
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: joro@8bytes.org, arnd@arndb.de, t.figa@samsung.com, kgene.kim@samsung.com,
        pullip.cho@samsung.com, a.motakis@virtualopensystems.com,
        grundler@chromium.org, s.nawrocki@samsung.com, prathyush.k@samsung.com,
        rahul.sharma@samsung.com, sachin.kamat@linaro.org,
        supash.ramaswamy@linaro.org, varun.sethi@freescale.com,
        joshi@samsung.com, tomasz.figa@gmail.com,
        Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH v13 05/19] iommu/exynos: remove prefetch buffer setting
Date: Mon, 12 May 2014 11:44:50 +0530
Message-id: <1399875304-19948-6-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsWyRsSkRtcxvSDYoG29qMWdu+dYLf5OOsZu
	Mf8IkPXqyA8miwX7rS06Z29gt/i+6wu7Re+Cq2wWmx5fY7W4vGsOm8WM8/uYLC6s2Mhu8a/3
	IKPFlEWHWS0Ov2lntTj5p5fR4sjD3ewWLdd7mSzWz3jNYrFq1x9Gi5m31rA4iHo8OTiPyeP3
	r0mMHrMbLrJ4/Dvcz+Sxc9Zddo871/aweWxeUu8x+cZyRo++LasYPT5vkvO4cvQMUwB3FJdN
	SmpOZllqkb5dAlfG782HmAte8VUc7+pjbWBcxNPFyMkhIWAiseXyRUYIW0ziwr31bF2MXBxC
	AksZJWY+PQLkcIAV7dqQAFIjJLCIUeJ4ixpEzQQmiafX1rCAJNgEDCW237vCCpIQEVjNKNF3
	8Qw7iMMsMJtZ4sijxWArhAXcJU4dv8EEYrMIqEqs3X6PFcTmBYpv+HuZBWKbgsScSTYgYU4B
	D4nPq6ewQWx2lzj26irYAgmBtRwS9/6/YYWYIyDxbfIhqF5ZiU0HmCG+kZQ4uOIGywRG4QWM
	DKsYRVMLkguKk9KLTPWKE3OLS/PS9ZLzczcxAmP19L9nE3cw3j9gfYgxGWjcRGYp0eR8YKzn
	lcQbGpsZWZiamBobmVuakSasJM6b/igpSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjFJ0J
	Z0/cDTiZmJxQ0Gsg5sNzjvNXeO2B9vxF9/61XMlQfa+4Nkny1uLb61aszl1rsr1F4/6+d9dL
	Va7vDT8s8EJJZVf79tVPs/5eVCm5+bTQtHebXOKhT4I3RQMdjD5Kz+D2/3HVceWj35Gpn09v
	N1vwIMFsYqWYwXNF29L70V5FP/dY+9WrKrEUZyQaajEXFScCANgGDTXrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAV3H9IJgg5YjXBZ37p5jtfg76Ri7
	xfwjQNarIz+YLBbst7bonL2B3eL7ri/sFr0LrrJZbHp8jdXi8q45bBYzzu9jsriwYiO7xb/e
	g4wWUxYdZrU4/Kad1eLkn15GiyMPd7NbtFzvZbJYP+M1i8WqXX8YLWbeWsPiIOrx5OA8Jo/f
	vyYxesxuuMji8e9wP5PHzll32T3uXNvD5rF5Sb3H5BvLGT36tqxi9Pi8Sc7jytEzTAHcUQ2M
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAnyoplCXm
	lAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM35vPsRc8Iqv4nhXH2sD4yKeLkYO
	DgkBE4ldGxK6GDmBTDGJC/fWs4HYQgKLGCWOt6h1MXIB2ROYJJ5eW8MCkmATMJTYfu8KK0hC
	RGA1o0TfxTPsIA6zwGxmiSOPFjOCVAkLuEucOn6DCcRmEVCVWLv9HiuIzQsU3/D3MgvEZgWJ
	OZNsQMKcAh4Sn1dPgdrsLnHs1VXWCYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIE
	J4JnUjsYVzZYHGIU4GBU4uH9wFAQLMSaWFZcmXuIUYKDWUmE96M/UIg3JbGyKrUoP76oNCe1
	+BBjMtBRE5mlRJPzgUkqryTe0NjE3NTY1NLEwsTMkjRhJXHeA63WgUIC6YklqdmpqQWpRTBb
	mDg4pRoYZ0zd/VCDd1rTc6/tMxsFrqZe2toh2PNL5gezD3tDSXJ5vOCKB67zBZeGhl4LsPjh
	vOvKgcTuRYmF2kd6YiaxnfWY8bFt8+YOBrae/C8y73icX5x6Ga5op8m36ecvfdPSA8t/1Af8
	czmhKjlHZfKGzmOvFpycH8zsIq8+odG+dHJ1o9b0WUs5lViKMxINtZiLihMBe2wxTEgDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

Prefetch buffer is a cache of System MMU 3.x and caches a block of
page table entries to make effect of larger page with small pages.
However, how to control prefetch buffers and the specifications of
prefetch buffers different from minor versions of System MMU v3.
Prefetch buffers must be controled with care because there are some
restrictions in H/W design.

The interface and implementation to initiate prefetch buffers will
be prepared later.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 06fc70e..4fc31fc 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -245,13 +245,6 @@ static void __sysmmu_set_ptbase(void __iomem *sfrbase,
 	__sysmmu_tlb_invalidate(sfrbase);
 }
 
-static void __sysmmu_set_prefbuf(void __iomem *sfrbase, unsigned long base,
-						unsigned long size, int idx)
-{
-	__raw_writel(base, sfrbase + REG_PB0_SADDR + idx * 8);
-	__raw_writel(size - 1 + base,  sfrbase + REG_PB0_EADDR + idx * 8);
-}
-
 static void __set_fault_handler(struct sysmmu_drvdata *data,
 					sysmmu_fault_handler_t handler)
 {
@@ -401,13 +394,6 @@ static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
 	data->pgtable = pgtable;
 
 	__sysmmu_set_ptbase(data->sfrbase, pgtable);
-	if ((readl(data->sfrbase + REG_MMU_VERSION) >> 28) == 3) {
-		/* System MMU version is 3.x */
-		__raw_writel((1 << 12) | (2 << 28),
-				data->sfrbase + REG_MMU_CFG);
-		__sysmmu_set_prefbuf(data->sfrbase, 0, -1, 0);
-		__sysmmu_set_prefbuf(data->sfrbase, 0, -1, 1);
-	}
 
 	__raw_writel(CTRL_ENABLE, data->sfrbase + REG_MMU_CTRL);
 
-- 
1.7.9.5


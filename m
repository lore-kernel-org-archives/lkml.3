Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab3GZLbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 07:31:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51238 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914Ab3GZLbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:31:03 -0400
X-AuditID: cbfee68f-b7f436d000000f81-eb-51f25df620b8
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>
Cc: "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: [PATCH v8 12/12] iommu/exynos: return 0 if iommu_attach_device()
 successes
Date: Fri, 26 Jul 2013 20:31:01 +0900
Message-id: <004201ce89f3$9b849a20$d28dce60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6J8ddcRcOchBS4TTmrJyDxnOe5pw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+Zse632E+BBjd+c1vcuXuO1eLVkR9M
	Fgv2W1t0zt7AbrH54DoWi94FV9ksGu9NYLP4eOo4u8Wmx9dYLS7vmsNmMeP8PiaLCys2sltM
	WXSY1eLkn15Gi5brvUwO/B5PDs5j8pjdcJHF4861PWwe5zetYfbYvKTeY/KN5YwefVtWMXp8
	3iTnceXoGaYAzigum5TUnMyy1CJ9uwSujM4NHUwFt3kqVq77ytrAuIuri5GDQ0LARGLy0vQu
	Rk4gU0ziwr31bF2MXBxCAssYJa717GaEqXn7pRoiPp1Rovv6ZKiiv4wSPy89ZwPpZhPQklg9
	9zgjiC0icJdR4uV5HpAiZoHbzBLTfr4CSwgLhErM7t3AAmKzCKhKPFn2CKyZV8BS4tnum8wQ
	tqDEj8n3wGqYgYau33mcCcKWl9i85i0zxKkKEjvOvoZapifx+10XM0SNiMS+F+8YQRZLCCzl
	kDizch8bxDIBiW+TD7FAvCMrsekA1BxJiYMrbrBMYBSbhWT1LCSrZyFZPQvJigWMLKsYRVML
	kguKk9KLjPWKE3OLS/PS9ZLzczcxQlJA/w7GuwesDzEmA62fyCwlmpwPTCF5JfGGxmZGFqYm
	psZG5pZmpAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBsyKm6wSgu/6W0K3Px
	+1dZv5TXzXx5b8OOfJl5TU3BKwsOzHvTe+tH+9p75klH+70nbbpwTs9/meYJB1XZrABbq331
	mtzCBVcv1uz2uto6ewLbQofSVdGfPP1Pr9eecsr7/o5f/kf2FVw8JMpac0THccX3tEn3Vhy4
	fv5/xObXL5L8uSWnnTJYr8RSnJFoqMVcVJwIAIsXaH4XAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEKsWRmVeSWpSXmKPExsVy+t9jQd1vsZ8CDY5uZ7O4c/ccq8WrIz+Y
	LBbst7bonL2B3WLzwXUsFr0LrrJZNN6bwGbx8dRxdotNj6+xWlzeNYfNYsb5fUwWF1ZsZLeY
	sugwq8XJP72MFi3Xe5kc+D2eHJzH5DG74SKLx51re9g8zm9aw+yxeUm9x+Qbyxk9+rasYvT4
	vEnO48rRM0wBnFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkou
	PgG6bpk5QB8oKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDM6N3QwFdzm
	qVi57itrA+Muri5GDg4JAROJt1+quxg5gUwxiQv31rN1MXJxCAlMZ5Tovj4ZyvnLKPHz0nM2
	kCo2AS2J1XOPM4LYIgJ3GSVenucBKWIWuM0sMe3nK7CEsECoxOzeDSwgNouAqsSTZY/AmnkF
	LCWe7b7JDGELSvyYfA+shhlo6Pqdx5kgbHmJzWveMkOcpCCx4+xrqGV6Er/fdTFD1IhI7Hvx
	jnECo8AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQITjHPpHYw
	rmywOMQowMGoxMOr4PQxUIg1say4MvcQowQHs5II73XvT4FCvCmJlVWpRfnxRaU5qcWHGJOB
	Pp3ILCWanA9Mf3kl8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnV
	wJgYs8vizvqKa5c/92yfVsn69JFXlWTCC5mCqUKsye+XHPETbQ5P/vp1caWVm99BR8Hbh+KE
	xbJuZnPsb+EUMFvSatAXoB0eynYudE09Q3Ti5LlaafFNp5rVj+xTm++uVrwgndvd/Ur41Akz
	4wM/zWwX718R1uul9Mdxd7XUb9aygzo3/GX9lFiKMxINtZiLihMB2CXocnUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iommu_attach_device() against exynos-iommu positive integer on success
if the caller calls iommu_attach_device() with the same iommu_domain
multiple times without call to iommu_detach_device() to inform the
caller how many calls to iommu_detach_device() to really detach iommu.

However the convention of the return value of success of common API is
zero, this patch makes iommu_attach_device() call against exynos-iommu
always return zero if the given device is successfully attached to
the given iommu_domain even though it is already attached to the same
iommu_domain.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 drivers/iommu/exynos-iommu.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 51e5b35..6eed6d6 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -882,15 +882,16 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(dev, "%s: Failed to attach IOMMU with pgtable %#lx\n",
 				__func__, __pa(priv->pgtable));
-	else
-		dev_dbg(dev, "%s: Attached IOMMU with pgtable 0x%lx%s\n",
-					__func__, __pa(priv->pgtable),
-					(ret == 0) ? "" : ", again");
+		return ret;
+	}
 
-	return ret;
+	dev_dbg(dev, "%s: Attached IOMMU with pgtable 0x%lx%s\n",
+		__func__, __pa(priv->pgtable), (ret == 0) ? "" : ", again");
+
+	return 0;
 }
 
 static void exynos_iommu_detach_device(struct iommu_domain *domain,
-- 
1.7.2.5



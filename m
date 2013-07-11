Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3GKLkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 07:40:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8779 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab3GKLki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 07:40:38 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-1d-51de99b424a1
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Prathyush K'" <prathyush@chromium.org>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>
References: <003101ce797b$5418e8e0$fc4abaa0$@samsung.com>
 <CAH=HWYMg4cD5kisxj3uUj+2_DvvgihE09tDO=9-2cVjJrnhMSg@mail.gmail.com>
In-reply-to: <CAH=HWYMg4cD5kisxj3uUj+2_DvvgihE09tDO=9-2cVjJrnhMSg@mail.gmail.com>
Subject: RE: [PATCH v7 9/9] iommu/exynos: add bus notifier for registering
 System MMU
Date: Thu, 11 Jul 2013 20:40:35 +0900
Message-id: <000001ce7e2b$75568120$60038360$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQGHWDd3zUx4NIK8ThXcfGtQq7+KGwHefwOgmd6c7VA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+Zoe6WmfcCDRo+8lm8OvKDyWLBfmuL
	ztkb2C02H1zHYtG74CqbReO9CWwWmx5fY7W4vGsOm8WM8/uYLC6s2MhuMWH+R1aLKYsOs1q0
	XO9lcuD1eHJwHpPH7IaLLB53ru1h89i8pN5j8o3ljB59W1YxenzeJBfAHsVlk5Kak1mWWqRv
	l8CVsfncSvaCqSeYKi5uaGRrYLxwnrGLkZ1DQsBEoqWsi5ETyBKTuHBvPVsXIxeHkMAyRom3
	nY1MXYwcYCWHX2tCxKczShxuWcoK0iAk8JdRYslVWRCbTUBLYvXc44wgtgiQ3X9nE9ggZoHN
	LBJd/UtYIBoaGCWuLIkDsTkFgiUer3zCDmILC4RL7Nv3jA3EZhFQleicdwmsnlfAUuLdoqXM
	ELagxI/J98DizEAL1u88zgRhy0tsXvOWGeIDBYkdZ19DHWEl8f7uMqh6EYl9L94xghwkIbCU
	Q2Lf3M8sEMsEJL5NPsQC8aWsxKYDUHMkJQ6uuMEygVFiFpLVs5CsnoVk9SwkKxYwsqxiFE0t
	SC4oTkovMtErTswtLs1L10vOz93ECEkFE3Yw3jtgfYgxGWj9RGYp0eR8YCrJK4k3NDYzsjA1
	MTU2Mrc0I01YSZxXvcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOjKUM1A7/Nqr7rNdYi
	m7bWXjfrXlsauKHj7f5vF5wcJa77Tp77vI5D7/Bf36Kpc1713GdJj336OObUmedJfeXHrD22
	5x5u5ruqNEuDxTh0w4fdqfNn/95eHxz4ctYpk5V8h5q4p8mwTK7Kn3pw+465dy/Vmj+JeqhZ
	mFlmeNfSaOu+vSy7y5g/KrEUZyQaajEXFScCAP6lXqQbAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOKsWRmVeSWpSXmKPExsVy+t9jQd0tM+8FGvzpYbF4deQHk8WC/dYW
	nbM3sFtsPriOxaJ3wVU2i8Z7E9gsNj2+xmpxedccNosZ5/cxWVxYsZHdYsL8j6wWUxYdZrVo
	ud7L5MDr8eTgPCaP2Q0XWTzuXNvD5rF5Sb3H5BvLGT36tqxi9Pi8SS6APaqB0SYjNTEltUgh
	NS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6FolhbLEnFKgUEBicbGS
	vh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8bmcyvZC6aeYKq4uKGRrYHxwnnGLkYODgkBE4nD
	rzW7GDmBTDGJC/fWs3UxcnEICUxnlDjcspQVJCEk8JdRYslVWRCbTUBLYvXc44wgtgiQ3X9n
	E1gDs8BmFomu/iUsEA0NjBJXlsSB2JwCwRKPVz5hB7GFBcIl9u17xgZiswioSnTOuwRWzytg
	KfFu0VJmCFtQ4sfke2BxZqAF63ceZ4Kw5SU2r3nLDHGpgsSOs6+hjrCSeH93GVS9iMS+F+8Y
	JzAKzUIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOBk80xqB+PK
	BotDjAIcjEo8vA3xdwOFWBPLiitzDzFKcDArifAKTr4XKMSbklhZlVqUH19UmpNafIgxGejT
	icxSosn5wESYVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2M
	3EH7marcX9hPaOA4PymyPP1ieGjTWqfnBXeTH184s6l99d9Aln0ZFzN+3Hx44/xXtTtLnKfr
	svqGZmm5/y/evULpsuKGaNa8GXfsuzm/lT9rPHrjG/eJ8o7SyTUZbwRvdzDq+fWkbjMTr72f
	f/8Lb/j6CJnTco5LozkCrrve/H1uQ1bkurpXSizFGYmGWsxFxYkAhRds4XoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Prathyush K [mailto:prathyush@chromium.org] 
> Sent: Thursday, July 11, 2013 12:03 AM
> 
> I think this patch can be split further.
> There is a lot more added in this patch (suspend/resume functions etc) than just adding a bus notifier.

Oh, Sorry for that ;-)

Actually, adding bus notifier is to register gpd_pm_ops to master peripheral devices,
it results in big change in the driver.

> 
> I will review further and also, test this patchset.
> 

Thank you very much.

> Regards,
> Prathyush
> 
> On Fri, Jul 5, 2013 at 5:59 PM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> When a device driver is registered, all constructs to handle System MMU
> is prepared by bus notifier call.
> 
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>  drivers/iommu/exynos-iommu.c |  778 ++++++++++++++++++++++++++++++-----------
>  1 files changed, 569 insertions(+), 209 deletions(-)
> 
> diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> index b151e51..51d43bb 100644
> --- a/drivers/iommu/exynos-iommu.c
> +++ b/drivers/iommu/exynos-iommu.c
> @@ -27,6 +27,9 @@
>  #include <linux/memblock.h>
>  #include <linux/export.h>
>  #include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/pm_domain.h>
> +#include <linux/notifier.h>
> 
>  #include <asm/cacheflush.h>
>  #include <asm/pgtable.h>
> @@ -80,6 +83,14 @@
>  #define CTRL_BLOCK     0x7
>  #define CTRL_DISABLE   0x0
> 
> +#define CFG_LRU                0x1
> +#define CFG_QOS(n)     ((n & 0xF) << 7)
> +#define CFG_MASK       0x0150FFFF /* Selecting bit 0-15, 20, 22 and 24 */
> +#define CFG_ACGEN      (1 << 24) /* System MMU 3.3 only */
> +#define CFG_SYSSEL     (1 << 22) /* System MMU 3.2 only */
> +#define CFG_FLPDCACHE  (1 << 20) /* System MMU 3.2+ only */
> +#define CFG_SHAREABLE  (1 << 12) /* System MMU 3.x only */
> +
>  #define REG_MMU_CTRL           0x000
>  #define REG_MMU_CFG            0x004
>  #define REG_MMU_STATUS         0x008
> @@ -96,6 +107,9 @@
> 
>  #define REG_MMU_VERSION                0x034
> 
> +#define MMU_MAJ_VER(reg)       (reg >> 28)
> +#define MMU_MIN_VER(reg)       ((reg >> 21) & 0x7F)
> +
>  #define REG_PB0_SADDR          0x04C
>  #define REG_PB0_EADDR          0x050
>  #define REG_PB1_SADDR          0x054
> @@ -126,16 +140,6 @@ enum exynos_sysmmu_inttype {
>         SYSMMU_FAULTS_NUM
>  };
> 
> -/*
> - * @itype: type of fault.
> - * @pgtable_base: the physical address of page table base. This is 0 if @itype
> - *                is SYSMMU_BUSERROR.
> - * @fault_addr: the device (virtual) address that the System MMU tried to
> - *             translated. This is 0 if @itype is SYSMMU_BUSERROR.
> - */
> -typedef int (*sysmmu_fault_handler_t)(enum exynos_sysmmu_inttype itype,
> -                       unsigned long pgtable_base, unsigned long fault_addr);
> -
>  static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
>         REG_PAGE_FAULT_ADDR,
>         REG_AR_FAULT_ADDR,
> @@ -159,6 +163,14 @@ static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
>         "UNKNOWN FAULT"
>  };
> 
> +struct exynos_iommu_client {
> +       struct list_head node;  /* entry of exynos_iommu_domain.clients */
> +       struct device *dev;
> +       spinlock_t lock;
> +       int num_sysmmu;
> +       struct device *sysmmu[0];
> +};
> +
>  struct exynos_iommu_domain {
>         struct list_head clients; /* list of sysmmu_drvdata.node */
>         unsigned long *pgtable; /* lv1 page table, 16KB */
> @@ -170,13 +182,13 @@ struct exynos_iommu_domain {
>  struct sysmmu_drvdata {
>         struct list_head node; /* entry of exynos_iommu_domain.clients */
>         struct device *sysmmu;  /* System MMU's device descriptor */
> -       struct device *dev;     /* Owner of system MMU */
> +       struct device *master;  /* Owner of system MMU */
>         int nsfrs;
>         struct clk *clk;
>         int activations;
>         spinlock_t lock;
>         struct iommu_domain *domain;
> -       sysmmu_fault_handler_t fault_handler;
> +       bool runtime_active;
>         unsigned long pgtable;
>         void __iomem *sfrbases[0];
>  };
> @@ -200,6 +212,20 @@ static bool is_sysmmu_active(struct sysmmu_drvdata *data)
>         return data->activations > 0;
>  }
> 
> +static unsigned int __sysmmu_version(struct sysmmu_drvdata *data,
> +                                       int idx, unsigned int *minor)
> +{
> +       unsigned int major;
> +
> +       major = readl(data->sfrbases[idx] + REG_MMU_VERSION);
> +
> +       if (minor)
> +               *minor = MMU_MIN_VER(major);
> +       major = MMU_MAJ_VER(major);
> +
> +       return major;
> +}
> +
>  static void sysmmu_unblock(void __iomem *sfrbase)
>  {
>         __raw_writel(CTRL_ENABLE, sfrbase + REG_MMU_CTRL);
> @@ -235,7 +261,6 @@ static void __sysmmu_tlb_invalidate_entry(void __iomem *sfrbase,
>  static void __sysmmu_set_ptbase(void __iomem *sfrbase,
>                                        unsigned long pgd)
>  {
> -       __raw_writel(0x1, sfrbase + REG_MMU_CFG); /* 16KB LV1, LRU */
>         __raw_writel(pgd, sfrbase + REG_PT_BASE_ADDR);
> 
>         __sysmmu_tlb_invalidate(sfrbase);
> @@ -292,34 +317,17 @@ finish:
>         spin_unlock_irqrestore(&data->lock, flags);
>  }
> 
> -static void __set_fault_handler(struct sysmmu_drvdata *data,
> -                                       sysmmu_fault_handler_t handler)
> -{
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(&data->lock, flags);
> -       data->fault_handler = handler;
> -       spin_unlock_irqrestore(&data->lock, flags);
> -}
> -
> -void exynos_sysmmu_set_fault_handler(struct device *dev,
> -                                       sysmmu_fault_handler_t handler)
> -{
> -       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> -
> -       __set_fault_handler(data, handler);
> -}
> -
> -static int default_fault_handler(enum exynos_sysmmu_inttype itype,
> -                    unsigned long pgtable_base, unsigned long fault_addr)
> +static int show_fault_information(const char *name,
> +               enum exynos_sysmmu_inttype itype,
> +               unsigned long pgtable_base, unsigned long fault_addr)
>  {
>         unsigned long *ent;
> 
>         if ((itype >= SYSMMU_FAULTS_NUM) || (itype < SYSMMU_PAGEFAULT))
>                 itype = SYSMMU_FAULT_UNKNOWN;
> 
> -       pr_err("%s occurred at 0x%lx(Page table base: 0x%lx)\n",
> -                       sysmmu_fault_name[itype], fault_addr, pgtable_base);
> +       pr_err("%s occurred at 0x%lx by %s(Page table base: 0x%lx)\n",
> +               sysmmu_fault_name[itype], fault_addr, name, pgtable_base);
> 
>         ent = section_entry(__va(pgtable_base), fault_addr);
>         pr_err("\tLv1 entry: 0x%lx\n", *ent);
> @@ -340,25 +348,34 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
>  {
>         /* SYSMMU is in blocked when interrupt occurred. */
>         struct sysmmu_drvdata *data = dev_id;
> -       struct resource *irqres;
> -       struct platform_device *pdev;
> +       struct exynos_iommu_client *client = NULL;
> +       struct resource *memres;
>         enum exynos_sysmmu_inttype itype;
>         unsigned long addr = -1;
> -
>         int i, ret = -ENOSYS;
> 
> -       spin_lock(&data->lock);
> +       if (data->master)
> +               client = data->master->archdata.iommu;
> 
>         WARN_ON(!is_sysmmu_active(data));
> 
> -       pdev = to_platform_device(data->sysmmu);
> -       for (i = 0; i < (pdev->num_resources / 2); i++) {
> -               irqres = platform_get_resource(pdev, IORESOURCE_IRQ, i);
> -               if (irqres && ((int)irqres->start == irq))
> +       for (i = 0; i < data->nsfrs; i++) {
> +               struct resource *irqres;
> +               irqres = platform_get_resource(to_platform_device(data->sysmmu),
> +                                               IORESOURCE_IRQ, i);
> +               if (irqres && ((int)irqres->start == irq)) {
> +                       memres = platform_get_resource(
> +                                       to_platform_device(data->sysmmu),
> +                                       IORESOURCE_MEM, i);
>                         break;
> +               }
>         }
> 
> -       if (i == pdev->num_resources) {
> +       if (client)
> +               spin_lock(&client->lock);
> +       spin_lock(&data->lock);
> +
> +       if (i == data->nsfrs) {
>                 itype = SYSMMU_FAULT_UNKNOWN;
>         } else {
>                 itype = (enum exynos_sysmmu_inttype)
> @@ -371,197 +388,263 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
>         }
> 
>         if (data->domain)
> -               ret = report_iommu_fault(data->domain, data->dev,
> +               ret = report_iommu_fault(data->domain, data->master,
>                                 addr, itype);
> 
> -       if ((ret == -ENOSYS) && data->fault_handler) {
> -               unsigned long base = data->pgtable;
> -               if (itype != SYSMMU_FAULT_UNKNOWN)
> -                       base = __raw_readl(
> -                                       data->sfrbases[i] + REG_PT_BASE_ADDR);
> -               ret = data->fault_handler(itype, base, addr);
> -       }
> -
>         if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
>                 __raw_writel(1 << itype, data->sfrbases[i] + REG_INT_CLEAR);
> -       else
> -               dev_dbg(data->sysmmu, "%s is not handled.\n",
> -                               sysmmu_fault_name[itype]);
> +       else {
> +               unsigned long ba = data->pgtable;
> +               if (itype != SYSMMU_FAULT_UNKNOWN)
> +                       ba = __raw_readl(data->sfrbases[i] + REG_PT_BASE_ADDR);
> +               show_fault_information(dev_name(data->sysmmu),
> +                                       itype, ba, addr);
> +       }
> 
>         if (itype != SYSMMU_FAULT_UNKNOWN)
>                 sysmmu_unblock(data->sfrbases[i]);
> 
>         spin_unlock(&data->lock);
> +       if (client)
> +               spin_unlock(&client->lock);
> 
>         return IRQ_HANDLED;
>  }
> 
> -static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
> +static void __sysmmu_disable_nocount(struct sysmmu_drvdata *data)
>  {
> +               int i;
> +
> +               for (i = 0; i < data->nsfrs; i++) {
> +                       __raw_writel(CTRL_DISABLE,
> +                                    data->sfrbases[i] + REG_MMU_CTRL);
> +                       __raw_writel(0, data->sfrbases[i] + REG_MMU_CFG);
> +               }
> +
> +               clk_disable(data->clk);
> +}
> +
> +static bool __sysmmu_disable(struct sysmmu_drvdata *data)
> +{
> +       bool disabled;
>         unsigned long flags;
> -       bool disabled = false;
> -       int i;
> 
>         spin_lock_irqsave(&data->lock, flags);
> 
> -       if (!set_sysmmu_inactive(data))
> -               goto finish;
> +       disabled = set_sysmmu_inactive(data);
> 
> -       for (i = 0; i < data->nsfrs; i++)
> -               __raw_writel(CTRL_DISABLE, data->sfrbases[i] + REG_MMU_CTRL);
> +       if (disabled) {
> +               data->pgtable = 0;
> +               data->domain = NULL;
> 
> -       if (data->clk)
> -               clk_disable(data->clk);
> +               if (data->runtime_active)
> +                       __sysmmu_disable_nocount(data);
> 
> -       disabled = true;
> -       data->pgtable = 0;
> -       data->domain = NULL;
> -finish:
> -       spin_unlock_irqrestore(&data->lock, flags);
> -
> -       if (disabled)
>                 dev_dbg(data->sysmmu, "Disabled\n");
> -       else
> -               dev_dbg(data->sysmmu, "%d times left to be disabled\n",
> +       } else  {
> +               dev_dbg(data->sysmmu, "%d times left to disable\n",
>                                         data->activations);
> +       }
> +
> +       spin_unlock_irqrestore(&data->lock, flags);
> 
>         return disabled;
>  }
> 
> -/* __exynos_sysmmu_enable: Enables System MMU
> - *
> - * returns -error if an error occurred and System MMU is not enabled,
> - * 0 if the System MMU has been just enabled and 1 if System MMU was already
> - * enabled before.
> - */
> -static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
> +
> +static void __sysmmu_init_config(struct sysmmu_drvdata *data, int idx)
> +{
> +       unsigned long cfg = CFG_LRU;
> +       int maj, min = 0;
> +
> +       maj = __sysmmu_version(data, idx, &min);
> +       if (maj == 3) {
> +               cfg |= CFG_SHAREABLE;
> +               if (min > 1) {
> +                       cfg |= CFG_FLPDCACHE;
> +                       cfg |= (min == 2) ? CFG_SYSSEL : CFG_ACGEN;
> +               }
> +       }
> +
> +       cfg |= __raw_readl(data->sfrbases[idx] + REG_MMU_CFG) & ~CFG_MASK;
> +       __raw_writel(cfg, data->sfrbases[idx] + REG_MMU_CFG);
> +}
> +
> +static void __sysmmu_enable_nocount(struct sysmmu_drvdata *data)
> +{
> +       int i;
> +
> +       clk_enable(data->clk);
> +
> +       for (i = 0; i < data->nsfrs; i++) {
> +               BUG_ON(__raw_readl(data->sfrbases[i] + REG_MMU_CTRL)
> +                                                               & CTRL_ENABLE);
> 
> We are assuming that the REG_MMU_CTRL will be 0 in the beginning.
> In the newer versions of smmus (e.g. FIMD's sysmmu in Exynos5420), the reset value of REG_MMU_CTRL is 1.
> So this BUG will be triggered when sysmmu gets enabled for the first time.
> 
> One way to fix this is to pass an additional parameter to this function 'init':
> The BUG_ON should not be checked when sysmmu is enabled for first time i.e. from __sysmmu_enable (init = true)
> And the BUG_ON can be checked when this function is called from else where (init = false)

You pointed correctly.

This driver does not consider the SoC after Exynos5250.

Actually the BUG_ON is not required because __sysmmu_enable_nocount(
soon writes CTRL_ENABLE to MMU_CTRL.
Why I put the checking MMU_CTRL before enabling System MMU is
just related to our team's SoC S/W solution.

I don't feel that it is required to add additional parameter to that function.
Just writing CTRL_BLOCK to MMU_CTRL is enough instead of BUG_ON().


>  
> +
> +               __sysmmu_init_config(data, i);
> +
> +               __sysmmu_set_ptbase(data->sfrbases[i], data->pgtable);
> +
> +               __raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
> +       }
> +}
> +
> +static int __sysmmu_enable(struct sysmmu_drvdata *data,
>                         unsigned long pgtable, struct iommu_domain *domain)
>  {
> -       int i, ret = 0;
> +       int ret = 0;
>         unsigned long flags;
> 
>         spin_lock_irqsave(&data->lock, flags);
> +       if (set_sysmmu_active(data)) {
> +               data->pgtable = pgtable;
> +               data->domain = domain;
> 
> -       if (!set_sysmmu_active(data)) {
> -               if (WARN_ON(pgtable != data->pgtable)) {
> -                       ret = -EBUSY;
> -                       set_sysmmu_inactive(data);
> -               } else {
> -                       ret = 1;
> -               }
> +               if (data->runtime_active)
> +                       __sysmmu_enable_nocount(data);
> 
> -               dev_dbg(data->sysmmu, "Already enabled\n");
> -               goto finish;
> +               dev_dbg(data->sysmmu, "Enabled\n");
> +       } else {
> +               ret = (pgtable == data->pgtable) ? 1 : -EBUSY;
> +
> +               dev_dbg(data->sysmmu, "already enabled\n");
>         }
> 
> -       if (data->clk)
> -               clk_enable(data->clk);
> +       if (WARN_ON(ret < 0))
> +               set_sysmmu_inactive(data); /* decrement count */
> 
> -       data->pgtable = pgtable;
> +       spin_unlock_irqrestore(&data->lock, flags);
> 
> -       for (i = 0; i < data->nsfrs; i++) {
> -               __sysmmu_set_ptbase(data->sfrbases[i], pgtable);
> +       return ret;
> +}
> 
> -               if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
> -                       /* System MMU version is 3.x */
> -                       __raw_writel((1 << 12) | (2 << 28),
> -                                       data->sfrbases[i] + REG_MMU_CFG);
> -                       __sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 0);
> -                       __sysmmu_set_prefbuf(data->sfrbases[i], 0, -1, 1);
> -               }
> +/* __exynos_sysmmu_enable: Enables System MMU
> + *
> + * returns -error if an error occurred and System MMU is not enabled,
> + * 0 if the System MMU has been just enabled and 1 if System MMU was already
> + * enabled before.
> + */
> +static int __exynos_sysmmu_enable(struct device *dev, unsigned long pgtable,
> +                                 struct iommu_domain *domain)
> +{
> +       int ret = 0;
> +       unsigned long flags;
> +       struct exynos_iommu_client *client = dev->archdata.iommu;
> +       int i;
> 
> -               __raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
> -       }
> +       if (WARN_ON(!client))
> +               return -ENODEV;
> 
> -       data->domain = domain;
> +       spin_lock_irqsave(&client->lock, flags);
> 
> -       dev_dbg(data->sysmmu, "Enabled\n");
> -finish:
> -       spin_unlock_irqrestore(&data->lock, flags);
> +       for (i = 0; i < client->num_sysmmu; i++) {
> +               struct sysmmu_drvdata *data =
> +                               dev_get_drvdata(client->sysmmu[i]);
> +               ret = __sysmmu_enable(data, pgtable, domain);
> +               if (ret < 0) {
> +                       int j;
> +                       for (j = 0; j < i; j++)
> +                               __sysmmu_disable(data);
> +                       break;
> +               } else {
> +                       data->master = dev;
> +               }
> +       }
> +
> +       spin_unlock_irqrestore(&client->lock, flags);
> 
>         return ret;
>  }
> 
>  int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
>  {
> -       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
>         int ret;
> 
>         BUG_ON(!memblock_is_memory(pgtable));
> 
> -       ret = pm_runtime_get_sync(data->sysmmu);
> -       if (ret < 0) {
> -               dev_dbg(data->sysmmu, "Failed to enable\n");
> -               return ret;
> -       }
> -
> -       ret = __exynos_sysmmu_enable(data, pgtable, NULL);
> -       if (WARN_ON(ret < 0)) {
> -               pm_runtime_put(data->sysmmu);
> -               dev_err(data->sysmmu,
> -                       "Already enabled with page table %#lx\n",
> -                       data->pgtable);
> -       } else {
> -               data->dev = dev;
> -       }
> +       ret = __exynos_sysmmu_enable(dev, pgtable, NULL);
> 
>         return ret;
>  }
> 
>  static bool exynos_sysmmu_disable(struct device *dev)
>  {
> -       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> -       bool disabled;
> +       unsigned long flags;
> +       bool disabled = true;
> +       struct exynos_iommu_client *client = dev->archdata.iommu;
> +       int i;
> +
> +       if (WARN_ON(!client))
> +               return true;
> +
> +       spin_lock_irqsave(&client->lock, flags);
> +
> +       /* Every call to __sysmmu_disable() must return same result */
> +       for (i = 0; i < client->num_sysmmu; i++) {
> +               struct sysmmu_drvdata *data =
> +                               dev_get_drvdata(client->sysmmu[i]);
> +               disabled = __sysmmu_disable(data);
> +               if (disabled)
> +                       data->master = NULL;
> +       }
> 
> -       disabled = __exynos_sysmmu_disable(data);
> -       pm_runtime_put(data->sysmmu);
> +       spin_unlock_irqrestore(&client->lock, flags);
> 
>         return disabled;
>  }
> 
>  static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
>  {
> -       unsigned long flags;
> -       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> +       struct exynos_iommu_client *client = dev->archdata.iommu;
> +       int i;
> 
> -       spin_lock_irqsave(&data->lock, flags);
> +       for (i = 0; i < client->num_sysmmu; i++) {
> +               unsigned long flags;
> +               struct sysmmu_drvdata *data;
> 
> -       if (is_sysmmu_active(data)) {
> -               int i;
> -               for (i = 0; i < data->nsfrs; i++) {
> -                       if (sysmmu_block(data->sfrbases[i])) {
> +               data = dev_get_drvdata(client->sysmmu[i]);
> +
> +               spin_lock_irqsave(&data->lock, flags);
> +               if (is_sysmmu_active(data) && data->runtime_active) {
> +                       int i;
> +                       for (i = 0; i < data->nsfrs; i++)
>                                 __sysmmu_tlb_invalidate_entry(
>                                                 data->sfrbases[i], iova);
> -                               sysmmu_unblock(data->sfrbases[i]);
> -                       }
> +               } else {
> +                       dev_dbg(dev,
> +                               "disabled. Skipping TLB invalidation @ %#lx\n",
> +                               iova);
>                 }
> -       } else {
> -               dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
> +               spin_unlock_irqrestore(&data->lock, flags);
>         }
> -
> -       spin_unlock_irqrestore(&data->lock, flags);
>  }
> 
>  void exynos_sysmmu_tlb_invalidate(struct device *dev)
>  {
> -       unsigned long flags;
> -       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> -
> -       spin_lock_irqsave(&data->lock, flags);
> +       struct exynos_iommu_client *client = dev->archdata.iommu;
> +       int i;
> 
> -       if (is_sysmmu_active(data)) {
> -               int i;
> -               for (i = 0; i < data->nsfrs; i++) {
> -                       if (sysmmu_block(data->sfrbases[i])) {
> -                               __sysmmu_tlb_invalidate(data->sfrbases[i]);
> -                               sysmmu_unblock(data->sfrbases[i]);
> +       for (i = 0; i < client->num_sysmmu; i++) {
> +               unsigned long flags;
> +               struct sysmmu_drvdata *data;
> +
> +               data = dev_get_drvdata(client->sysmmu[i]);
> +
> +               spin_lock_irqsave(&data->lock, flags);
> +               if (is_sysmmu_active(data) &&
> +                               data->runtime_active) {
> +                       int i;
> +                       for (i = 0; i < data->nsfrs; i++) {
> +                               if (sysmmu_block(data->sfrbases[i])) {
> +                                       __sysmmu_tlb_invalidate(
> +                                                       data->sfrbases[i]);
> +                                       sysmmu_unblock(data->sfrbases[i]);
> +                               }
>                         }
> +               } else {
> +                       dev_dbg(dev, "disabled. Skipping TLB invalidation\n");
>                 }
> -       } else {
> -               dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
> +               spin_unlock_irqrestore(&data->lock, flags);
>         }
> -
> -       spin_unlock_irqrestore(&data->lock, flags);
>  }
> 
>  static int __init exynos_sysmmu_probe(struct platform_device *pdev)
> @@ -622,8 +705,6 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
> 
>         pm_runtime_enable(dev);
> 
> -       __set_fault_handler(data, &default_fault_handler);
> -
>         data->sysmmu = dev;
>         data->clk = devm_clk_get(dev, "sysmmu");
>         if (IS_ERR(data->clk)) {
> @@ -647,6 +728,8 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
>                 }
>         }
> 
> +       data->runtime_active = !pm_runtime_enabled(dev);
> 
> We are enabling pm_runtime in the probe itself. Is this check still required?
> We can directly set data->runtime_active to false since sysmmus get probed first.

It is required to work correctly without checking if CONFIG_PM_RUNTIME is configured or not.

> 
> +
>         spin_lock_init(&data->lock);
>         INIT_LIST_HEAD(&data->node);
> 
> @@ -656,6 +739,34 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
>         return ret;
>  }
> 
> +#ifdef CONFIG_PM_SLEEP
> +static int sysmmu_suspend(struct device *dev)
> +{
> +       struct sysmmu_drvdata *data = dev_get_drvdata(dev);
> +       unsigned long flags;
> +       spin_lock_irqsave(&data->lock, flags);
> +       if (is_sysmmu_active(data) &&
> +               (!pm_runtime_enabled(dev) || data->runtime_active))
> +               __sysmmu_disable_nocount(data);
> +       spin_unlock_irqrestore(&data->lock, flags);
> +       return 0;
> +}
> +
> +static int sysmmu_resume(struct device *dev)
> +{
> +       struct sysmmu_drvdata *data = dev_get_drvdata(dev);
> +       unsigned long flags;
> +       spin_lock_irqsave(&data->lock, flags);
> +       if (is_sysmmu_active(data) &&
> +               (!pm_runtime_enabled(dev) || data->runtime_active))
> +               __sysmmu_enable_nocount(data);
> +       spin_unlock_irqrestore(&data->lock, flags);
> +       return 0;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(sysmmu_pm_ops, sysmmu_suspend, sysmmu_resume);
> +
>  #ifdef CONFIG_OF
>  static struct of_device_id sysmmu_of_match[] __initconst = {
>         { .compatible   = "samsung,exynos4210-sysmmu", },
> @@ -668,6 +779,7 @@ static struct platform_driver exynos_sysmmu_driver __refdata = {
>         .driver = {
>                 .owner          = THIS_MODULE,
>                 .name           = "exynos-sysmmu",
> +               .pm             = &sysmmu_pm_ops,
>                 .of_match_table = of_match_ptr(sysmmu_of_match),
>         }
>  };
> @@ -720,7 +832,7 @@ err_pgtable:
>  static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
>  {
>         struct exynos_iommu_domain *priv = domain->priv;
> -       struct sysmmu_drvdata *data;
> +       struct exynos_iommu_client *client;
>         unsigned long flags;
>         int i;
> 
> @@ -728,11 +840,14 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
> 
>         spin_lock_irqsave(&priv->lock, flags);
> 
> -       list_for_each_entry(data, &priv->clients, node) {
> -               while (!exynos_sysmmu_disable(data->dev))
> +       list_for_each_entry(client, &priv->clients, node) {
> +               while (!exynos_sysmmu_disable(client->dev))
>                         ; /* until System MMU is actually disabled */
>         }
> 
> +       while (!list_empty(&priv->clients))
> +               list_del_init(priv->clients.next);
> +
>         spin_unlock_irqrestore(&priv->lock, flags);
> 
>         for (i = 0; i < NUM_LV1ENTRIES; i++)
> @@ -749,41 +864,26 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
>  static int exynos_iommu_attach_device(struct iommu_domain *domain,
>                                    struct device *dev)
>  {
> -       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> +       struct exynos_iommu_client *client = dev->archdata.iommu;
>         struct exynos_iommu_domain *priv = domain->priv;
>         unsigned long flags;
>         int ret;
> 
> -       ret = pm_runtime_get_sync(data->sysmmu);
> -       if (ret < 0)
> -               return ret;
> -
> -       ret = 0;
> -
>         spin_lock_irqsave(&priv->lock, flags);
> 
> -       ret = __exynos_sysmmu_enable(data, __pa(priv->pgtable), domain);
> -
> -       if (ret == 0) {
> -               /* 'data->node' must not be appeared in priv->clients */
> -               BUG_ON(!list_empty(&data->node));
> -               data->dev = dev;
> -               list_add_tail(&data->node, &priv->clients);
> -       }
> +       ret = __exynos_sysmmu_enable(dev, __pa(priv->pgtable), domain);
> +       if (ret == 0)
> +               list_add_tail(&client->node, &priv->clients);
> 
>         spin_unlock_irqrestore(&priv->lock, flags);
> 
> -       if (ret < 0) {
> +       if (ret < 0)
>                 dev_err(dev, "%s: Failed to attach IOMMU with pgtable %#lx\n",
>                                 __func__, __pa(priv->pgtable));
> -               pm_runtime_put(data->sysmmu);
> -       } else if (ret > 0) {
> -               dev_dbg(dev, "%s: IOMMU with pgtable 0x%lx already attached\n",
> -                                       __func__, __pa(priv->pgtable));
> -       } else {
> -               dev_dbg(dev, "%s: Attached new IOMMU with pgtable 0x%lx\n",
> -                                       __func__, __pa(priv->pgtable));
> -       }
> +       else
> +               dev_dbg(dev, "%s: Attached IOMMU with pgtable 0x%lx%s\n",
> +                                       __func__, __pa(priv->pgtable),
> +                                       (ret == 0) ? "" : ", again");
> 
>         return ret;
>  }
> @@ -791,39 +891,27 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
>  static void exynos_iommu_detach_device(struct iommu_domain *domain,
>                                     struct device *dev)
>  {
> -       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> +       struct exynos_iommu_client *client = NULL;
>         struct exynos_iommu_domain *priv = domain->priv;
> -       struct list_head *pos;
>         unsigned long flags;
> -       bool found = false;
> 
>         spin_lock_irqsave(&priv->lock, flags);
> 
> -       list_for_each(pos, &priv->clients) {
> -               if (list_entry(pos, struct sysmmu_drvdata, node) == data) {
> -                       found = true;
> +       list_for_each_entry(client, &priv->clients, node) {
> +               if (client == dev->archdata.iommu) {
> +                       if (exynos_sysmmu_disable(dev))
> +                               list_del_init(&client->node);
>                         break;
>                 }
>         }
> 
> -       if (!found)
> -               goto finish;
> +       spin_unlock_irqrestore(&priv->lock, flags);
> 
> -       if (__exynos_sysmmu_disable(data)) {
> +       if (client == dev->archdata.iommu)
>                 dev_dbg(dev, "%s: Detached IOMMU with pgtable %#lx\n",
>                                         __func__, __pa(priv->pgtable));
> -               list_del_init(&data->node);
> -
> -       } else {
> -               dev_dbg(dev, "%s: Detaching IOMMU with pgtable %#lx delayed",
> -                                       __func__, __pa(priv->pgtable));
> -       }
> -
> -finish:
> -       spin_unlock_irqrestore(&priv->lock, flags);
> -
> -       if (found)
> -               pm_runtime_put(data->sysmmu);
> +       else
> +               dev_dbg(dev, "%s: No IOMMU is attached\n", __func__);
>  }
> 
>  static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
> @@ -940,7 +1028,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
>                                                unsigned long iova, size_t size)
>  {
>         struct exynos_iommu_domain *priv = domain->priv;
> -       struct sysmmu_drvdata *data;
> +       struct exynos_iommu_client *client;
>         unsigned long flags;
>         unsigned long *ent;
>         size_t err_page;
> @@ -997,8 +1085,8 @@ done:
>         spin_unlock_irqrestore(&priv->pgtablelock, flags);
> 
>         spin_lock_irqsave(&priv->lock, flags);
> -       list_for_each_entry(data, &priv->clients, node)
> -               sysmmu_tlb_invalidate_entry(data->dev, iova);
> +       list_for_each_entry(client, &priv->clients, node)
> +               sysmmu_tlb_invalidate_entry(client->dev, iova);
>         spin_unlock_irqrestore(&priv->lock, flags);
> 
>         return size;
> @@ -1082,3 +1170,275 @@ static int __init exynos_iommu_init(void)
>         return ret;
>  }
>  subsys_initcall(exynos_iommu_init);
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int sysmmu_pm_genpd_suspend(struct device *dev)
> +{
> +       struct exynos_iommu_client *client = dev->archdata.iommu;
> +       int ret = 0;
> +       int i;
> +
> +       for (i = 0; i < client->num_sysmmu; i++) {
> +               ret = pm_generic_suspend(client->sysmmu[i]);
> +               if (ret)
> +                       break;
> +       }
> +
> +       if (!ret)
> +               ret = pm_generic_suspend(dev);
> +
> +       if (ret) {
> +               int j;
> +
> +               for (j = 0; j < i; j++)
> +                       pm_generic_resume(client->sysmmu[j]);
> +       }
> +
> +       return ret;
> +}
> +
> +static int sysmmu_pm_genpd_resume(struct device *dev)
> +{
> +       struct exynos_iommu_client *client = dev->archdata.iommu;
> +       int ret = 0;
> +       int i;
> +
> +       for (i = 0; i < client->num_sysmmu; i++) {
> +               ret = pm_generic_resume(client->sysmmu[i]);
> +               if (ret)
> +                       break;
> +       }
> +
> +       if (!ret)
> +               ret = pm_generic_resume(dev);
> +
> +       if (ret) {
> +               int j;
> +
> +               for (j = 0; j < i; j++)
> +                       pm_generic_suspend(client->sysmmu[j]);
> +       }
> +
> +       return ret;
> +}
> +#endif
> +
> +#ifdef CONFIG_PM_RUNTIME
> +static void sysmmu_restore_state(struct device *sysmmu)
> +{
> +       struct sysmmu_drvdata *data = dev_get_drvdata(sysmmu);
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&data->lock, flags);
> +       data->runtime_active = true;
> +       if (is_sysmmu_active(data))
> +               __sysmmu_enable_nocount(data);
> +       spin_unlock_irqrestore(&data->lock, flags);
> +}
> +
> +static void sysmmu_save_state(struct device *sysmmu)
> +{
> +       struct sysmmu_drvdata *data = dev_get_drvdata(sysmmu);
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&data->lock, flags);
> +       if (is_sysmmu_active(data))
> +               __sysmmu_disable_nocount(data);
> +       data->runtime_active = false;
> +       spin_unlock_irqrestore(&data->lock, flags);
> +}
> +
> +static int sysmmu_pm_genpd_save_state(struct device *dev)
> +{
> +       struct exynos_iommu_client *client = dev->archdata.iommu;
> +       int (*cb)(struct device *__dev);
> +       int i;
> +
> +       if (dev->type && dev->type->pm)
> +               cb = dev->type->pm->runtime_suspend;
> +       else if (dev->class && dev->class->pm)
> +               cb = dev->class->pm->runtime_suspend;
> +       else if (dev->bus && dev->bus->pm)
> +               cb = dev->bus->pm->runtime_suspend;
> +       else
> +               cb = NULL;
> +
> +       if (!cb && dev->driver && dev->driver->pm)
> +               cb = dev->driver->pm->runtime_suspend;
> +
> +       if (cb) {
> +               int ret;
> +
> +               ret = cb(dev);
> +               if (ret)
> +                       return ret;
> +       }
> +
> +       for (i = 0; i < client->num_sysmmu; i++)
> +               sysmmu_save_state(client->sysmmu[i]);
> +
> +       return 0;
> +}
> +
> +static int sysmmu_pm_genpd_restore_state(struct device *dev)
> +{
> +       struct exynos_iommu_client *client = dev->archdata.iommu;
> +       int (*cb)(struct device *__dev);
> +       int i;
> +
> +       if (dev->type && dev->type->pm)
> +               cb = dev->type->pm->runtime_resume;
> +       else if (dev->class && dev->class->pm)
> +               cb = dev->class->pm->runtime_resume;
> +       else if (dev->bus && dev->bus->pm)
> +               cb = dev->bus->pm->runtime_resume;
> +       else
> +               cb = NULL;
> +
> +       if (!cb && dev->driver && dev->driver->pm)
> +               cb = dev->driver->pm->runtime_resume;
> +
> +       for (i = 0; i < client->num_sysmmu; i++)
> +               sysmmu_restore_state(client->sysmmu[i]);
> +
> +       if (cb) {
> +               int ret;
> +               ret = cb(dev);
> +               if (ret) {
> +                       for (i = 0; i < client->num_sysmmu; i++)
> +                               sysmmu_save_state(client->sysmmu[i]);
> +                       return ret;
> +               }
> +       }
> +
> +       return 0;
> +}
> +#endif
> +
> +#ifdef CONFIG_PM_GENERIC_DOMAINS
> +struct gpd_dev_ops sysmmu_devpm_ops = {
> +#ifdef CONFIG_PM_RUNTIME
> +       .save_state = &sysmmu_pm_genpd_save_state,
> +       .restore_state = &sysmmu_pm_genpd_restore_state,
> +#endif
> +#ifdef CONFIG_PM_SLEEP
> +       .suspend = &sysmmu_pm_genpd_suspend,
> +       .resume = &sysmmu_pm_genpd_resume,
> +#endif
> +};
> +#endif /* CONFIG_PM_GENERIC_DOMAINS */
> +
> +static int sysmmu_hook_driver_register(struct notifier_block *nb,
> +                                       unsigned long val,
> +                                       void *p)
> +{
> +       struct device *dev = p;
> +
> +       switch (val) {
> +       case BUS_NOTIFY_BIND_DRIVER:
> +       {
> +               int i = 0;
> +               int size = 0;
> +               const __be32 *phandle;
> +               struct exynos_iommu_client *client;
> +
> +               phandle = of_get_property(dev->of_node, "iommu", &size);
> +               if (!phandle)
> +                       break;
> +
> +               size = size / sizeof(*phandle); /* number of elements */
> +
> +               client = devm_kzalloc(dev, sizeof(*client) * size, GFP_KERNEL);
> +               if (!client) {
> +                       dev_err(dev, "No Memory for exynos_iommu_client\n");
> +                       return -ENOMEM;
> +               }
> +
> +               client->num_sysmmu = size;
> +               client->dev = dev;
> +               INIT_LIST_HEAD(&client->node);
> +               spin_lock_init(&client->lock);
> +
> +               for (i = 0; i < size; i++) {
> +                       struct device_node *np;
> +                       struct platform_device *sysmmu;
> +
> +                       /* this always success: see above of_find_property() */
> +                       np = of_parse_phandle(dev->of_node, "iommu", i);
> +
> +                       sysmmu = of_find_device_by_node(np);
> +                       if (!sysmmu) {
> +                               dev_err(dev,
> +                                       "sysmmu node '%s' is not found\n",
> +                                       np->name);
> +                               break;
> +                       }
> +
> +                       client->sysmmu[i] = &sysmmu->dev;
> +               }
> +
> +               if (i < size) {
> +                       while (--i >= 0)
> +                               of_node_put(client->sysmmu[i]->of_node);
> +                       devm_kfree(dev, client);
> +                       return -ENODEV;
> +               }
> +
> +               i = pm_genpd_add_callbacks(dev, &sysmmu_devpm_ops, NULL);
> +               if (i && (i != -ENOSYS)) {
> +                       dev_err(dev,
> +                               "Failed to register 'dev_pm_ops' for iommu\n");
> +                       devm_kfree(dev, client);
> +                       return i;
> +               }
> +
> +               dev->archdata.iommu = client;
> +               break;
> +       }
> +       case BUS_NOTIFY_BOUND_DRIVER:
> +       {
> +               struct exynos_iommu_client *client = dev->archdata.iommu;
> +               if (dev->archdata.iommu &&
> +                               (!pm_runtime_enabled(dev) ||
> +                                        IS_ERR(dev_to_genpd(dev)))) {
> +                       int i;
> +                       for (i = 0; i < client->num_sysmmu; i++) {
> +                               struct sysmmu_drvdata *data;
> +                               pm_runtime_disable(client->sysmmu[i]);
> +                               data = dev_get_drvdata(client->sysmmu[i]);
> +                               if (!data)
> +                                       continue;
> +                               data->runtime_active =
> +                                       !pm_runtime_enabled(data->sysmmu);
> +                               if (data->runtime_active &&
> +                                               is_sysmmu_active(data))
> +                                       __sysmmu_enable_nocount(data);
> +                       }
> +               }
> +               break;
> +       }
> +       case BUS_NOTIFY_UNBOUND_DRIVER:
> +       {
> +               if (dev->archdata.iommu) {
> +                       __pm_genpd_remove_callbacks(dev, false);
> +
> +                       devm_kfree(dev, dev->archdata.iommu);
> +
> +                       dev->archdata.iommu = NULL;
> +               }
> +               break;
> +       }
> +       } /* switch (val) */
> +
> +       return 0;
> +}
> +
> +static struct notifier_block sysmmu_notifier = {
> +       .notifier_call = &sysmmu_hook_driver_register,
> +};
> +
> +static int __init exynos_iommu_prepare(void)
> +{
> +       return bus_register_notifier(&platform_bus_type, &sysmmu_notifier);
> +}
> +arch_initcall(exynos_iommu_prepare);
> --
> 1.7.2.5
> 


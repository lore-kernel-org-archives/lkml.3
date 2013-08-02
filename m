Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab3HBGml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 02:42:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29598 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab3HBGmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 02:42:38 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-30-51fb54dcfbcb
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Rahul Sharma'" <r.sh.open@gmail.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'sunil joshi'" <joshi@samsung.com>
References: <004001ce89f3$813c8b50$83b5a1f0$@samsung.com>
 <CAPdUM4Ohb9U+TpqbivXzUnAbHp2nDT2htFZ-0dXn_dQ8WBiJXQ@mail.gmail.com>
In-reply-to: <CAPdUM4Ohb9U+TpqbivXzUnAbHp2nDT2htFZ-0dXn_dQ8WBiJXQ@mail.gmail.com>
Subject: RE: [PATCH v8 10/12] iommu/exynos: add bus notifier for registering
 System MMU
Date: Fri, 02 Aug 2013 15:42:35 +0900
Message-id: <001b01ce8f4b$79449520$6bcdbf60$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: AQLqauMMbLaDwk/gxMuuivzJvITs7gLhukuclzKvLaA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t8zI907Ib8DDU4vlra4c/ccq8WrIz+Y
	LBbst7b4vusLu8Xmg+tYLHoXXGWzaLw3gc3i46nj7BabHl9jtbi8aw6bxYzz+5gsLqzYyG6x
	8EW8xZRFh1ktTv7pZbRoud7L5CDgMbvhIovHzll32T3uXNvD5nF+0xpmj81L6j0m31jO6NG3
	ZRWjx+dNch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mro6e5gLJi4nani3FbfBsZ9hxi7GDk4JARM
	JC7dEehi5AQyxSQu3FvP1sXIxSEksIxRonP5dlaIhInE8rUvmCES0xklrn9rhHL+Mkp8ffCC
	DaSKTUBLYvXc44wgtoiAhsTHF6fBRjEL7GaVmDzrCCNERwOjxImn88HmcgoES5zceY4ZxBYW
	iJQ4vfcBO4jNIqAqsfzAWzCbV8BSYmrrWVYIW1Dix+R7LCA2M9C29TuPM0HY8hKb17xlhrhV
	QWLH2deMEHERiX0v3kFdZCVxePE7sIskBE5wSHw7P4EJYpmAxLfJh1gggSErsekA1BxJiYMr
	brBMYJSYhWT1LCSrZyFZPQvJugWMLKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxQhLIhB2M
	9w5YH2JMBlo/kVlKNDkfmIDySuINjc2MLExNTI2NzC3NSBNWEudVb7EOFBJITyxJzU5NLUgt
	ii8qzUktPsTIxMEp1cCod91nw60qHYGuQyqt67aK1Nhpaeyo7typJexQ7J6mp3Nt0r2/Ky1X
	LpmkM63GPrRo1r0vri4rhC70VLzwiLLN2VxpInSoZMmhgvWPX9T3vJXUucT3g/9MKvv7RyYn
	JKRW9MlcmmIeNiXfssBveuWrxQrFcbt+FAusXrRdreuFb+kao6XSu1uVWIozEg21mIuKEwG+
	vx81NgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e+xoO6dkN+BBm+/8lvcuXuO1eLVkR9M
	Fgv2W1t83/WF3WLzwXUsFr0LrrJZNN6bwGbx8dRxdotNj6+xWlzeNYfNYsb5fUwWF1ZsZLdY
	+CLeYsqiw6wWJ//0Mlq0XO9lchDwmN1wkcVj56y77B53ru1h8zi/aQ2zx+Yl9R6Tbyxn9Ojb
	sorR4/MmOY8rR88wBXBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXm
	ptoqufgE6Lpl5gB9oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM6Onu
	YCyYuJ2p4txW3wbGfYcYuxg5OSQETCSWr33BDGGLSVy4t56ti5GLQ0hgOqPE9W+NzBDOX0aJ
	rw9esIFUsQloSayeexysW0RAQ+Lji9NgHcwCu1klJs86wgjR0cAoceLpfFaQKk6BYImTO8+B
	7RAWiJQ4vfcBO4jNIqAqsfzAWzCbV8BSYmrrWVYIW1Dix+R7LCA2M9C29TuPM0HY8hKb17yF
	ulVBYsfZ14wQcRGJfS/eQV1kJXF48Tu2CYxCs5CMmoVk1Cwko2YhaV/AyLKKUTS1ILmgOCk9
	10ivODG3uDQvXS85P3cTIzhBPZPewbiqweIQowAHoxIP74PMX4FCrIllxZW5hxglOJiVRHj/
	zAYK8aYkVlalFuXHF5XmpBYfYkwG+nQis5Rocj4weeaVxBsam5gZWRqZWRiZmJuTJqwkznuw
	1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6PDPZkELU7pv+HrJheFn5vBV1f9wqLMwzFcVXf71vk2
	ST6qsmkHj01YoinQ9eWi28azlpOkjA22NnXsuuf4WXUac9+nFBOpvKv7rKK6jnxt691+gofH
	+9fir7Xn31xNkD+7V/WRB+cp3Q09l16U8EyoPzBx4/a4iTVmDcWLGNhYDxrFejWFrVRiKc5I
	NNRiLipOBACVrvExlAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Rahul Sharma [mailto:r.sh.open@gmail.com]
> Sent: Friday, August 02, 2013 2:18 PM
> 
> Hi Cho,
> 
> On Fri, Jul 26, 2013 at 5:00 PM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> > When a device driver is registered, all constructs to handle System MMU
> > is prepared by bus notifier call.
> >
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >  drivers/iommu/exynos-iommu.c |  708 ++++++++++++++++++++++++++++++++---------
> >  1 files changed, 552 insertions(+), 156 deletions(-)
> >
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index f9853fe..c62c244 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -27,6 +27,9 @@
> >  #include <linux/memblock.h>
> >  #include <linux/export.h>
> >  #include <linux/of.h>
> > +#include <linux/of_platform.h>
> > +#include <linux/pm_domain.h>
> > +#include <linux/notifier.h>
> >
> >  #include <asm/cacheflush.h>
> >  #include <asm/pgtable.h>
> > @@ -80,7 +83,13 @@
> >  #define CTRL_BLOCK     0x7
> >  #define CTRL_DISABLE   0x0
> >
> > +#define CFG_LRU                0x1
> > +#define CFG_QOS(n)     ((n & 0xF) << 7)
> > +#define CFG_MASK       0x0150FFFF /* Selecting bit 0-15, 20, 22 and 24 */
> > +#define CFG_ACGEN      (1 << 24) /* System MMU 3.3 only */
> > +#define CFG_SYSSEL     (1 << 22) /* System MMU 3.2 only */
> >  #define CFG_FLPDCACHE  (1 << 20) /* System MMU 3.2+ only */
> > +#define CFG_SHAREABLE  (1 << 12) /* System MMU 3.x only */
> >
> >  #define REG_MMU_CTRL           0x000
> >  #define REG_MMU_CFG            0x004
> > @@ -154,6 +163,14 @@ static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
> >         "UNKNOWN FAULT"
> >  };
> >
> > +struct exynos_iommu_client {
> > +       struct list_head node;  /* entry of exynos_iommu_domain.clients */
> > +       struct device *dev;
> > +       spinlock_t lock;
> > +       int num_sysmmu;
> > +       struct device *sysmmu[0];
> 
> Shouldn't we keep limit on the max number of iommu's to a single client ? Even
> this way, you will hit array overrun with multiple iommu's.
> 

I don't think it is needed to fix the size of the array because
we know the size of the array in booting time.
sysmmu[0] is just a placeholder of array.

> > +};
> > +
> >  struct exynos_iommu_domain {
> >         struct list_head clients; /* list of sysmmu_drvdata.node */
> >         unsigned long *pgtable; /* lv1 page table, 16KB */
> > @@ -165,12 +182,14 @@ struct exynos_iommu_domain {
> >  struct sysmmu_drvdata {
> >         struct list_head node; /* entry of exynos_iommu_domain.clients */
> >         struct device *sysmmu;  /* System MMU's device descriptor */
> > -       struct device *dev;     /* Owner of system MMU */
> > +       struct device *master;  /* Owner of system MMU */
> >         int nsfrs;
> >         struct clk *clk;
> > +       struct clk *clk_master;
> >         int activations;
> >         rwlock_t lock;
> >         struct iommu_domain *domain;
> > +       bool runtime_active;
> >         unsigned long pgtable;
> >         void __iomem *sfrbases[0];
> >  };
> > @@ -245,7 +264,6 @@ static void __sysmmu_tlb_invalidate_entry(void __iomem *sfrbase,
> >  static void __sysmmu_set_ptbase(void __iomem *sfrbase,
> >                                        unsigned long pgd)
> >  {
> > -       __raw_writel(0x1, sfrbase + REG_MMU_CFG); /* 16KB LV1, LRU */
> >         __raw_writel(pgd, sfrbase + REG_PT_BASE_ADDR);
> >
> >         __sysmmu_tlb_invalidate(sfrbase);
> > @@ -273,6 +291,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
> >         if (!is_sysmmu_active(data))
> >                 goto finish;
> >
> > +       clk_enable(data->clk_master);
> >         for (i = 0; i < data->nsfrs; i++) {
> >                 if ((readl(data->sfrbases[i] + REG_MMU_VERSION) >> 28) == 3) {
> >                         if (!sysmmu_block(data->sfrbases[i]))
> > @@ -298,6 +317,7 @@ void exynos_sysmmu_set_prefbuf(struct device *dev,
> >                         sysmmu_unblock(data->sfrbases[i]);
> >                 }
> >         }
> > +       clk_disable(data->clk_master);
> >  finish:
> >         read_unlock_irqrestore(&data->lock, flags);
> >  }
> > @@ -331,12 +351,13 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
> >  {
> >         /* SYSMMU is in blocked when interrupt occurred. */
> >         struct sysmmu_drvdata *data = dev_id;
> > +       struct exynos_iommu_client *client = NULL;
> >         enum exynos_sysmmu_inttype itype;
> >         unsigned long addr = -1;
> > -
> >         int i, ret = -ENOSYS;
> >
> > -       read_lock(&data->lock);
> > +       if (data->master)
> > +               client = data->master->archdata.iommu;
> >
> >         WARN_ON(!is_sysmmu_active(data));
> >
> > @@ -348,6 +369,10 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
> >                         break;
> >         }
> >
> > +       if (client)
> > +               spin_lock(&client->lock);
> > +       read_lock(&data->lock);
> > +
> >         if (i == data->nsfrs) {
> >                 itype = SYSMMU_FAULT_UNKNOWN;
> >         } else {
> > @@ -361,7 +386,7 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
> >         }
> >
> >         if (data->domain)
> > -               ret = report_iommu_fault(data->domain, data->dev,
> > +               ret = report_iommu_fault(data->domain, data->master,
> >                                 addr, itype);
> >
> >         if (!ret && (itype != SYSMMU_FAULT_UNKNOWN))
> > @@ -378,177 +403,251 @@ static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
> >                 sysmmu_unblock(data->sfrbases[i]);
> >
> >         read_unlock(&data->lock);
> > +       if (client)
> > +               spin_unlock(&client->lock);
> >
> >         return IRQ_HANDLED;
> >  }
> >
> > -static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
> > +static void __sysmmu_disable_nocount(struct sysmmu_drvdata *data)
> >  {
> > -       unsigned long flags;
> > -       bool disabled = false;
> >         int i;
> >
> > -       write_lock_irqsave(&data->lock, flags);
> > +       clk_enable(data->clk_master);
> > +       for (i = 0; i < data->nsfrs; i++) {
> > +               __raw_writel(CTRL_DISABLE,
> > +                               data->sfrbases[i] + REG_MMU_CTRL);
> > +               __raw_writel(0, data->sfrbases[i] + REG_MMU_CFG);
> > +       }
> >
> > -       if (!set_sysmmu_inactive(data))
> > -               goto finish;
> > +       clk_disable(data->clk);
> > +       clk_disable(data->clk_master);
> > +}
> >
> > -       for (i = 0; i < data->nsfrs; i++)
> > -               __raw_writel(CTRL_DISABLE, data->sfrbases[i] + REG_MMU_CTRL);
> > +static bool __sysmmu_disable(struct sysmmu_drvdata *data)
> > +{
> > +       bool disabled;
> > +       unsigned long flags;
> >
> > -       if (data->clk)
> > -               clk_disable(data->clk);
> > +       write_lock_irqsave(&data->lock, flags);
> >
> > -       disabled = true;
> > -       data->pgtable = 0;
> > -       data->domain = NULL;
> > -finish:
> > -       write_unlock_irqrestore(&data->lock, flags);
> > +       disabled = set_sysmmu_inactive(data);
> > +
> > +       if (disabled) {
> > +               data->pgtable = 0;
> > +               data->domain = NULL;
> > +
> > +               if (data->runtime_active)
> > +                       __sysmmu_disable_nocount(data);
> >
> > -       if (disabled)
> >                 dev_dbg(data->sysmmu, "Disabled\n");
> > -       else
> > -               dev_dbg(data->sysmmu, "%d times left to be disabled\n",
> > +       } else  {
> > +               dev_dbg(data->sysmmu, "%d times left to disable\n",
> >                                         data->activations);
> > +       }
> > +
> > +       write_unlock_irqrestore(&data->lock, flags);
> >
> >         return disabled;
> >  }
> >
> > -/* __exynos_sysmmu_enable: Enables System MMU
> > - *
> > - * returns -error if an error occurred and System MMU is not enabled,
> > - * 0 if the System MMU has been just enabled and 1 if System MMU was already
> > - * enabled before.
> > - */
> > -static int __exynos_sysmmu_enable(struct sysmmu_drvdata *data,
> > +
> > +static void __sysmmu_init_config(struct sysmmu_drvdata *data, int idx)
> > +{
> > +       unsigned long cfg = CFG_LRU | CFG_QOS(15);
> > +       int maj, min = 0;
> > +
> > +       maj = __sysmmu_version(data, idx, &min);
> > +       if (maj == 3) {
> > +               if (min > 1) {
> > +                       cfg |= CFG_FLPDCACHE;
> > +                       cfg |= (min == 2) ? CFG_SYSSEL : CFG_ACGEN;
> > +               }
> > +       }
> > +
> > +       __raw_writel(cfg, data->sfrbases[idx] + REG_MMU_CFG);
> > +}
> > +
> > +static void __sysmmu_enable_nocount(struct sysmmu_drvdata *data)
> > +{
> > +       int i;
> > +
> > +       clk_enable(data->clk_master);
> > +       clk_enable(data->clk);
> > +
> > +       for (i = 0; i < data->nsfrs; i++) {
> > +               __raw_writel(CTRL_BLOCK, data->sfrbases[i] + REG_MMU_CTRL);
> > +
> > +               __sysmmu_init_config(data, i);
> > +
> > +               __sysmmu_set_ptbase(data->sfrbases[i], data->pgtable);
> > +
> > +               __raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
> > +       }
> > +       clk_disable(data->clk_master);
> > +}
> > +
> > +static int __sysmmu_enable(struct sysmmu_drvdata *data,
> >                         unsigned long pgtable, struct iommu_domain *domain)
> >  {
> > -       int i, ret = 0;
> > +       int ret = 0;
> >         unsigned long flags;
> >
> >         write_lock_irqsave(&data->lock, flags);
> > +       if (set_sysmmu_active(data)) {
> > +               data->pgtable = pgtable;
> > +               data->domain = domain;
> >
> > -       if (!set_sysmmu_active(data)) {
> > -               if (WARN_ON(pgtable != data->pgtable)) {
> > -                       ret = -EBUSY;
> > -                       set_sysmmu_inactive(data);
> > -               } else {
> > -                       ret = 1;
> > -               }
> > +               if (data->runtime_active)
> > +                       __sysmmu_enable_nocount(data);
> >
> > -               dev_dbg(data->sysmmu, "Already enabled\n");
> > -               goto finish;
> > +               dev_dbg(data->sysmmu, "Enabled\n");
> > +       } else {
> > +               ret = (pgtable == data->pgtable) ? 1 : -EBUSY;
> > +
> > +               dev_dbg(data->sysmmu, "already enabled\n");
> >         }
> >
> > -       if (data->clk)
> > -               clk_enable(data->clk);
> > +       if (WARN_ON(ret < 0))
> > +               set_sysmmu_inactive(data); /* decrement count */
> >
> > -       data->pgtable = pgtable;
> > +       write_unlock_irqrestore(&data->lock, flags);
> >
> > -       for (i = 0; i < data->nsfrs; i++) {
> > -               unsigned int min;
> > +       return ret;
> > +}
> >
> > -               __sysmmu_set_ptbase(data->sfrbases[i], pgtable);
> > +/* __exynos_sysmmu_enable: Enables System MMU
> > + *
> > + * returns -error if an error occurred and System MMU is not enabled,
> > + * 0 if the System MMU has been just enabled and 1 if System MMU was already
> > + * enabled before.
> > + */
> > +static int __exynos_sysmmu_enable(struct device *dev, unsigned long pgtable,
> > +                                 struct iommu_domain *domain)
> > +{
> > +       int ret = 0;
> > +       unsigned long flags;
> > +       struct exynos_iommu_client *client = dev->archdata.iommu;
> > +       int i;
> >
> > -               if ((__sysmmu_version(data, i, &min) == 3) && (min > 1)) {
> > -                       unsigned long cfg;
> > -                       cfg = __raw_readl(data->sfrbases[i] + REG_MMU_CFG);
> > -                       __raw_writel(cfg | CFG_FLPDCACHE,
> > -                                       data->sfrbases[i] + REG_MMU_CFG);
> > -               }
> > +       if (WARN_ON(!client))
> > +               return -ENODEV;
> >
> > -               __raw_writel(CTRL_ENABLE, data->sfrbases[i] + REG_MMU_CTRL);
> > -       }
> > +       spin_lock_irqsave(&client->lock, flags);
> >
> > -       data->domain = domain;
> > +       for (i = 0; i < client->num_sysmmu; i++) {
> > +               struct sysmmu_drvdata *data =
> > +                               dev_get_drvdata(client->sysmmu[i]);
> > +               ret = __sysmmu_enable(data, pgtable, domain);
> > +               if (ret < 0) {
> > +                       int j;
> > +                       for (j = 0; j < i; j++)
> > +                               __sysmmu_disable(data);
> > +                       break;
> > +               } else {
> > +                       data->master = dev;
> > +               }
> > +       }
> >
> > -       dev_dbg(data->sysmmu, "Enabled\n");
> > -finish:
> > -       write_unlock_irqrestore(&data->lock, flags);
> > +       spin_unlock_irqrestore(&client->lock, flags);
> >
> >         return ret;
> >  }
> >
> >  int exynos_sysmmu_enable(struct device *dev, unsigned long pgtable)
> >  {
> > -       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> >         int ret;
> >
> >         BUG_ON(!memblock_is_memory(pgtable));
> >
> > -       ret = pm_runtime_get_sync(data->sysmmu);
> > -       if (ret < 0) {
> > -               dev_dbg(data->sysmmu, "Failed to enable\n");
> > -               return ret;
> > -       }
> > -
> > -       ret = __exynos_sysmmu_enable(data, pgtable, NULL);
> > -       if (WARN_ON(ret < 0)) {
> > -               pm_runtime_put(data->sysmmu);
> > -               dev_err(data->sysmmu,
> > -                       "Already enabled with page table %#lx\n",
> > -                       data->pgtable);
> > -       } else {
> > -               data->dev = dev;
> > -       }
> > +       ret = __exynos_sysmmu_enable(dev, pgtable, NULL);
> >
> >         return ret;
> >  }
> >
> >  static bool exynos_sysmmu_disable(struct device *dev)
> >  {
> > -       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> > -       bool disabled;
> > +       unsigned long flags;
> > +       bool disabled = true;
> > +       struct exynos_iommu_client *client = dev->archdata.iommu;
> > +       int i;
> >
> > -       disabled = __exynos_sysmmu_disable(data);
> > -       pm_runtime_put(data->sysmmu);
> > +       if (WARN_ON(!client))
> > +               return true;
> > +
> > +       spin_lock_irqsave(&client->lock, flags);
> > +
> > +       /* Every call to __sysmmu_disable() must return same result */
> > +       for (i = 0; i < client->num_sysmmu; i++) {
> > +               struct sysmmu_drvdata *data =
> > +                               dev_get_drvdata(client->sysmmu[i]);
> > +               disabled = __sysmmu_disable(data);
> > +               if (disabled)
> > +                       data->master = NULL;
> > +       }
> > +
> > +       spin_unlock_irqrestore(&client->lock, flags);
> >
> >         return disabled;
> >  }
> >
> >  static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova)
> >  {
> > -       unsigned long flags;
> > -       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> > +       struct exynos_iommu_client *client = dev->archdata.iommu;
> > +       int i;
> >
> > -       read_lock_irqsave(&data->lock, flags);
> > +       for (i = 0; i < client->num_sysmmu; i++) {
> > +               unsigned long flags;
> > +               struct sysmmu_drvdata *data;
> >
> > -       if (is_sysmmu_active(data)) {
> > -               int i;
> > -               for (i = 0; i < data->nsfrs; i++) {
> > -                       if (sysmmu_block(data->sfrbases[i])) {
> > +               data = dev_get_drvdata(client->sysmmu[i]);
> > +
> > +               read_lock_irqsave(&data->lock, flags);
> > +               if (is_sysmmu_active(data) && data->runtime_active) {
> > +                       int i;
> > +                       clk_enable(data->clk_master);
> > +                       for (i = 0; i < data->nsfrs; i++)
> >                                 __sysmmu_tlb_invalidate_entry(
> >                                                 data->sfrbases[i], iova);
> > -                               sysmmu_unblock(data->sfrbases[i]);
> > -                       }
> > +                       clk_disable(data->clk_master);
> > +               } else {
> > +                       dev_dbg(dev,
> > +                               "disabled. Skipping TLB invalidation @ %#lx\n",
> > +                               iova);
> >                 }
> > -       } else {
> > -               dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
> > +               read_unlock_irqrestore(&data->lock, flags);
> >         }
> > -
> > -       read_unlock_irqrestore(&data->lock, flags);
> >  }
> >
> >  void exynos_sysmmu_tlb_invalidate(struct device *dev)
> >  {
> > -       unsigned long flags;
> > -       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> > -
> > -       read_lock_irqsave(&data->lock, flags);
> > +       struct exynos_iommu_client *client = dev->archdata.iommu;
> > +       int i;
> >
> > -       if (is_sysmmu_active(data)) {
> > -               int i;
> > -               for (i = 0; i < data->nsfrs; i++) {
> > -                       if (sysmmu_block(data->sfrbases[i])) {
> > -                               __sysmmu_tlb_invalidate(data->sfrbases[i]);
> > -                               sysmmu_unblock(data->sfrbases[i]);
> > +       for (i = 0; i < client->num_sysmmu; i++) {
> > +               unsigned long flags;
> > +               struct sysmmu_drvdata *data;
> > +
> > +               data = dev_get_drvdata(client->sysmmu[i]);
> > +
> > +               read_lock_irqsave(&data->lock, flags);
> > +               if (is_sysmmu_active(data) &&
> > +                               data->runtime_active) {
> > +                       int i;
> > +                       for (i = 0; i < data->nsfrs; i++) {
> > +                               clk_enable(data->clk_master);
> > +                               if (sysmmu_block(data->sfrbases[i])) {
> > +                                       __sysmmu_tlb_invalidate(
> > +                                                       data->sfrbases[i]);
> > +                                       sysmmu_unblock(data->sfrbases[i]);
> > +                               }
> > +                               clk_disable(data->clk_master);
> >                         }
> > +               } else {
> > +                       dev_dbg(dev, "disabled. Skipping TLB invalidation\n");
> >                 }
> > -       } else {
> > -               dev_dbg(data->sysmmu, "Disabled. Skipping invalidating TLB.\n");
> > +               read_unlock_irqrestore(&data->lock, flags);
> >         }
> > -
> > -       read_unlock_irqrestore(&data->lock, flags);
> >  }
> >
> >  static int __init exynos_sysmmu_probe(struct platform_device *pdev)
> > @@ -610,12 +709,32 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
> >         pm_runtime_enable(dev);
> >
> >         data->sysmmu = dev;
> > +
> >         data->clk = devm_clk_get(dev, "sysmmu");
> >         if (IS_ERR(data->clk)) {
> >                 dev_info(dev, "No gate clock found!\n");
> >                 data->clk = NULL;
> >         }
> >
> > +       ret = clk_prepare(data->clk);
> > +       if (ret) {
> > +               dev_err(dev, "Failed to prepare clk\n");
> > +               return ret;
> > +       }
> > +
> > +       data->clk_master = devm_clk_get(dev, "master");
> > +       if (IS_ERR(data->clk_master))
> > +               data->clk_master = NULL;
> > +
> > +       ret = clk_prepare(data->clk_master);
> > +       if (ret) {
> > +               clk_unprepare(data->clk);
> > +               dev_err(dev, "Failed to prepare master's clk\n");
> > +               return ret;
> > +       }
> > +
> > +       data->runtime_active = !pm_runtime_enabled(dev);
> > +
> >         rwlock_init(&data->lock);
> >         INIT_LIST_HEAD(&data->node);
> >
> > @@ -625,6 +744,34 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
> >         return ret;
> >  }
> >
> > +#ifdef CONFIG_PM_SLEEP
> > +static int sysmmu_suspend(struct device *dev)
> > +{
> > +       struct sysmmu_drvdata *data = dev_get_drvdata(dev);
> > +       unsigned long flags;
> > +       read_lock_irqsave(&data->lock, flags);
> > +       if (is_sysmmu_active(data) &&
> > +               (!pm_runtime_enabled(dev) || data->runtime_active))
> > +               __sysmmu_disable_nocount(data);
> > +       read_unlock_irqrestore(&data->lock, flags);
> > +       return 0;
> > +}
> > +
> > +static int sysmmu_resume(struct device *dev)
> > +{
> > +       struct sysmmu_drvdata *data = dev_get_drvdata(dev);
> > +       unsigned long flags;
> > +       read_lock_irqsave(&data->lock, flags);
> > +       if (is_sysmmu_active(data) &&
> > +               (!pm_runtime_enabled(dev) || data->runtime_active))
> > +               __sysmmu_enable_nocount(data);
> > +       read_unlock_irqrestore(&data->lock, flags);
> > +       return 0;
> > +}
> > +#endif
> > +
> > +static SIMPLE_DEV_PM_OPS(sysmmu_pm_ops, sysmmu_suspend, sysmmu_resume);
> > +
> >  #ifdef CONFIG_OF
> >  static struct of_device_id sysmmu_of_match[] __initconst = {
> >         { .compatible   = "samsung,exynos4210-sysmmu", },
> > @@ -637,6 +784,7 @@ static struct platform_driver exynos_sysmmu_driver __refdata = {
> >         .driver = {
> >                 .owner          = THIS_MODULE,
> >                 .name           = "exynos-sysmmu",
> > +               .pm             = &sysmmu_pm_ops,
> >                 .of_match_table = of_match_ptr(sysmmu_of_match),
> >         }
> >  };
> > @@ -689,7 +837,7 @@ err_pgtable:
> >  static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
> >  {
> >         struct exynos_iommu_domain *priv = domain->priv;
> > -       struct sysmmu_drvdata *data;
> > +       struct exynos_iommu_client *client;
> >         unsigned long flags;
> >         int i;
> >
> > @@ -697,11 +845,14 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
> >
> >         spin_lock_irqsave(&priv->lock, flags);
> >
> > -       list_for_each_entry(data, &priv->clients, node) {
> > -               while (!exynos_sysmmu_disable(data->dev))
> > +       list_for_each_entry(client, &priv->clients, node) {
> > +               while (!exynos_sysmmu_disable(client->dev))
> >                         ; /* until System MMU is actually disabled */
> >         }
> >
> > +       while (!list_empty(&priv->clients))
> > +               list_del_init(priv->clients.next);
> > +
> >         spin_unlock_irqrestore(&priv->lock, flags);
> >
> >         for (i = 0; i < NUM_LV1ENTRIES; i++)
> > @@ -718,41 +869,26 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
> >  static int exynos_iommu_attach_device(struct iommu_domain *domain,
> >                                    struct device *dev)
> >  {
> > -       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> > +       struct exynos_iommu_client *client = dev->archdata.iommu;
> >         struct exynos_iommu_domain *priv = domain->priv;
> >         unsigned long flags;
> >         int ret;
> >
> > -       ret = pm_runtime_get_sync(data->sysmmu);
> > -       if (ret < 0)
> > -               return ret;
> > -
> > -       ret = 0;
> > -
> >         spin_lock_irqsave(&priv->lock, flags);
> >
> > -       ret = __exynos_sysmmu_enable(data, __pa(priv->pgtable), domain);
> > -
> > -       if (ret == 0) {
> > -               /* 'data->node' must not be appeared in priv->clients */
> > -               BUG_ON(!list_empty(&data->node));
> > -               data->dev = dev;
> > -               list_add_tail(&data->node, &priv->clients);
> > -       }
> > +       ret = __exynos_sysmmu_enable(dev, __pa(priv->pgtable), domain);
> > +       if (ret == 0)
> > +               list_add_tail(&client->node, &priv->clients);
> >
> >         spin_unlock_irqrestore(&priv->lock, flags);
> >
> > -       if (ret < 0) {
> > +       if (ret < 0)
> >                 dev_err(dev, "%s: Failed to attach IOMMU with pgtable %#lx\n",
> >                                 __func__, __pa(priv->pgtable));
> > -               pm_runtime_put(data->sysmmu);
> > -       } else if (ret > 0) {
> > -               dev_dbg(dev, "%s: IOMMU with pgtable 0x%lx already attached\n",
> > -                                       __func__, __pa(priv->pgtable));
> > -       } else {
> > -               dev_dbg(dev, "%s: Attached new IOMMU with pgtable 0x%lx\n",
> > -                                       __func__, __pa(priv->pgtable));
> > -       }
> > +       else
> > +               dev_dbg(dev, "%s: Attached IOMMU with pgtable 0x%lx%s\n",
> > +                                       __func__, __pa(priv->pgtable),
> > +                                       (ret == 0) ? "" : ", again");
> >
> >         return ret;
> >  }
> > @@ -760,39 +896,27 @@ static int exynos_iommu_attach_device(struct iommu_domain *domain,
> >  static void exynos_iommu_detach_device(struct iommu_domain *domain,
> >                                     struct device *dev)
> >  {
> > -       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
> > +       struct exynos_iommu_client *client = NULL;
> >         struct exynos_iommu_domain *priv = domain->priv;
> > -       struct list_head *pos;
> >         unsigned long flags;
> > -       bool found = false;
> >
> >         spin_lock_irqsave(&priv->lock, flags);
> >
> > -       list_for_each(pos, &priv->clients) {
> > -               if (list_entry(pos, struct sysmmu_drvdata, node) == data) {
> > -                       found = true;
> > +       list_for_each_entry(client, &priv->clients, node) {
> > +               if (client == dev->archdata.iommu) {
> > +                       if (exynos_sysmmu_disable(dev))
> > +                               list_del_init(&client->node);
> >                         break;
> >                 }
> >         }
> >
> > -       if (!found)
> > -               goto finish;
> > +       spin_unlock_irqrestore(&priv->lock, flags);
> >
> > -       if (__exynos_sysmmu_disable(data)) {
> > +       if (client == dev->archdata.iommu)
> >                 dev_dbg(dev, "%s: Detached IOMMU with pgtable %#lx\n",
> >                                         __func__, __pa(priv->pgtable));
> > -               list_del_init(&data->node);
> > -
> > -       } else {
> > -               dev_dbg(dev, "%s: Detaching IOMMU with pgtable %#lx delayed",
> > -                                       __func__, __pa(priv->pgtable));
> > -       }
> > -
> > -finish:
> > -       spin_unlock_irqrestore(&priv->lock, flags);
> > -
> > -       if (found)
> > -               pm_runtime_put(data->sysmmu);
> > +       else
> > +               dev_dbg(dev, "%s: No IOMMU is attached\n", __func__);
> >  }
> >
> >  static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
> > @@ -914,7 +1038,7 @@ static size_t exynos_iommu_unmap(struct iommu_domain *domain,
> >                                                unsigned long iova, size_t size)
> >  {
> >         struct exynos_iommu_domain *priv = domain->priv;
> > -       struct sysmmu_drvdata *data;
> > +       struct exynos_iommu_client *client;
> >         unsigned long flags;
> >         unsigned long *ent;
> >         size_t err_pgsize;
> > @@ -975,8 +1099,8 @@ done:
> >         spin_unlock_irqrestore(&priv->pgtablelock, flags);
> >
> >         spin_lock_irqsave(&priv->lock, flags);
> > -       list_for_each_entry(data, &priv->clients, node)
> > -               sysmmu_tlb_invalidate_entry(data->dev, iova);
> > +       list_for_each_entry(client, &priv->clients, node)
> > +               sysmmu_tlb_invalidate_entry(client->dev, iova);
> >         spin_unlock_irqrestore(&priv->lock, flags);
> >
> >         return size;
> > @@ -1055,3 +1179,275 @@ static int __init exynos_iommu_init(void)
> >         return ret;
> >  }
> >  subsys_initcall(exynos_iommu_init);
> > +
> > +#ifdef CONFIG_PM_SLEEP
> > +static int sysmmu_pm_genpd_suspend(struct device *dev)
> > +{
> > +       struct exynos_iommu_client *client = dev->archdata.iommu;
> > +       int ret = 0;
> > +       int i;
> > +
> > +       for (i = 0; i < client->num_sysmmu; i++) {
> > +               ret = pm_generic_suspend(client->sysmmu[i]);
> > +               if (ret)
> > +                       break;
> > +       }
> > +
> > +       if (!ret)
> > +               ret = pm_generic_suspend(dev);
> > +
> > +       if (ret) {
> > +               int j;
> > +
> > +               for (j = 0; j < i; j++)
> > +                       pm_generic_resume(client->sysmmu[j]);
> > +       }
> > +
> > +       return ret;
> > +}
> > +
> > +static int sysmmu_pm_genpd_resume(struct device *dev)
> > +{
> > +       struct exynos_iommu_client *client = dev->archdata.iommu;
> > +       int ret = 0;
> > +       int i;
> > +
> > +       for (i = 0; i < client->num_sysmmu; i++) {
> > +               ret = pm_generic_resume(client->sysmmu[i]);
> > +               if (ret)
> > +                       break;
> > +       }
> > +
> > +       if (!ret)
> > +               ret = pm_generic_resume(dev);
> > +
> > +       if (ret) {
> > +               int j;
> > +
> > +               for (j = 0; j < i; j++)
> > +                       pm_generic_suspend(client->sysmmu[j]);
> > +       }
> > +
> > +       return ret;
> > +}
> > +#endif
> > +
> > +#ifdef CONFIG_PM_RUNTIME
> > +static void sysmmu_restore_state(struct device *sysmmu)
> > +{
> > +       struct sysmmu_drvdata *data = dev_get_drvdata(sysmmu);
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&data->lock, flags);
> > +       data->runtime_active = true;
> > +       if (is_sysmmu_active(data))
> > +               __sysmmu_enable_nocount(data);
> > +       spin_unlock_irqrestore(&data->lock, flags);
> > +}
> > +
> > +static void sysmmu_save_state(struct device *sysmmu)
> > +{
> > +       struct sysmmu_drvdata *data = dev_get_drvdata(sysmmu);
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&data->lock, flags);
> > +       if (is_sysmmu_active(data))
> > +               __sysmmu_disable_nocount(data);
> > +       data->runtime_active = false;
> > +       spin_unlock_irqrestore(&data->lock, flags);
> > +}
> > +
> > +static int sysmmu_pm_genpd_save_state(struct device *dev)
> > +{
> > +       struct exynos_iommu_client *client = dev->archdata.iommu;
> > +       int (*cb)(struct device *__dev);
> > +       int i;
> > +
> > +       if (dev->type && dev->type->pm)
> > +               cb = dev->type->pm->runtime_suspend;
> > +       else if (dev->class && dev->class->pm)
> > +               cb = dev->class->pm->runtime_suspend;
> > +       else if (dev->bus && dev->bus->pm)
> > +               cb = dev->bus->pm->runtime_suspend;
> > +       else
> > +               cb = NULL;
> > +
> > +       if (!cb && dev->driver && dev->driver->pm)
> > +               cb = dev->driver->pm->runtime_suspend;
> > +
> > +       if (cb) {
> > +               int ret;
> > +
> > +               ret = cb(dev);
> > +               if (ret)
> > +                       return ret;
> > +       }
> > +
> > +       for (i = 0; i < client->num_sysmmu; i++)
> > +               sysmmu_save_state(client->sysmmu[i]);
> > +
> > +       return 0;
> > +}
> > +
> > +static int sysmmu_pm_genpd_restore_state(struct device *dev)
> > +{
> > +       struct exynos_iommu_client *client = dev->archdata.iommu;
> > +       int (*cb)(struct device *__dev);
> > +       int i;
> > +
> > +       if (dev->type && dev->type->pm)
> > +               cb = dev->type->pm->runtime_resume;
> > +       else if (dev->class && dev->class->pm)
> > +               cb = dev->class->pm->runtime_resume;
> > +       else if (dev->bus && dev->bus->pm)
> > +               cb = dev->bus->pm->runtime_resume;
> > +       else
> > +               cb = NULL;
> > +
> > +       if (!cb && dev->driver && dev->driver->pm)
> > +               cb = dev->driver->pm->runtime_resume;
> > +
> > +       for (i = 0; i < client->num_sysmmu; i++)
> > +               sysmmu_restore_state(client->sysmmu[i]);
> > +
> > +       if (cb) {
> > +               int ret;
> > +               ret = cb(dev);
> > +               if (ret) {
> > +                       for (i = 0; i < client->num_sysmmu; i++)
> > +                               sysmmu_save_state(client->sysmmu[i]);
> > +                       return ret;
> > +               }
> > +       }
> > +
> > +       return 0;
> > +}
> > +#endif
> > +
> > +#ifdef CONFIG_PM_GENERIC_DOMAINS
> > +struct gpd_dev_ops sysmmu_devpm_ops = {
> > +#ifdef CONFIG_PM_RUNTIME
> > +       .save_state = &sysmmu_pm_genpd_save_state,
> > +       .restore_state = &sysmmu_pm_genpd_restore_state,
> > +#endif
> > +#ifdef CONFIG_PM_SLEEP
> > +       .suspend = &sysmmu_pm_genpd_suspend,
> > +       .resume = &sysmmu_pm_genpd_resume,
> > +#endif
> > +};
> > +#endif /* CONFIG_PM_GENERIC_DOMAINS */
> > +
> > +static int sysmmu_hook_driver_register(struct notifier_block *nb,
> > +                                       unsigned long val,
> > +                                       void *p)
> > +{
> > +       struct device *dev = p;
> > +
> > +       switch (val) {
> > +       case BUS_NOTIFY_BIND_DRIVER:
> > +       {
> > +               int i = 0;
> > +               int size = 0;
> 
> You can drop the initialization here. They are getting initialised
> before actual use.

Yes, it is basically right.
I just want to be convinced that the output argument to of_get_property()
is not referenced before initialization even though of_get_property()
does not reference to the argument, actually.

> 
> > +               const __be32 *phandle;
> > +               struct exynos_iommu_client *client;
> > +
> > +               phandle = of_get_property(dev->of_node, "iommu", &size);
> > +               if (!phandle)
> > +                       break;
> > +
> > +               size = size / sizeof(*phandle); /* number of elements */
> > +
> > +               client = devm_kzalloc(dev, sizeof(*client) * size, GFP_KERNEL);
> 
> You do not need to allocate memory of size "sizeof(*client) * size" ? It should
> always be sizeof(*client).

Oh. It is my fault.
It must be 'sizeof(*client) + size * sizeof(client->sysmmu[0])'.
It will be fixed.

> 
> > +               if (!client) {
> > +                       dev_err(dev, "No Memory for exynos_iommu_client\n");
> > +                       return -ENOMEM;
> > +               }
> > +
> > +               client->num_sysmmu = size;
> > +               client->dev = dev;
> > +               INIT_LIST_HEAD(&client->node);
> > +               spin_lock_init(&client->lock);
> > +
> > +               for (i = 0; i < size; i++) {
> > +                       struct device_node *np;
> > +                       struct platform_device *sysmmu;
> > +
> > +                       /* this always success: see above of_find_property() */
> > +                       np = of_parse_phandle(dev->of_node, "iommu", i);
> > +
> > +                       sysmmu = of_find_device_by_node(np);
> > +                       if (!sysmmu) {
> > +                               dev_err(dev,
> > +                                       "sysmmu node '%s' is not found\n",
> > +                                       np->name);
> > +                               break;
> > +                       }
> > +
> > +                       client->sysmmu[i] = &sysmmu->dev;
> 
> Your array has space for single 'device *'. You should allocate memory to
> client->sysmmu before accessing indexes above 0.

As I commented above, enough size is allocated.

> 
> As if now, It is not corrupting other's memory since you have allocated a
> much bigger chunk for your client pointer which is wrong IMO.

That is my fault :)
> 
> regards,
> Rahul Sharma

Thank you.

Cho KyongHo.

> 
> > +               }
> > +
> > +               if (i < size) {
> > +                       while (--i >= 0)
> > +                               of_node_put(client->sysmmu[i]->of_node);
> > +                       devm_kfree(dev, client);
> > +                       return -ENODEV;
> > +               }
> > +
> > +               i = pm_genpd_add_callbacks(dev, &sysmmu_devpm_ops, NULL);
> > +               if (i && (i != -ENOSYS)) {
> > +                       dev_err(dev,
> > +                               "Failed to register 'dev_pm_ops' for iommu\n");
> > +                       devm_kfree(dev, client);
> > +                       return i;
> > +               }
> > +
> > +               dev->archdata.iommu = client;
> > +               break;
> > +       }
> > +       case BUS_NOTIFY_BOUND_DRIVER:
> > +       {
> > +               struct exynos_iommu_client *client = dev->archdata.iommu;
> > +               if (dev->archdata.iommu &&
> > +                               (!pm_runtime_enabled(dev) ||
> > +                                        IS_ERR(dev_to_genpd(dev)))) {
> > +                       int i;
> > +                       for (i = 0; i < client->num_sysmmu; i++) {
> > +                               struct sysmmu_drvdata *data;
> > +                               pm_runtime_disable(client->sysmmu[i]);
> > +                               data = dev_get_drvdata(client->sysmmu[i]);
> > +                               if (!data)
> > +                                       continue;
> > +                               data->runtime_active =
> > +                                       !pm_runtime_enabled(data->sysmmu);
> > +                               if (data->runtime_active &&
> > +                                               is_sysmmu_active(data))
> > +                                       __sysmmu_enable_nocount(data);
> > +                       }
> > +               }
> > +               break;
> > +       }
> > +       case BUS_NOTIFY_UNBOUND_DRIVER:
> > +       {
> > +               if (dev->archdata.iommu) {
> > +                       __pm_genpd_remove_callbacks(dev, false);
> > +
> > +                       devm_kfree(dev, dev->archdata.iommu);
> > +
> > +                       dev->archdata.iommu = NULL;
> > +               }
> > +               break;
> > +       }
> > +       } /* switch (val) */
> > +
> > +       return 0;
> > +}
> > +
> > +static struct notifier_block sysmmu_notifier = {
> > +       .notifier_call = &sysmmu_hook_driver_register,
> > +};
> > +
> > +static int __init exynos_iommu_prepare(void)
> > +{
> > +       return bus_register_notifier(&platform_bus_type, &sysmmu_notifier);
> > +}
> > +arch_initcall(exynos_iommu_prepare);
> > --
> > 1.7.2.5
> >
> >
> > _______________________________________________
> > iommu mailing list
> > iommu@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/iommu


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaCRLX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 07:23:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53619 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbaCRLXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 07:23:24 -0400
X-AuditID: cbfee68e-b7f566d000002344-57-53282ca96fc5
Date: Tue, 18 Mar 2014 20:23:20 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kevin Hilman <khilman@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v11 19/27] iommu/exynos: add support for power management
 subsystems.
Message-id: <20140318202320.a3101304bbc51cc9f169cdaa@samsung.com>
In-reply-to: <53232959.7020306@samsung.com>
References: <20140314141028.4b0b62d895905988ab5dda88@samsung.com>
 <53232959.7020306@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t8zY92VOhrBBlcW6lrcuXuO1WLjjPWs
	FvOPAFmvjvxgsliw39qic/YGdoveBVfZLL4eXsFosenxNVaLy7vmsFnMOL+PyeLN7xfsFmuP
	3GW3uLBiI7vFlEWHWS3OnL7EanH4TTurxck/vYwW62e8ZrE4vjbcYuatNSwOoh5PDs5j8lgz
	bw2jx+yGiywe/w73M3ncubaHzWPzknqPyTeWM3psudrO4tG3ZRWjx+dNch5Xjp5hCuCO4rJJ
	Sc3JLEst0rdL4MpY0b+BveB5VsX5a7+ZGhi3BXcxcnJICJhIXJh2jBnCFpO4cG89WxcjF4eQ
	wDJGiU0zFrPCFG3u2swGYgsJTGeU2Li9HMKezCTxY38tiM0ioCpx+mYj2CA2AS2J1XOPM4LY
	IgIqEpdPTWcEGcos0M8ucXHXLnaQhLBAtMTbm2vBFvAKOEpMvXMRrIFTQFvi/rRmoEEcQAuS
	JFbfdIO4wULiQlMHO0S5oMSPyfdYQGxmoF2btzWxQtjyEpvXvGUG2SUhcIdD4u7blywQxwlI
	fJt8iAVkpoSArMSmA1APS0ocXHGDZQKj2CwkY2chGTsLydgFjMyrGEVTC5ILipPSi4z0ihNz
	i0vz0vWS83M3MULSRt8OxpsHrA8xJgOtnMgsJZqcD0w7eSXxhsZmRhamJqbGRuaWZqQJK4nz
	LnqYFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB0c/P/3Tclw1bUt5/mb1hq1viqSuXV9gv
	DrvFwPA2uO270MNF868cvrGLzWCSklkmr1qCBbu61KH36VO/X9E++qrg0LLHit+a3oSZvNoX
	M/X5jUJjd5nrDfvTerlMxVJ8Vqjp/ik0mRvd98hJ+mGWedCRpIBPEUl7bVltdJ5PUCo8nB54
	YbKmoxJLcUaioRZzUXEiAPWoKzsxAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsVy+t9jQd2VOhrBBgdmqVrcuXuO1WLjjPWs
	FvOPAFmvjvxgsliw39qic/YGdoveBVfZLL4eXsFosenxNVaLy7vmsFnMOL+PyeLN7xfsFmuP
	3GW3uLBiI7vFlEWHWS3OnL7EanH4TTurxck/vYwW62e8ZrE4vjbcYuatNSwOoh5PDs5j8lgz
	bw2jx+yGiywe/w73M3ncubaHzWPzknqPyTeWM3psudrO4tG3ZRWjx+dNch5Xjp5hCuCOamC0
	yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAF6VEmhLDGn
	FCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsaJ/A3vB86yK89d+MzUwbgvuYuTk
	kBAwkdjctZkNwhaTuHBvPZgtJDCdUWLj9nIIezKTxI/9tSA2i4CqxOmbjcwgNpuAlsTquccZ
	QWwRARWJy6emA9lcHMwC/ewSF3ftYgdJCAtES7y9uZYVxOYVcJSYeuciWAOngLbE/WnNQIM4
	gBYkSay+6QZxg4XEhaYOdohyQYkfk++xgNjMQLs2b2tihbDlJTavecs8gVFgFpKyWUjKZiEp
	W8DIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOCk9k97BuKrB4hCjAAejEg/vCzb1YCHW
	xLLiytxDjBIczEoivEvVNIKFeFMSK6tSi/Lji0pzUosPMSYDQ2Mis5Rocj4wYeaVxBsam5gZ
	WRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+NSnWwO2QtndvTMMZ3wNFv6
	cvfLrZdf70rpdTk8k4VXnZlj38E9S56HyV/rftfRqirEkbZpw/Kjhq+aj0laP7u36VjLxnfL
	1bxmCWz9ckzVycRlK99JO/urDqfq599fc8dFsMyJfVaVhdPMBfnsYndk/NgqHildMPS4zL45
	NjUo+vLPOZtONQkqsRRnJBpqMRcVJwIA+bvE044DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2014 17:07:53 +0100, Tomasz Figa wrote:
> Hi KyongHo,
> 
> On 14.03.2014 06:10, Cho KyongHo wrote:
> > This adds support for Suspend to RAM and Runtime Power Management.
> >
> > Since System MMU is located in the same local power domain of its
> > master H/W, System MMU must be initialized before it is working if
> > its power domain was ever turned off. TLB invalidation according to
> > unmapping on page tables must also be performed while power domain is
> > turned on.
> >
> > This patch ensures that resume and runtime_resume(restore_state)
> > functions in this driver is called before the calls to resume and
> > runtime_resume callback functions in the drivers of master H/Ws.
> > Likewise, suspend and runtime_suspend(save_state) functions in this
> > driver is called after the calls to suspend and runtime_suspend in the
> > drivers of master H/Ws.
> >
> > In order to get benefit of this support, the master H/W and its System
> > MMU must resides in the same power domain in terms of Linux kernel. If
> > a master H/W does not use generic I/O power domain, its driver must
> > call iommu_attach_device() after its local power domain is turned on,
> > iommu_detach_device before turned off.
> >
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> > ---
> >   drivers/iommu/exynos-iommu.c |  220 ++++++++++++++++++++++++++++++++++++++----
> >   1 file changed, 201 insertions(+), 19 deletions(-)
> >
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index 9037da0..84ba29a 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -28,6 +28,7 @@
> >   #include <linux/export.h>
> >   #include <linux/of.h>
> >   #include <linux/of_platform.h>
> > +#include <linux/pm_domain.h>
> >   #include <linux/notifier.h>
> >
> >   #include <asm/cacheflush.h>
> > @@ -203,6 +204,7 @@ struct sysmmu_drvdata {
> >   	int activations;
> >   	rwlock_t lock;
> >   	struct iommu_domain *domain;
> > +	bool runtime_active;
> >   	unsigned long pgtable;
> >   };
> >
> > @@ -388,7 +390,8 @@ static bool __sysmmu_disable(struct sysmmu_drvdata *data)
> >   		data->pgtable = 0;
> >   		data->domain = NULL;
> >
> > -		__sysmmu_disable_nocount(data);
> > +		if (data->runtime_active)
> > +			__sysmmu_disable_nocount(data);
> >
> >   		dev_dbg(data->sysmmu, "Disabled\n");
> >   	} else  {
> > @@ -449,7 +452,8 @@ static int __sysmmu_enable(struct sysmmu_drvdata *data,
> >   		data->pgtable = pgtable;
> >   		data->domain = domain;
> >
> > -		__sysmmu_enable_nocount(data);
> > +		if (data->runtime_active)
> > +			__sysmmu_enable_nocount(data);
> >
> >   		dev_dbg(data->sysmmu, "Enabled\n");
> >   	} else {
> > @@ -534,13 +538,11 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
> >   	data = dev_get_drvdata(owner->sysmmu);
> >
> >   	read_lock_irqsave(&data->lock, flags);
> > -	if (is_sysmmu_active(data)) {
> > -		unsigned int maj;
> > +	if (is_sysmmu_active(data) && data->runtime_active) {
> >   		unsigned int num_inv = 1;
> >
> >   		__master_clk_enable(data);
> >
> > -		maj = __raw_readl(data->sfrbase + REG_MMU_VERSION);
> >   		/*
> >   		 * L2TLB invalidation required
> >   		 * 4KB page: 1 invalidation
> > @@ -551,7 +553,7 @@ static void sysmmu_tlb_invalidate_entry(struct device *dev, unsigned long iova,
> >   		 * 1MB page can be cached in one of all sets.
> >   		 * 64KB page can be one of 16 consecutive sets.
> >   		 */
> > -		if ((maj >> 28) == 2) /* major version number */
> > +		if (__sysmmu_version(data, NULL) == 2) /* major version number */
> >   			num_inv = min_t(unsigned int, size / PAGE_SIZE, 64);
> >
> >   		if (sysmmu_block(data->sfrbase)) {
> > @@ -576,7 +578,7 @@ void exynos_sysmmu_tlb_invalidate(struct device *dev)
> >   	data = dev_get_drvdata(owner->sysmmu);
> >
> >   	read_lock_irqsave(&data->lock, flags);
> > -	if (is_sysmmu_active(data)) {
> > +	if (is_sysmmu_active(data) && data->runtime_active) {
> >   		__master_clk_enable(data);
> >   		if (sysmmu_block(data->sfrbase)) {
> >   			__sysmmu_tlb_invalidate(data->sfrbase);
> > @@ -677,11 +679,40 @@ static int __init exynos_sysmmu_probe(struct platform_device *pdev)
> >   	platform_set_drvdata(pdev, data);
> >
> >   	pm_runtime_enable(dev);
> > +	data->runtime_active = !pm_runtime_enabled(dev);
> 
> Hmm, this seems to be a bit misleading. The field is named 
> runtime_active, but the assignment makes it true if PM runtime is _not_ 
> enabled (i.e. inactive). Is this correct?
> 

I agree that it may lead misunderstood.
data->runtime_active actually indicates if electric power is asserted
to the System MMU. pm_runtime_enable() call must enable runtime pm
for the given device. If runtime pm is not enabled although pm_runtime_enable()
is called, CONFIG_PM_RUNTIME is not configured.

Actually, it is replacible with 
if (IS_ENABLED(CONFIG_PM_RUNTIME)) 
    data->runtime_active = true;

> >
> >   	dev_dbg(dev, "Probed and initialized\n");
> >   	return 0;
> >   }
> >
> > +#ifdef CONFIG_PM_SLEEP
> > +static int sysmmu_suspend(struct device *dev)
> > +{
> > +	struct sysmmu_drvdata *data = dev_get_drvdata(dev);
> > +	unsigned long flags;
> > +	read_lock_irqsave(&data->lock, flags);
> > +	if (is_sysmmu_active(data) &&
> > +		(!pm_runtime_enabled(dev) || data->runtime_active))
> > +		__sysmmu_disable_nocount(data);
> > +	read_unlock_irqrestore(&data->lock, flags);
> > +	return 0;
> > +}
> > +
> > +static int sysmmu_resume(struct device *dev)
> > +{
> > +	struct sysmmu_drvdata *data = dev_get_drvdata(dev);
> > +	unsigned long flags;
> > +	read_lock_irqsave(&data->lock, flags);
> > +	if (is_sysmmu_active(data) &&
> > +		(!pm_runtime_enabled(dev) || data->runtime_active))
> > +		__sysmmu_enable_nocount(data);
> > +	read_unlock_irqrestore(&data->lock, flags);
> > +	return 0;
> > +}
> > +#endif
> > +
> > +static SIMPLE_DEV_PM_OPS(sysmmu_pm_ops, sysmmu_suspend, sysmmu_resume);
> > +
> >   #ifdef CONFIG_OF
> >   static struct of_device_id sysmmu_of_match[] __initconst = {
> >   	{ .compatible	= "samsung,sysmmu-v1", },
> > @@ -698,6 +729,7 @@ static struct platform_driver exynos_sysmmu_driver __refdata = {
> >   	.driver	= {
> >   		.owner		= THIS_MODULE,
> >   		.name		= "exynos-sysmmu",
> > +		.pm		= &sysmmu_pm_ops,
> >   		.of_match_table	= of_match_ptr(sysmmu_of_match),
> >   	}
> >   };
> > @@ -1111,24 +1143,152 @@ err_reg_driver:
> >   }
> >   subsys_initcall(exynos_iommu_init);
> >
> > +#ifdef CONFIG_PM_SLEEP
> > +static int sysmmu_pm_genpd_suspend(struct device *dev)
> > +{
> > +	struct exynos_iommu_owner *owner = dev->archdata.iommu;
> > +	int ret;
> > +
> > +	ret = pm_generic_suspend(dev);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return pm_generic_suspend(owner->sysmmu);
> > +}
> > +
> > +static int sysmmu_pm_genpd_resume(struct device *dev)
> > +{
> > +	struct exynos_iommu_owner *owner = dev->archdata.iommu;
> > +	int ret;
> > +
> > +	ret = pm_generic_resume(owner->sysmmu);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return pm_generic_resume(dev);
> > +}
> > +#endif
> > +
> > +#ifdef CONFIG_PM_RUNTIME
> > +static void sysmmu_restore_state(struct device *sysmmu)
> > +{
> > +	struct sysmmu_drvdata *data = dev_get_drvdata(sysmmu);
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&data->lock, flags);
> > +	data->runtime_active = true;
> > +	if (is_sysmmu_active(data))
> > +		__sysmmu_enable_nocount(data);
> > +	spin_unlock_irqrestore(&data->lock, flags);
> > +}
> > +
> > +static void sysmmu_save_state(struct device *sysmmu)
> > +{
> > +	struct sysmmu_drvdata *data = dev_get_drvdata(sysmmu);
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&data->lock, flags);
> > +	if (is_sysmmu_active(data))
> > +		__sysmmu_disable_nocount(data);
> > +	data->runtime_active = false;
> > +	spin_unlock_irqrestore(&data->lock, flags);
> > +}
> > +
> > +static int sysmmu_pm_genpd_save_state(struct device *dev)
> > +{
> > +	struct exynos_iommu_client *client = dev->archdata.iommu;
> > +	int (*cb)(struct device *__dev);
> > +	int ret = 0;
> > +
> > +	if (dev->type && dev->type->pm)
> > +		cb = dev->type->pm->runtime_suspend;
> > +	else if (dev->class && dev->class->pm)
> > +		cb = dev->class->pm->runtime_suspend;
> > +	else if (dev->bus && dev->bus->pm)
> > +		cb = dev->bus->pm->runtime_suspend;
> > +	else
> > +		cb = NULL;
> > +
> > +	if (!cb && dev->driver && dev->driver->pm)
> > +		cb = dev->driver->pm->runtime_suspend;
> > +
> > +	if (cb)
> > +		ret = cb(dev);
> > +
> > +	if (ret == 0)
> > +		sysmmu_save_state(client->sysmmu);
> > +
> > +	return ret;
> > +}
> > +
> > +static int sysmmu_pm_genpd_restore_state(struct device *dev)
> > +{
> > +	struct exynos_iommu_client *client = dev->archdata.iommu;
> > +	int (*cb)(struct device *__dev);
> > +	int ret = 0;
> > +
> > +	if (dev->type && dev->type->pm)
> > +		cb = dev->type->pm->runtime_resume;
> > +	else if (dev->class && dev->class->pm)
> > +		cb = dev->class->pm->runtime_resume;
> > +	else if (dev->bus && dev->bus->pm)
> > +		cb = dev->bus->pm->runtime_resume;
> > +	else
> > +		cb = NULL;
> > +
> > +	if (!cb && dev->driver && dev->driver->pm)
> > +		cb = dev->driver->pm->runtime_resume;
> > +
> > +	sysmmu_restore_state(client->sysmmu);
> > +
> > +	if (cb)
> > +		ret = cb(dev);
> > +
> > +	if (ret)
> > +		sysmmu_save_state(client->sysmmu);
> > +
> > +	return ret;
> > +}
> > +#endif
> > +
> > +#ifdef CONFIG_PM_GENERIC_DOMAINS
> > +struct gpd_dev_ops sysmmu_devpm_ops = {
> > +#ifdef CONFIG_PM_RUNTIME
> > +	.save_state = &sysmmu_pm_genpd_save_state,
> > +	.restore_state = &sysmmu_pm_genpd_restore_state,
> > +#endif
> > +#ifdef CONFIG_PM_SLEEP
> > +	.suspend = &sysmmu_pm_genpd_suspend,
> > +	.resume = &sysmmu_pm_genpd_resume,
> > +#endif
> > +};
> > +#endif /* CONFIG_PM_GENERIC_DOMAINS */
> > +
> >   static int sysmmu_hook_driver_register(struct notifier_block *nb,
> >   					unsigned long val,
> >   					void *p)
> >   {
> >   	struct device *dev = p;
> >
> > +	/*
> > +	 * No System MMU assigned even though in the initial state.
> > +	 * See exynos_sysmmu_probe().
> > +	 */
> > +	if (dev->archdata.iommu == NULL)
> > +		return 0;
> > +
> >   	switch (val) {
> >   	case BUS_NOTIFY_BIND_DRIVER:
> >   	{
> >   		struct exynos_iommu_owner *owner;
> > +		int ret;
> >
> > -		/* No System MMU assigned. See exynos_sysmmu_probe(). */
> > -		if (dev->archdata.iommu == NULL)
> > -			break;
> > +		BUG_ON(!dev_get_drvdata(dev->archdata.iommu));
> >
> >   		owner = devm_kzalloc(dev, sizeof(*owner), GFP_KERNEL);
> >   		if (!owner) {
> >   			dev_err(dev, "No Memory for exynos_iommu_owner\n");
> > +			dev->archdata.iommu = NULL;
> >   			return -ENOMEM;
> >   		}
> >
> > @@ -1136,22 +1296,44 @@ static int sysmmu_hook_driver_register(struct notifier_block *nb,
> >   		INIT_LIST_HEAD(&owner->client);
> >   		owner->sysmmu = dev->archdata.iommu;
> >
> > +		ret = pm_genpd_add_callbacks(dev, &sysmmu_devpm_ops, NULL);
> > +		if (ret && (ret != -ENOSYS)) {
> > +			dev_err(dev,
> > +				"Failed to register 'dev_pm_ops' for iommu\n");
> > +			devm_kfree(dev, owner);
> > +			dev->archdata.iommu = NULL;
> > +			return ret;
> > +		}
> > +
> >   		dev->archdata.iommu = owner;
> >   		break;
> >   	}
> > -	case BUS_NOTIFY_UNBOUND_DRIVER:
> > +	case BUS_NOTIFY_BOUND_DRIVER:
> >   	{
> >   		struct exynos_iommu_owner *owner = dev->archdata.iommu;
> > -		if (owner) {
> > -			struct device *sysmmu = owner->sysmmu;
> > -			/* if still attached to an iommu_domain. */
> > -			if (WARN_ON(!list_empty(&owner->client)))
> > -				iommu_detach_device(owner->domain, owner->dev);
> > -			devm_kfree(dev, owner);
> > -			dev->archdata.iommu = sysmmu;
> > +		if (!pm_runtime_enabled(dev)) {
> > +			struct sysmmu_drvdata *data =
> > +					dev_get_drvdata(owner->sysmmu);
> > +			if (pm_runtime_enabled(data->sysmmu)) {
> > +				data->runtime_active = true;
> > +				if (is_sysmmu_active(data))
> > +					__sysmmu_enable_nocount(data);
> > +				pm_runtime_disable(data->sysmmu);
> > +			}
> >   		}
> >   		break;
> >   	}
> > +	case BUS_NOTIFY_UNBOUND_DRIVER:
> > +	{
> > +		struct exynos_iommu_owner *owner = dev->archdata.iommu;
> > +		struct device *sysmmu = owner->sysmmu;
> > +		if (WARN_ON(!list_empty(&owner->client)))
> > +			iommu_detach_device(owner->domain, dev);
> > +		__pm_genpd_remove_callbacks(dev, false);
> > +		devm_kfree(dev, owner);
> > +		dev->archdata.iommu = sysmmu;
> > +		break;
> > +	}
> >   	} /* switch (val) */
> >
> >   	return 0;
> > @@ -1165,4 +1347,4 @@ static int __init exynos_iommu_prepare(void)
> >   {
> >   	return bus_register_notifier(&platform_bus_type, &sysmmu_notifier);
> >   }
> > -arch_initcall(exynos_iommu_prepare);
> > +subsys_initcall_sync(exynos_iommu_prepare);
> 
> Again, initcall is not quite right way to handle platform-specific 
> things, considering that we are going to have a multiplatform kernel.
> 
> Anyway, I'm not sure if genpd is the right place to plug into with IOMMU 
> power management. Marek Szyprowski has already solved this issue without 
> hacks like this in our internal code, he's on holidays right now, but I 
> added him on Cc and also Bartlomiej Zolnierkiewicz, who may also know 
> something about this. Also added some PM guys on Cc.
> 

Thank you for the information.

I am wating for the reply from Marek.

Regards,

KyongHo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762AbaCSBDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 21:03:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19821 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057AbaCSBDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 21:03:06 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-b4-5328ecc9b418
Date: Wed, 19 Mar 2014 10:03:04 +0900
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
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 17/27] iommu/exynos: remove calls to Runtime PM API
 functions
Message-id: <20140319100304.5e26fa43ccdfc29178b058e1@samsung.com>
In-reply-to: <532861BE.7020601@samsung.com>
References: <20140314140843.ba055f28dd7ed59c46088029@samsung.com>
 <5322FD14.5090602@samsung.com>
 <20140318185605.0380c8dfe6559c06183092e5@samsung.com>
 <532861BE.7020601@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t8zI92TbzSCDV4f4rC4c/ccq8X8I0Di
	1ZEfTBYL9ltbdM7ewG7Ru+Aqm8Wmx9dYLS7vmsNmMeP8PiaLCys2sltMWXSY1eLwm3ZWi5N/
	ehkt1s94zWIx89YaFgd+jycH5zF5zG64yOLx73A/k8eda3vYPDYvqfeYfGM5o0ffllWMHp83
	yXlcOXqGKYAzissmJTUnsyy1SN8ugSvjyXTtgrOWFXc/nGFqYNyh28XIySEhYCLx+PZmFghb
	TOLCvfVsXYxcHEICyxgl5r3ZzwpTdLxpKyNEYhGjxO3G+VBVk5kkzs0/ywxSxSKgKrH42HFG
	EJtNQEti9VwIW0RAReLyqelg3cwCjawSj+4vYwdJCAuES5y68RFsN6+Ao8T8VUvBGjgFtCX2
	tHdBbdjNKPFw5z42iDssJC40dbBDNAhK/Jh8D6yZGWjb5m1NrBC2vMTmNW+ZIernckicXVcP
	cZ2AxLfJh4DqOYDishKbDkCVSEocXHGDZQKj2CwkU2chmToLydQFjMyrGEVTC5ILipPSi0z1
	ihNzi0vz0vWS83M3MUKifeIOxvsHrA8xJgOtnMgsJZqcD0wWeSXxhsZmRhamJqbGRuaWZqQJ
	K4nzpj9KChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAuEupzWh3Vg2nk2vt/zXeS1sOXU7c
	8ccxrCC06JfZ6s+PPZQms7L/PcL76bgQgwov6xunrOSejOVONdJOf7YmZ9fejTGdK9D4QX9X
	wZPGyWy7LskxKFeb39+1+IbKwtjH0v82vG3N4FI6c7J0isrfNWpCmbePW6z8fKfi0r6PfGzB
	MlIGdd7rlFiKMxINtZiLihMBuG7yWwwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOKsWRmVeSWpSXmKPExsVy+t9jAd2TbzSCDdp2MVncuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwW62e8ZrGYeWsNiwO/x5OD85g8ZjdcZPH4d7ifyePOtT1sHpuX1HtMvrGc0aNvyypGj8+b
	5DyuHD3DFMAZ1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQP0gZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x48l07YKzlhV3
	P5xhamDcodvFyMkhIWAicbxpKyOELSZx4d56ti5GLg4hgUWMErcb50M5k5kkzs0/ywxSxSKg
	KrH42HGwDjYBLYnVcyFsEQEVicunpjOCNDALNLJKPLq/jB0kISwQLnHqxkcWEJtXwFFi/qql
	YA2cAtoSe9q7oDbsZpR4uHMfG8QdFhIXmjrYIRoEJX5MvgfWzAy0bfO2JlYIW15i85q3zBMY
	BWYhKZuFpGwWkrIFjMyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYKTyTPpHYyrGiwOMQpw
	MCrx8B6I0ggWYk0sK67MPcQowcGsJMIrfBcoxJuSWFmVWpQfX1Sak1p8iDEZGB4TmaVEk/OB
	iS6vJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhgbd7LlKKet
	j7h24Jo6w7un6vHmPfPObbp6MyguOTqxVObf3BvrRTZ4N4YeSbC66xF/mmOrlo5EgdGD8HKH
	lKsak/cxxDsxH5k+QfOpB9MpNp8En93nGO6uYS1+ybW5fcrB1UqZz77cnqW78/RP683fzjG8
	T+WMrTba1GWdVCP7dqaYZMbEJ81KLMUZiYZazEXFiQAtYpdvagMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014 16:09:50 +0100, Tomasz Figa wrote:
> On 18.03.2014 10:56, Cho KyongHo wrote:
> > On Fri, 14 Mar 2014 13:59:00 +0100, Tomasz Figa wrote:
> >> Hi KyongHo,
> >>
> >> On 14.03.2014 06:08, Cho KyongHo wrote:
> 
> [snip]
> 
> >>> -static bool __exynos_sysmmu_disable(struct sysmmu_drvdata *data)
> >>> +static void __sysmmu_disable_nocount(struct sysmmu_drvdata *data)
> >>
> >> If you are changing the names anyway, it would be probably a good idea
> >> to reduce code obfuscation a bit and drop the underscores from
> >> beginnings of function names. Also I'd suggest keeping the "exynos_" prefix.
> >
> > Thanks for the suggestion.
> > __exynos_sysmmu_disable is splitted into 2 functions: __sysmmu_disable
> > and __sysmmu_disable_nocount.
> > I agree with you that it is good idea to reduce code obfuscation but
> > I don't think dropping beginning underscores of function names reduces
> > obfuscation.
> >
> 
> Well, if you are ending up with a function like 
> __sysmmu_enable_nocount() below with every line starting with two 
> underscores, do you think this improves code readability?
> 
> Of course this is a minor issue, but let's keep some code quality level 
> in Linux kernel.
> 

Ok. understood what your are concerning about.

> >>
> >>>    {
> >>> -	unsigned long flags;
> >>> -	bool disabled = false;
> >>> -
> >>> -	write_lock_irqsave(&data->lock, flags);
> 
> [snip]
> 
> Here's the function mentioned above:
> 
> >>> +
> >>> +static void __sysmmu_enable_nocount(struct sysmmu_drvdata *data)
> >>> +{
> >>> +	__master_clk_enable(data);
> >>> +	__sysmmu_clk_enable(data);
> >>> +
> >>> +	__raw_writel(CTRL_BLOCK, data->sfrbase + REG_MMU_CTRL);
> >>> +
> >>> +	__sysmmu_init_config(data);
> >>> +
> >>> +	__sysmmu_set_ptbase(data->sfrbase, data->pgtable);
> >>> +
> >>> +	__raw_writel(CTRL_ENABLE, data->sfrbase + REG_MMU_CTRL);
> >>> +
> >>> +	__master_clk_disable(data);
> >>> +}
> >>> +
> 
> [snip]
> 
> >>>
> >>> @@ -629,7 +700,7 @@ err_pgtable:
> >>>    static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
> >>>    {
> >>>    	struct exynos_iommu_domain *priv = domain->priv;
> >>> -	struct sysmmu_drvdata *data;
> >>> +	struct exynos_iommu_owner *owner;
> >>>    	unsigned long flags;
> >>>    	int i;
> >>>
> >>> @@ -637,11 +708,14 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
> >>>
> >>>    	spin_lock_irqsave(&priv->lock, flags);
> >>>
> >>> -	list_for_each_entry(data, &priv->clients, node) {
> >>> -		while (!exynos_sysmmu_disable(data->dev))
> >>> +	list_for_each_entry(owner, &priv->clients, client) {
> >>> +		while (!exynos_sysmmu_disable(owner->dev))
> >>>    			; /* until System MMU is actually disabled */
> >>
> >> What about using list_for_each_entry_safe() and calling list_del_init()
> >> here directly?
> >>
> >
> > That require another variable to be defined.
> 
> Is it a problem?
> 
That is not a problem.
But I think using list_for_each_entry() is not a problem likewise.

> > I just wanted to avoid that because I think it is prettier.
> > Moreover, list_del_init() below the empty while() clause may make
> > the source code readers misunderstood..
> 
> This raises another question, why the loop above is even needed. 
> exynos_sysmmu_disable() should make sure that SYSMMU is actually 
> disabled, without any need for looping like this.

Some driver needs enabling sysmmu to be counted due to its complex structure.
It can be also removed by the driver with an extra effort
but the reality is important.
Device driver is not only for the scholarship but also for the real use.

> >>>    	}
> >>>
> >>> +	while (!list_empty(&priv->clients))
> >>> +		list_del_init(priv->clients.next);
> >>> +
> >>>    	spin_unlock_irqrestore(&priv->lock, flags);
> >>>
> >>>    	for (i = 0; i < NUM_LV1ENTRIES; i++)
> 
> [snip]
> 
> >>> +static int sysmmu_hook_driver_register(struct notifier_block *nb,
> >>> +					unsigned long val,
> >>> +					void *p)
> >>> +{
> >>> +	struct device *dev = p;
> >>> +
> >>> +	switch (val) {
> >>> +	case BUS_NOTIFY_BIND_DRIVER:
> >>> +	{
> >>> +		struct exynos_iommu_owner *owner;
> >>
> >> Please move this variable to the top of the function and drop the braces
> >> around case blocks.
> >
> > I don't think it is required because this function is modified
> > by the following patches.
> 
> OK, if so, and similar issue is not present after further patches.
> 
> >
> >>
> >>> +
> >>> +		/* No System MMU assigned. See exynos_sysmmu_probe(). */
> >>> +		if (dev->archdata.iommu == NULL)
> >>> +			break;
> >>
> >> This looks strange... (see below)
> >>
> >> Also this looks racy. There are no guarantees about device probing
> >> order, so you may end up with master devices being probed before the
> >> IOMMUs. Deferred probing should be used to handle this correctly.
> >
> > System MMU driver must be probed earlier than the drivers of master devices
> > because the drivers may want to use System MMU for their initial task.
> 
> As I said, there are no guarantees about platform device probe order in 
> Linux kernel. Code must be designed to check whether required 
> dependencies are met and if not, deferred probing must be used.
> 

I told that System MMU driver must be probed earlier.
That's why exynos_iommu_init() is called by subsys_initcall level.
I also noticed that it must be promoted to arch_initcall for some driver.

> >>
> >>> +
> >>> +		owner = devm_kzalloc(dev, sizeof(*owner), GFP_KERNEL);
> >>> +		if (!owner) {
> >>> +			dev_err(dev, "No Memory for exynos_iommu_owner\n");
> >>> +			return -ENOMEM;
> >>> +		}
> >>> +
> >>> +		owner->dev = dev;
> >>> +		INIT_LIST_HEAD(&owner->client);
> >>> +		owner->sysmmu = dev->archdata.iommu;
> >>> +
> >>> +		dev->archdata.iommu = owner;
> >>
> >> I don't understand what is happening here in this case statement. There
> >> is already something assigned to dev->archdata.iommu, but this code
> >> reassigns something else to this field. This means that you attempt to
> >> use the same field to store pointers to objects of different types,
> >> which I believe is broken, because you have no way to check what kind of
> >> object is currently pointed by such (void *) pointer.
> >>
> >
> > exynos_sysmmu_probe() assigns the device descriptor of the probing System MMU
> > to archdata.iommu of its master device. The assignment is just a marker that
> > the device is a master device of a System MMU.
> > If dev->archdata.iommu has a value in the case of BUS_NOTIFY_BIND_DRIVER,
> > the 'dev' is a master devices of a System MMU. Then sysmmu_hook_driver_register()
> > assigns the data structure to handle System MMU to dev->archdata.iommu.
> 
> Which is wrong (or even if you don't consider it wrong, it is ugly), 
> because one (void *) pointer in the same object is used to store 
> pointers to two completely different types.

archdata.iommu has a pointer to sysmmu descriptor for a very short time
during booting time to build complete data structure to handle System MMU.
It is it also a matter?

Anyway, this style of initialization just maintained to make the driver work
with the old design. It is changed with the following patches.


Regards,

KyongHo

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbaIWK0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:26:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11052 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625AbaIWK0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:26:46 -0400
X-AuditID: cbfee68d-f79296d000004278-c8-54214ae3c326
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Dong Aisheng'" <b29396@freescale.com>, arnd@arndb.de
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        tomasz.figa@gmail.com, linux@arm.linux.org.uk,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com, kgene.kim@samsung.com,
        Li.Xiubo@freescale.com
References: <1411360807-7750-1-git-send-email-pankaj.dubey@samsung.com>
 <20140922091925.GA19778@shlinux1.ap.freescale.net>
In-reply-to: <20140922091925.GA19778@shlinux1.ap.freescale.net>
Subject: RE: [PATCH v5] mfd: syscon: Decouple syscon interface from platform
 devices
Date: Tue, 23 Sep 2014 15:59:43 +0530
Message-id: <000001cfd719$51e7e560$f5b7b020$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQKkPpk+xGsfKb8cRzoLv6q27vvt4QIYhcStmlTh/5A=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsWyRsSkRvexl2KIwbnrghZ/Jx1jt3i4s5/F
	Ytmku2wW33d9YbfoXXCVzeL+16OMFp0XOlgtNj2+xmpxedccNosZ5/cxWdy+zGvx6eh/VouO
	ZYwWq3b9YbS4+Ww7kwO/R0tzD5vH71+TGD3+He5n8tg56y67x51re9g8Ni+p9+jbsorR4/Mm
	uQCOKC6blNSczLLUIn27BK6Mjqlr2AqOaFRM62xgbGBcKd/FyMkhIWAiMefae1YIW0ziwr31
	bF2MXBxCAksZJc783s8KU9TV18UOkZjOKLHzZyuU85dRYuviI4wgVWwCuhJP3s9lBrFFBCwk
	jt1/AtTNwcEscIVJoj0KJCwkUCPRtfslO4jNKWAvcfvtJjBbWCBM4s+hZiaQchYBVYnlbckg
	YV4BS4lNx3azQtiCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZ4k4FiR1nXzNCXGAlcfPdIaga
	cYlJDx6CnSwhsINDYu2PFrC9LAICEt8mH2IB2SshICux6QDUHEmJgytusExglJiFZPUsJKtn
	IVk9C8mKBYwsqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzECk8Tpf896dzDePmB9iFGAg1GJ
	h9djjUKIEGtiWXFl7iFGU6CLJjJLiSbnA1NRXkm8obGZkYWpiamxkbmlmZI4r6LUz2AhgfTE
	ktTs1NSC1KL4otKc1OJDjEwcnFINjKZcU+rSHDW7TDv6HZU2M+elXL3WsmlHcra0xtOrR5Jn
	mP2YbOD95rkCs9LGdzuYbv//UfylUOWr1rVWhh21DTOlHCtfJi4Lat9/47KYVa5C1onLn7YG
	Prilnr964vOypFdZM99aOmVoK06uUBGadfeMiQKjt2v0gdXTLBeGFXGlvLA9Wul5RImlOCPR
	UIu5qDgRAJrnY+MNAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCKsWRmVeSWpSXmKPExsVy+t9jQd3HXoohBicvsFv8nXSM3eLhzn4W
	i2WT7rJZfN/1hd2id8FVNov7X48yWnRe6GC12PT4GqvF5V1z2CxmnN/HZHH7Mq/Fp6P/WS06
	ljFarNr1h9Hi5rPtTA78Hi3NPWwev39NYvT4d7ifyWPnrLvsHneu7WHz2Lyk3qNvyypGj8+b
	5AI4ohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	bldSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZnRMXcNWcESjYlpnA2MD
	40r5LkZODgkBE4muvi52CFtM4sK99WxdjFwcQgLTGSV2/mxlh3D+MkpsXXyEEaSKTUBX4sn7
	ucwgtoiAhcSx+09Yuxg5OJgFrjBJtEeBhIUEaiS6dr8EG8opYC9x++0mMFtYIEziz6FmJpBy
	FgFVieVtySBhXgFLiU3HdrNC2IISPybfYwGxmQW0JNbvPM4EYctLbF7zlhniTgWJHWdfM0Jc
	YCVx890hqBpxiUkPHrJPYBSahWTULCSjZiEZNQtJywJGllWMoqkFyQXFSem5hnrFibnFpXnp
	esn5uZsYwSnomdQOxpUNFocYBTgYlXh4PdcohAixJpYVV+YeYpTgYFYS4e1XVAwR4k1JrKxK
	LcqPLyrNSS0+xGgK9OhEZinR5HxgeswriTc0NjE3NTa1NLEwMbNUEuc90GodKCSQnliSmp2a
	WpBaBNPHxMEp1cA4fRX/M2FBwwIdWeGNwVVmexduXhepMNtBVO1d/AHmniO9/lfW3rovVrdv
	68dA0zUft/IuVN+9IVxhG4+d03rO6p3Ohsl7mRL8+Cf1/1nzS3+ua7lS3PkrE9kvsxtW+YbX
	/Egvu3pso/pHyeNH875W7n66riH62w6h2TwxAYueP9gzK2ZV47oiJZbijERDLeai4kQAx102
	xFcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dong,

On Monday, September 22, 2014, Dong Aisheng wrote,
> On Mon, Sep 22, 2014 at 10:10:07AM +0530, Pankaj Dubey wrote:

[snip]

> > -static int syscon_match_node(struct device *dev, void *data)
> > +static struct syscon *of_syscon_register(struct device_node *np)
> >  {
> > -	struct device_node *dn = data;
> > +	struct platform_device *pdev = NULL;
> > +	struct syscon *syscon;
> > +	struct regmap *regmap;
> > +	void __iomem *base;
> > +	int ret;
> > +
> > +	if (!of_device_is_compatible(np, "syscon"))
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
> > +	if (!syscon)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	base = of_iomap(np, 0);
> > +	if (!base) {
> > +		ret = -ENOMEM;
> > +		goto err_map;
> > +	}
> > +
> > +	/* if device is already populated and available then use it */
> > +	pdev = of_find_device_by_node(np);
> > +	if (!pdev) {
> > +		/* for early users create dummy syscon device and use it */
> > +		pdev = platform_device_alloc("dummy-syscon", -1);
> 
> Can we create specific devices for each syscon device?
> That looks more reasonable to me.
> Then we can dump registers in regmap debugfs more clearly, just like other
devices.
> And i think it's better to follow device tree way to generate devices from
node.
> If DT core find a device is already created, it can ignore that device to
avoid creating
> duplicated device during of_platform_populate.
> 

If you are referring to use "of_platform_device_create", then I am afraid
that it can't be used
in very early stage. For example, current patch I tested by calling
syscon_lookup_by_phandle from
"init_irq" hook of machine_desc, and it worked well, but If I use
"of_platform_device_create"
instead of dummy device, it fails to create pdev and this I verified on
Exynos platform. The reason
I selected "init_irq" is because this comes just before smp init and where
once we tried to get regmap handle,
but could not do so. 

Also if it was just a matter of creating platform_device at early stage then
early initialization of
syscon could have been solved till now.

So I would suggest if we really want this patch to cover early
initialization of syscon
(which is not it's main purpose) current patch is sufficient. 

@Arnd, since I have addressed crash issue as reported by Dong Aisheng, I
would like to take your ack,
but since there are some more code changes other than what you suggested I
request you to check this
and if you are ok, then I would like to your ack so that I can request to
maintainer for taking this patch.

Thanks,
Pankaj Dubey

> Regards
> Dong Aisheng
> 
> > +		if (!pdev) {
> > +			ret = -ENOMEM;
> > +			goto err_pdev;
> > +		}
> > +		pdev->dev.of_node = of_node_get(np);
> > +	}
> > +
> > +	regmap = devm_regmap_init_mmio(&pdev->dev, base,
> &syscon_regmap_config);
> > +	if (IS_ERR(regmap)) {
> > +		dev_err(&pdev->dev, "regmap init failed\n");
> > +		ret = PTR_ERR(regmap);
> > +		goto err_regmap;
> > +	}
> > +
> > +	syscon->regmap = regmap;
> > +	syscon->np = np;
> >
> > -	return (dev->of_node == dn) ? 1 : 0;
> > +	spin_lock(&syscon_list_slock);
> > +	list_add_tail(&syscon->list, &syscon_list);
> > +	spin_unlock(&syscon_list_slock);
> > +
> > +	return syscon;
> > +
> > +err_regmap:
> > +	if (!strcmp(pdev->name, "dummy-syscon")) {
> > +		of_node_put(np);
> > +		platform_device_put(pdev);
> > +	}
> > +err_pdev:
> > +	iounmap(base);
> > +err_map:
> > +	kfree(syscon);
> > +	return ERR_PTR(ret);
> >  }
> >
> >  struct regmap *syscon_node_to_regmap(struct device_node *np)  {
> > -	struct syscon *syscon;
> > -	struct device *dev;
> > +	struct syscon *entry, *syscon = NULL;
> >
> > -	dev = driver_find_device(&syscon_driver.driver, NULL, np,
> > -				 syscon_match_node);
> > -	if (!dev)
> > -		return ERR_PTR(-EPROBE_DEFER);
> > +	spin_lock(&syscon_list_slock);
> >
> > -	syscon = dev_get_drvdata(dev);
> > +	list_for_each_entry(entry, &syscon_list, list)
> > +		if (entry->np == np) {
> > +			syscon = entry;
> > +			break;
> > +		}
> > +
> > +	spin_unlock(&syscon_list_slock);
> > +
> > +	if (!syscon)
> > +		syscon = of_syscon_register(np);
> > +
> > +	if (IS_ERR(syscon))
> > +		return ERR_CAST(syscon);
> >
> >  	return syscon->regmap;
> >  }
> > @@ -110,17 +185,6 @@ struct regmap
> > *syscon_regmap_lookup_by_phandle(struct device_node *np,  }
> > EXPORT_SYMBOL_GPL(syscon_regmap_lookup_by_phandle);
> >
> > -static const struct of_device_id of_syscon_match[] = {
> > -	{ .compatible = "syscon", },
> > -	{ },
> > -};
> > -
> > -static struct regmap_config syscon_regmap_config = {
> > -	.reg_bits = 32,
> > -	.val_bits = 32,
> > -	.reg_stride = 4,
> > -};
> > -
> >  static int syscon_probe(struct platform_device *pdev)  {
> >  	struct device *dev = &pdev->dev;
> > @@ -167,7 +231,6 @@ static struct platform_driver syscon_driver = {
> >  	.driver = {
> >  		.name = "syscon",
> >  		.owner = THIS_MODULE,
> > -		.of_match_table = of_syscon_match,
> >  	},
> >  	.probe		= syscon_probe,
> >  	.id_table	= syscon_ids,
> > --
> > 1.7.9.5
> >


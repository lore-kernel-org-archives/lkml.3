Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416AbaIVEJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 00:09:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14642 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaIVEJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 00:09:48 -0400
X-AuditID: cbfee691-f79b86d000004a5a-2d-541fa106cfe2
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, arnd@arndb.de, linux@arm.linux.org.uk,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com, kgene.kim@samsung.com,
        b29396@freescale.com, Li.Xiubo@freescale.com
References: <1411132009-11173-1-git-send-email-pankaj.dubey@samsung.com>
 <541C47BD.3070601@gmail.com>
In-reply-to: <541C47BD.3070601@gmail.com>
Subject: RE: [PATCH v4] mfd: syscon: Decouple syscon interface from platform
 devices
Date: Mon, 22 Sep 2014 09:41:54 +0530
Message-id: <001a01cfd61b$5ac95a00$105c0e00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQDv2c/dfTRsRLdvEb8eb3UMDD1wVAGiOcYOnb9rfhA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsWyRsSkTpdtoXyIwY0fVhZ/Jx1jt3i4s5/F
	Ytmku2wW33d9YbfoXXCVzeL+16OMFp0XOlgtNj2+xmpxedccNosZ5/cxWdy+zGvx6eh/VouO
	ZYwWq3b9YbS4+Ww7kwO/R0tzD5vH71+TGD3+He5n8tg56y67x51re9g8Ni+p9+jbsorR4/Mm
	uQCOKC6blNSczLLUIn27BK6MOT9/MRdslK9oXdvB0sDYIdHFyMkhIWAi0TL7KAuELSZx4d56
	ti5GLg4hgaWMEkdvH2GGKTq55Cg7RGIRo8Smk9eYIZy/jBKvz81jBKliE9CVePJ+LlhCRGAK
	o8TKza1g7cwCPxklnu6uBbGFBNIl1kzZBBbnFNCUmHNrLzuILSwQJnGrZRcTiM0ioCox99hN
	MJtXwFLi8KKHzBC2oMSPyfdYIGZqSazfeZwJwpaX2LzmLdSpChI7zr4GO0hEwEri0IY/UDXi
	EpMePAR7QUJgC4fE19mv2CGWCUh8m3wIaCgHUEJWYtMBqDmSEgdX3GCZwCgxC8nqWUhWz0Ky
	ehaSFQsYWVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525iBKaK0/+eTdzBeP+A9SFGAQ5GJR7e
	Hy3yIUKsiWXFlbmHGE2BLprILCWanA9MSHkl8YbGZkYWpiamxkbmlmZK4rw60j+DgYGYWJKa
	nZpakFoUX1Sak1p8iJGJg1OqgbG7WZxdus81/kR3jt25faqSR7ZVbv7wMfjFBDnHy3OXq0Qc
	1Zn0Oz1k1t2Ss/JJv/kkeno2Vs7cen2zu9bXs+1VU3v1X789u3CGypPqaZ8PT9rN7tB/TGzj
	mZmfjKfMsZfPL1o49+v247VejzfoBJsrM/7W/96ofsafX9cjI6CgfFLfvQfeZjZKLMUZiYZa
	zEXFiQCzLnZ9EAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jAV22hfIhBtO6DC3+TjrGbvFwZz+L
	xbJJd9ksvu/6wm7Ru+Aqm8X9r0cZLTovdLBabHp8jdXi8q45bBYzzu9jsrh9mdfi09H/rBYd
	yxgtVu36w2hx89l2Jgd+j5bmHjaP378mMXr8O9zP5LFz1l12jzvX9rB5bF5S79G3ZRWjx+dN
	cgEcUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	tysplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM+b8/MVcsFG+onVtB0sD
	Y4dEFyMnh4SAicTJJUfZIWwxiQv31rN1MXJxCAksYpTYdPIaM4Tzl1Hi9bl5jCBVbAK6Ek/e
	zwVLiAhMYZRYubmVGSTBLPCTUeLp7loQW0ggXWLNlE1gcU4BTYk5t/aCrRAWCJO41bKLCcRm
	EVCVmHvsJpjNK2ApcXjRQ2YIW1Dix+R7LBAztSTW7zzOBGHLS2xe85YZ4lQFiR1nX4MdJCJg
	JXFowx+oGnGJSQ8esk9gFJqFZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6
	yfm5mxjBieiZ9A7GVQ0WhxgFOBiVeHh/tMiHCLEmlhVX5h5ilOBgVhLhPZoDFOJNSaysSi3K
	jy8qzUktPsRoCvTpRGYp0eR8YJLMK4k3NDYxNzU2tTSxMDGzVBLnPdhqHQgMr8SS1OzU1ILU
	Ipg+Jg5OqQZGeY3w/qf/mU+YyF17Enmoi3H6Gq5zTlYLNy5+fnr5fbUJlQluPRX5vd2dm032
	OemFTP7zL1PYctLC028vLJErmfvQ5YfW7ZzFghtTVQI/FBTpLNmk9pqpecGmzNlLtzmkXmGa
	M9/OZ8rBxIjDL9dzPFoxd8rPyvWvPhYVNNy+WZU3aXfgU71NH5RYijMSDbWYi4oTARsly+5a	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On Friday, September 19, 2014 Tomasz Figa wrote,
> Hi Pankaj,
> 
> Please see my comments inline.
> 
> On 19.09.2014 15:06, Pankaj Dubey wrote:
> > Currently a syscon entity can be only registered directly through a
> > platform device that binds to a dedicated syscon driver. However in
> > certain use cases it is desirable to make a device used with another
> > driver a syscon interface provider.
> 
> [snip]
> 
> > -static int syscon_match_node(struct device *dev, void *data)
> > +static struct syscon *of_syscon_register(struct device_node *np)
> >  {
> > -	struct device_node *dn = data;
> > +	struct platform_device *pdev = NULL;
> > +	struct syscon *syscon;
> > +	struct regmap *regmap;
> > +	void __iomem *base;
> > +
> > +
> 
> nit: Stray blank line.
> 

OK. Will remove this.

> > +	if (!of_device_is_compatible(np, "syscon"))
> > +		return ERR_PTR(-EINVAL);
> 
> I don't think this check is needed at all. I'd say that drivers should be
free to register a
> syscon provider for any node.

I think this check is correct, as only nodes having "syscon" as secondary
compatibility should be
used to create a syscon provider. And that's why we have "syscon" as
secondary compatibility in
device nodes which can be a syscon provider.

> 
> > +
> > +	syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
> > +	if (!syscon)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	base = of_iomap(np, 0);
> > +	if (!base)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	if (!of_device_is_available(np) ||
> 
> Wouldn't it be enough to simply call of_find_device_by_node(np) and if it
fails then
> instead create a dummy device?
> 

OK, this could be also one of approach, I will change accordingly.

> > +			of_node_test_and_set_flag(np, OF_POPULATED)) {
> > +		/* if device is already populated and avaiable then use it
*/
> > +		pdev = of_find_device_by_node(np);
> > +		if (!(&pdev->dev))
> 
> This is just plain wrong, because this condition will always evaluate to
true (see the
> definition of struct platform_device). Shouldn't you rather just check the
pdev
> pointer?

OK, will update this.

> 
> > +			return ERR_PTR(-ENODEV);
> > +
> > +	} else {
> > +		/* for early users create dummy syscon device and use it */
> > +		pdev = kzalloc(sizeof(*pdev), GFP_KERNEL);
> > +		if (!pdev)
> > +			return ERR_PTR(-ENOMEM);
> 
> Any clean-up on error path?

OK, will add error path. Also will use platform_device_alloc as suggested.

> 
> > +
> > +		pdev->name = "dummy-syscon";
> > +		pdev->id = -1;
> 
> Wouldn't you get an ID collision if more than one syscon is registered
early? Maybe
> the naming scheme from of_device_alloc() could be adopted partially?

I think this should not be an issue, passing id as -1 should take care of
this.
As you know Exynos has two syscon providers "pmu" and "sysreg" I have
written a test
code to check this scenario and tested it during early stage and I am
successfully able to get
PMU and SYSREG handle.
 
> 
> > +		device_initialize(&pdev->dev);
> 
> I wonder if you couldn't simply reuse platform_device_alloc() for all of
this, except
> the line below, which would still have to be handled separately.
> 
> > +		pdev->dev.of_node = np;
> > +	}
> > +
> > +	regmap = regmap_init_mmio(&pdev->dev, base, &syscon_regmap_config);
> > +	if (IS_ERR(regmap)) {
> > +		pr_err("regmap init failed\n");
> 
> If you have a dev here then you should be able to use dev_err() already.

OK.

> 
> > +		return ERR_CAST(regmap);
> > +	}

[snip]

> > +
> > +	if (!syscon)
> > +		syscon = of_syscon_register(np);
> > +
> > +	if (!IS_ERR(syscon))
> > +		return syscon->regmap;
> > +
> > +	return ERR_CAST(syscon);
> 
> nit: Usually error checking is done the opposite way, i.e.

OK, will change accordingly.

Thanks,
Pankaj Dubey
> 
> 	if (IS_ERR(syscon))
> 		return ERR_CAST(syscon);
> 
> 	return syscon->regmap;
> 
> Best regards,
> Tomasz


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbbALIA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 03:00:26 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:64645 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbbALIAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 03:00:20 -0500
X-AuditID: cbfee68d-f79296d000004278-e7-54b37f1168ef
Date: Mon, 12 Jan 2015 08:00:17 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCHv7 03/10] devfreq: event: Add resource-managed function for
 devfreq-event device
To: =?utf-8?Q?=EC=B5=9C=EC=B0=AC=EC=9A=B0?= <cw00.choi@samsung.com>,
        "kgene@kernel.org" <kgene@kernel.org>
Cc: =?utf-8?Q?=EB=B0=95=EA=B2=BD=EB=AF=BC?= <kyungmin.park@samsung.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        ABHILASH KESAVAN <a.kesavan@samsung.com>,
        "tomasz.figa@gmail.com" <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        =?utf-8?Q?=EB=8C=80=EC=9D=B8=EA=B8=B0?= <inki.dae@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20150112075952787@myungjoo.ham
Msgkey: 20150112075952787@myungjoo.ham
X-EPLocale: ko_KR.utf-8
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20150112075952787@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
X-ConfirmMail: N,general
Content-type: text/plain; charset=utf-8
MIME-version: 1.0
Message-id: <765071676.891461421049614417.JavaMail.weblogic@epmlwas09a>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkWFewfnOIwf4vRhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStj86UP7AVflCqublvH1MD4R7GLkZNDSEBdYtGSk2wgtoSAicTs
	zatYIGwxiQv31gPFuYBqljJKzHu3jBmm6M/XOywQiTmMEl9ufWcCSbAIqEr0ztrP2sXIwcEm
	oCcx83MyiCkskCzx7HQMSIWIQJ7ElbszGEFamQV62CQ6rn5nhjhCSWLNvldgi3kFBCVOznzC
	AtIrATSyY6YfRFhN4sLk2VB3iktcmHuJHcLmlZjR/hTqZjmJaV/XQJ0pLXF+1gZGmF8Wf38M
	FeeXOHZ7BxOELSAx9cxBqBotibmXuqHm80msWfiWBaZ+16nlzDC77m+ZC9UrIbG15QkriM0s
	oCgxpfshO8jJzAKaEut36aP6BMR2l5h/4gU41CQEpnJI/Fv6j3ECo9IsJHWzkIyahTAKWckC
	RpZVjKKpBckFxUnpRYZ6xYm5xaV56XrJ+bmbGIFJ4fS/Z707GG8fsD7EKMDBqMTDayG1OUSI
	NbGsuDL3EKMpMI4mMkuJJucDU09eSbyhsZmRhamJqbGRuaWZkjivotTPYCGB9MSS1OzU1ILU
	ovii0pzU4kOMTBycUg2MDcdN7A+2tYhevFlcZdeW21wUJi8cNlGv8cyurB9TytoPNiuzl38x
	a5shlnLIgNn+8lz1R5f83/F7b+YKtlrBmiPOf2Kds9QtU/3IW9LrNtiKyesrGlyTsVKozV64
	/O3DdbOm6V9Ty7U888gza84sty26S7ze/t35c/eiRy/Kl90oWhd+efJvJZbijERDLeai4kQA
	PZV+8gUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMKsWRmVeSWpSXmKPExsVy+t/tXl3B+s0hBtf3aFtc3jWHzYHR4/Mm
	uQDGqDSbjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWhDcyM9IwM9UyM9Q+NYK0MDAyNToJqEtIzN
	lz6wF3xRqri6bR1TA+MfxS5GTg4hAXWJRUtOsoHYEgImEn++3mGBsMUkLtxbDxTnAqqZwyjx
	5dZ3JpAEi4CqRO+s/axdjBwcbAJ6EjM/J4OYwgLJEs9Ox4BUiAjkSVy5O4MRpJVZoIdNouPq
	d2aIXUoSa/a9ApvPKyAocXLmExaQXgmgkR0z/SDCahIXJs+GOkdc4sLcS+wQNq/EjPanUKfJ
	SUz7uoYZwpaWOD9rAyPMyYu/P4aK80scu72DCcIWkJh65iBUjZbE3EvdUPP5JNYsfMsCU7/r
	1HJmmF33t8yF6pWQ2NryhBXEZhZQlJjS/ZAd5GRmAU2J9bv0UX0CYrtLzD/xgmUCo+wsJKlZ
	SLpnIXQjK1nAyLKKUTS1ILmgOCm9wkSvODG3uDQvXS85P3cTIzgBPVuyg7HhgvUhRgEORiUe
	XgupzSFCrIllxZW5hxglOJiVRHhdy4BCvCmJlVWpRfnxRaU5qcWHGE2BMTaRWUo0OR+YHPNK
	4g2NjU3MTEwtTSwMTM2VxHn/n8sNERJITyxJzU5NLUgtgulj4uCUamBkyrq12EFgY80Gxp0N
	G36p3+hf9HPHFI/ZhyL6lk3jyGn88jDr14OfOW/kGP5ZvJlScMnuZbHB5GSRXf0pga6qtU2z
	vz2Nq3RjLa0Q/mm1L+Jo7YeVH2xVd1/9ppXy5tUebgdj1Qmpyxhfv/q32/ufQxzrBNHtFyzO
	fDmbp6Mx9crXqUeXqF7hU2Ipzkg01GIuKk4EAHDOnQVWAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0C80euR016399

>   
>  This patch add the resource-managed function for devfreq-event device as
> following functions. The devm_devfreq_event_add_edev() manages automatically
> the memory of devfreq-event device using resource management.
> - devm_devfreq_event_add_edev()
> - devm_devfreq_event_remove_edev()
> 
> Cc: Myungjoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/devfreq/devfreq-event.c | 63 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/devfreq-event.h   | 16 +++++++++++
>  2 files changed, 79 insertions(+)
> 
> diff --git a/drivers/devfreq/devfreq-event.c b/drivers/devfreq/devfreq-event.c
> index 64c1764..5301e2b 100644
> --- a/drivers/devfreq/devfreq-event.c
> +++ b/drivers/devfreq/devfreq-event.c
> @@ -451,6 +451,69 @@ int devfreq_event_remove_edev(struct devfreq_event_dev *edev)
>  }
>  EXPORT_SYMBOL_GPL(devfreq_event_remove_edev);
>  
> +static int devm_devfreq_event_match(struct device *dev, void *res, void *data)
> +{
> +	struct devfreq_event_dev **r = res;
> +
> +	if (WARN_ON(!r || !*r))
> +		return 0;
> +
> +	return *r == data;
> +}
> +
> +static void devm_devfreq_event_release(struct device *dev, void *res)
> +{
> +	devfreq_event_remove_edev(*(struct devfreq_event_dev **)res);
> +}

Isn't dev-free functions supposed to check if it is already freed or not?

> +
> +/**
> + * devm_devfreq_event_add_edev() - Resource-managed devfreq_event_add_edev()
> + * @dev		: the device owning the devfreq-event device being created
> + * @desc	: the devfreq-event device's decriptor which include essential
> + *		  data for devfreq-event device.
> + *
> + * Note that this function manages automatically the memory of devfreq-event
> + * device using device resource management and simplify the free operation
> + * for memory of devfreq-event device.
> + */
> +struct devfreq_event_dev *devm_devfreq_event_add_edev(struct device *dev,
> +						struct devfreq_event_desc *desc)
> +{
> +	struct devfreq_event_dev **ptr, *edev;
> +
> +	ptr = devres_alloc(devm_devfreq_event_release, sizeof(*ptr), GFP_KERNEL);
> +	if (!ptr)
> +		return ERR_PTR(-ENOMEM);
> +
> +	edev = devfreq_event_add_edev(dev, desc);
> +	if (IS_ERR(edev)) {
> +		devres_free(ptr);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	*ptr = edev;
> +	devres_add(dev, ptr);
> +
> +	return edev;
> +}
> +EXPORT_SYMBOL(devm_devfreq_event_add_edev);

You are using GPL Symbol in this function (devres_alloc).

> +
> +/**
> + * devm_devfreq_event_remove_edev()- Resource-managed devfreq_event_remove_edev()
> + * @dev		: the device owning the devfreq-event device being created
> + * @edev	: the devfreq-event device
> + *
> + * Note that this function manages automatically the memory of devfreq-event
> + * device using device resource management.
> + */
> +void devm_devfreq_event_remove_edev(struct device *dev,
> +				struct devfreq_event_dev *edev)
> +{
> +	WARN_ON(devres_release(dev, devm_devfreq_event_release,
> +			       devm_devfreq_event_match, edev));
> +}
> +EXPORT_SYMBOL(devm_devfreq_event_remove_edev);

Here you are using GPL symbol as well (devres_release).

[]
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•

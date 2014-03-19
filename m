Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbaCSJGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:06:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16499 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758352AbaCSJGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:06:36 -0400
X-AuditID: cbfee68e-b7f566d000002344-a7-53295e160595
Date: Wed, 19 Mar 2014 18:06:28 +0900
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
Subject: Re: [PATCH v11 13/27] iommu/exynos: support for device tree
Message-id: <20140319180628.5eecd7347c24f1e697aaaa6a@samsung.com>
In-reply-to: <53286557.6070808@samsung.com>
References: <20140314140935.e0652b58ce16591b54d0e10b@samsung.com>
 <53230695.9080606@samsung.com>
 <20140318195210.14c953a70498f634032f35b7@samsung.com>
 <53286557.6070808@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t8zY12xOM1ggyVXOCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mro336NuWA3d0X31IOMDYztnF2MHBwSAiYSLev5uhg5
	gUwxiQv31rN1MXJxCAksY5SYs/w3K0TCROJR9ylGiMR0RokN85rZQRJCApOZJM48swWxWQRU
	JU7+7GYEsdkEtCRWzz0OZosIqEhcPjUdrJlZoJFV4tH9ZWDNwgIuEg+abjKD2LwCjhJLm/aD
	beMU0JZo7nvADLFgN6NE0wpXiCssJC40dbBD1AtK/Jh8jwXEZgZatnlbEyuELS+xec1bZoj6
	hRwS868ZQxwnIPFt8iEWiI9lJTYdgCqRlDi44gbLBEaxWUimzkIydRaSqQsYmVcxiqYWJBcU
	J6UXGekVJ+YWl+al6yXn525ihER63w7GmwesDzEmA62cyCwlmpwPTBR5JfGGxmZGFqYmpsZG
	5pZmpAkrifMuepgUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFRzf3RZFnBZzob2nUnnFFP
	/Mkb/ZLtWa79nj35z+IPZvm9kE3SE7HqTRFOeObq6DinKEuNIWf7NpWihzmbZl3fPXEbx5kf
	J39svyvwwfWk6N7qlY8unphwfr3bw4lf1om5+x9i4eg4KPJ3S4zkPo7oRxbOygqOSRITCyZo
	8Dqw1IgZOmkb9WUosRRnJBpqMRcVJwIA6rNZoAoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsVy+t9jQV2xOM1ggzmLmS3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY0b/9GnPBbu6K
	7qkHGRsY2zm7GDk5JARMJB51n2KEsMUkLtxbz9bFyMUhJDCdUWLDvGZ2kISQwGQmiTPPbEFs
	FgFViZM/u8Ea2AS0JFbPPQ5miwioSFw+NZ0RpJlZoJFV4tH9ZWDNwgIuEg+abjKD2LwCjhJL
	m/azgticAtoSzX0PmCEW7GaUaFrhCnGFhcSFpg52iHpBiR+T77GA2MxAyzZva2KFsOUlNq95
	yzyBUWAWkrJZSMpmISlbwMi8ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4lTyT2sG4ssHi
	EKMAB6MSD++BKI1gIdbEsuLK3EOMEhzMSiK8wneBQrwpiZVVqUX58UWlOanFhxiTgcExkVlK
	NDkfmObySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoGRo+3G
	ggP/si9XHJDq9H+vtlh9fsLJs8e2OWdv69LTfjRt2V8RLuUn8xid7s7vMTrw+ZBXrWretRdr
	D13fXDTFKOGd2B6B3ouPuj/c/Pvou5tV64PEHa5LpM5tCd7RZDzBVcPlN2fOtqf1Dk9Cj/jO
	2+Nz3JnbPaLG/ZzjN+aXh9dfv2fTmX9eT4mlOCPRUIu5qDgRAIGE2ElpAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014 16:25:11 +0100, Tomasz Figa wrote:
> On 18.03.2014 11:52, Cho KyongHo wrote:
> > On Fri, 14 Mar 2014 14:39:33 +0100, Tomasz Figa wrote:
> >>> @@ -557,11 +558,23 @@ static int exynos_sysmmu_probe(struct platform_device *pdev)
> >>>    	return 0;
> >>>    }
> >>>
> >>> -static struct platform_driver exynos_sysmmu_driver = {
> >>> -	.probe		= exynos_sysmmu_probe,
> >>> -	.driver		= {
> >>> +#ifdef CONFIG_OF
> >>> +static struct of_device_id sysmmu_of_match[] __initconst = {
> >>> +	{ .compatible	= "samsung,sysmmu-v1", },
> >>> +	{ .compatible	= "samsung,sysmmu-v2", },
> >>> +	{ .compatible	= "samsung,sysmmu-v3.1", },
> >>> +	{ .compatible	= "samsung,sysmmu-v3.2", },
> >>> +	{ .compatible	= "samsung,sysmmu-v3.3", },
> >>
> >> Do you need all these compatible strings? I mean, are there any
> >> implementation differences that can't be identified by reading IP
> >> registers, such as REG_MMU_VERSION?
> >>
> >
> > Unfortunately, there is a SoC which overrides REG_MMU_VERSION with
> > a value for RTL designers and it is not related to System MMU
> > versions.
> 
> OK.
> 
> What about having a generic compatible string for Samsung SysMMU then, 
> but an additional property that can override the version to account for 
> such brokenness? If not provided, the version would be read from 
> REG_MMU_VERSION.
> 

Yes it is one of possible idea.
Let me think what better way is.

Thank you.

KyongHo

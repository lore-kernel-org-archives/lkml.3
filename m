Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087AbaCSIq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:46:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42012 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbaCSIqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:46:20 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-25-5329595a1f01
Date: Wed, 19 Mar 2014 17:46:17 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
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
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: Re: [PATCH v11 13/27] iommu/exynos: support for device tree
Message-id: <20140319174617.e5ad5ca5547900dce2ecfa74@samsung.com>
In-reply-to: <CAK9yfHy+uiRPZjEDzZRpNKVY1CnWehVGdJmu3ztOTXAuHBx_Yg@mail.gmail.com>
References: <20140314140935.e0652b58ce16591b54d0e10b@samsung.com>
 <CAK9yfHx_FUaUcA_tpsJ73i0iJmczOp7K8gC6sMGHQ6c50i46=A@mail.gmail.com>
 <20140318201424.e8bde8514726c3639243e9ad@samsung.com>
 <CAK9yfHy+uiRPZjEDzZRpNKVY1CnWehVGdJmu3ztOTXAuHBx_Yg@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t8zI92oSM1ggy/bhS3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mq4ce8fa8Fv1orma+/YGhh3snQxcnJICJhI/Dt2lh3C
	FpO4cG89WxcjF4eQwDJGiYUdC9lgimbu72WCSExnlNi68ywzhDOZSeLQwR5GkCoWAVWJZ3Mb
	wEaxCWhJrJ57HCwuAmS/7F4O1s0s8JNF4s3fc2C7hQVcJB403WQGsXkFHCW+/2ljArE5BYIl
	1p5exwqxoZ1J4s/KuVB3WEhcaOpgh2gQlPgx+R7YIGagDZu3NbFC2PISm9e8BTtPQmAhh8SW
	+UuZIc4TkPg2+RBQAwdQQlZi0wFmiJmSEgdX3GCZwCg2C8nYWUjGzkIydgEj8ypG0dSC5ILi
	pPQiQ73ixNzi0rx0veT83E2MkIjv3cF4+4D1IcZkoJUTmaVEk/OBCSOvJN7Q2MzIwtTE1NjI
	3NKMNGElcd6kh0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhZeEUZbAQsbk9vMDPfnnl+
	UsKTzdEH308I/Lk0T6Cjzm/GkRv/l2qZs93pW+j/q1NJ5032bo6E/+c/2VrxGy56G++3WCzM
	tS7hn4vBivfh6wyNL8qLT63zSjh775uRqddTFYnSo5Nzn2qduijZ+rg+YsLKc5eZU19mvDsq
	MPVYU2Txom+m6QZKLMUZiYZazEXFiQCSJ78mDgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBKsWRmVeSWpSXmKPExsVy+t9jQd2oSM1gg4Mz+Szu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYcePeP9aC36wV
	zdfesTUw7mTpYuTkkBAwkZi5v5cJwhaTuHBvPVsXIxeHkMB0RomtO88yQziTmSQOHexhBKli
	EVCVeDa3gR3EZhPQklg99zhYXATIftm9nAmkgVngJ4vEm7/nwFYIC7hIPGi6yQxi8wo4Snz/
	0wa2jlMgWGLt6XWsEBvamST+rJzLBnGHhcSFpg52iAZBiR+T74ENYgbasHlbEyuELS+xec1b
	5gmMArOQlM1CUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMHp5Jn0DsZVDRaH
	GAU4GJV4eA9EaQQLsSaWFVfmHmKU4GBWEuEVvgsU4k1JrKxKLcqPLyrNSS0+xJgMDI+JzFKi
	yfnAVJdXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYyZZg4/
	1i46v/6djY2tmpLU1EYtmbbTMyvX3pGak6/oxOysGuYTvSWvqJIzZa5C6r6o9gPV/dWCDSr7
	fHaFJ2TFu8U9F0/n0Gd9kBVqJeC6zWj9155tIq9VuG7O27L7za/Nrp9eXzLfPe/aI7bjEUFf
	zAROHZ0QE7tzb6/k8z7HjDuFvG++OSuxFGckGmoxFxUnAgCTMFd3awMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014 16:46:24 +0530, Sachin Kamat wrote:
> On 18 March 2014 16:44, Cho KyongHo <pullip.cho@samsung.com> wrote:
> > On Fri, 14 Mar 2014 20:57:42 +0530, Sachin Kamat wrote:
> >> Hi KyongHo,
> >>
> >> On 14 March 2014 10:39, Cho KyongHo <pullip.cho@samsung.com> wrote:
> >> >
> >> > -static struct platform_driver exynos_sysmmu_driver = {
> >> > -       .probe          = exynos_sysmmu_probe,
> >> > -       .driver         = {
> >> > +#ifdef CONFIG_OF
> >>
> >> This is not needed as Exynos is DT only platform.
> >>
> > Yes, but I hesitate to remove that.
> 
> What is the reason for your hesitation? :)
> 
Actually, no reason because you mentioned that Exynos is DT only platofrm.

I will remove that.

Thank you.

KyongHo

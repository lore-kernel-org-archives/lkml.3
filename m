Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3JNLCe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 07:02:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:55810 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab3JNLC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 07:02:29 -0400
X-AuditID: cbfee691-b7fe06d0000008c4-2f-525bcf43f044
Date: Mon, 14 Oct 2013 20:02:27 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Alex Williamson <alex.williamson@redhat.com>
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
        Subash Patel <supash.ramaswamy@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v10 20/20] iommu/exynos: add devices attached to the System
 MMU to an IOMMU group
Message-id: <20131014200227.10964a2e57d711c23c345c10@samsung.com>
In-reply-to: <1381438469.2796.58.camel@ul30vt.home>
References: <20131007105844.a260f37a9a941bed894adca3@samsung.com>
 <1381438469.2796.58.camel@ul30vt.home>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+Zoa7z+eggg/4ZFhZ37p5jtfj2v4fN
	Yv4RIOvVkR9MFgv2W1t0zt7AbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW0xZdJjV4vCb
	dlaLk396GS1arvcyWayf8ZrFYuatNSwOgh5PDs5j8pjdcJHF49/hfiaPO9f2sHlsXlLvMfnG
	ckaP9/uusnn0bVnF6PF5k5zHlaNnmAK4orhsUlJzMstSi/TtErgyvl59zlRwXqSie/Zl1gbG
	NQJdjJwcEgImEl0zf7FC2GISF+6tZ+ti5OIQEljGKDF//gEghwOs6MLaDJAaIYHpjBInX2pD
	1Exikmj5sosJJMEioCqxcvNiFhCbTUBLYvXc44wgtoiAgcTXzxOYQBqYBS6yShz4chEsISyQ
	LvH6XAs7iM0r4Cjxs38HM4jNKWAscfVwNzPEtiyJfS3LGCGus5C40NQBVS8o8WPyPbBlzEDL
	Nm9rYoWw5SU2r3nLDFG/h0Pidm8GxHECEt8mH2KBeEZWYtMBqBJJiYMrbrBMYBSbhWTqLCRT
	ZyGZuoCReRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGSBqYuIPx/gHrQ4zJQCsnMkuJJucD
	00heSbyhsZmRhamJqbGRuaUZacJK4rzqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhi3
	9t56++msq3fpgecqz0RuRZ/I/lfpPdv8Y/HZSO170+1/b4tXCrliFlFTr2R4/14duy1D7cQz
	CqGZM+eHRLosmTBl76TkS69r/r24/eZiktoKjT9vDr/+YqIedNL6XYj0jZA7U73sTj3TODlV
	30AndO/T5FrmvffeNFtYyT3aItT3Vvp9/ILZSizFGYmGWsxFxYkABGXdOhkDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCKsWRmVeSWpSXmKPExsVy+t9jQV3n89FBBu/PGVrcuXuO1eLb/x42
	i/lHgKxXR34wWSzYb23ROXsDu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi8Nv
	2lktTv7pZbRoud7LZLF+xmsWi5m31rA4CHo8OTiPyWN2w0UWj3+H+5k87lzbw+axeUm9x+Qb
	yxk93u+7yubRt2UVo8fnTXIeV46eYQrgimpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
	1DW0tDBXUshLzE21VXLxCdB1y8wBekhJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyP
	kQEaSFjHmPH16nOmgvMiFd2zL7M2MK4R6GLk4JAQMJG4sDaji5ETyBSTuHBvPRuILSQwnVHi
	5EvtLkYuIHsSk0TLl11MIAkWAVWJlZsXs4DYbAJaEqvnHmcEsUUEDCS+fp7ABNLALHCRVeLA
	l4tgCWGBdInX51rYQWxeAUeJn/07mEFsTgFjiauHu5khtmVJ7GtZxghxhYXEhaYOqHpBiR+T
	74EtYwZatnlbEyuELS+xec1b5gmMArOQlM1CUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV5
	6XrJ+bmbGMFp5pn0DsZVDRaHGAU4GJV4eAWcooOEWBPLiitzDzFKcDArifC2nwAK8aYkVlal
	FuXHF5XmpBYfYkwGBsdEZinR5HxgCswriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6Yklq
	dmpqQWoRzBYmDk6pBsbJ/aEV5X9n8767WfTW+MuL2QXbbrDKcxg0Hb174aN5Fuvm7dLbBCOd
	1iz+ab8++uOEMxmHt1kvijBstdrj9Eig3PcaZ3LtrbYENf5Te47y7LHK+seeNr1lovTxr5sq
	Lk8JOzP9esxK2aofdyb9nOtbEPSodX6vd+pMlo2fl3w1jfmokBpoXqajxFKckWioxVxUnAgA
	LL76h3cDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013 14:54:29 -0600, Alex Williamson wrote:
> On Mon, 2013-10-07 at 10:58 +0900, Cho KyongHo wrote:
> > Patch written by Antonios Motakis <a.motakis@virtualopensystems.com>:
> > 
> > IOMMU groups are expected by certain users of the IOMMU API,
> > e.g. VFIO. Since each device is behind its own System MMU, we
> > can allocate a new IOMMU group for each device.
> > 
> > Reviewd-by: Cho KyongHo <pullip.cho@samsung.com>
> > Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
> > ---
> >  drivers/iommu/exynos-iommu.c |   28 ++++++++++++++++++++++++++++
> >  1 files changed, 28 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index 5025338..24505a0 100644
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> > @@ -1028,6 +1028,32 @@ static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
> >  	return phys;
> >  }
> >  
> > +static int exynos_iommu_add_device(struct device *dev)
> > +{
> > +	struct iommu_group *group;
> > +	int ret;
> > +
> > +	group = iommu_group_get(dev);
> 
> Seems reasonable, my only nit would be whether it's really an error to
> get a group back from the above call.  If devices are always isolated
> and IOMMU groups are always singleton, it would be an error to find one
> already associated with the device.  Right?  Thanks,
> 
Do you mean that calling iommu_group_add_device() with the group that is
returned by the above iommu_group_get() will return -EEXIST?

I didn't think about that.

> Alex

Thank you.

KyongHo.
> 
> > +
> > +	if (!group) {
> > +		group = iommu_group_alloc();
> > +		if (IS_ERR(group)) {
> > +			dev_err(dev, "Failed to allocate IOMMU group\n");
> > +			return PTR_ERR(group);
> > +		}
> > +	}
> > +
> > +	ret = iommu_group_add_device(group, dev);
> > +	iommu_group_put(group);
> > +
> > +	return ret;
> > +}
> > +
> > +static void exynos_iommu_remove_device(struct device *dev)
> > +{
> > +	iommu_group_remove_device(dev);
> > +}
> > +
> >  static struct iommu_ops exynos_iommu_ops = {
> >  	.domain_init = &exynos_iommu_domain_init,
> >  	.domain_destroy = &exynos_iommu_domain_destroy,
> > @@ -1036,6 +1062,8 @@ static struct iommu_ops exynos_iommu_ops = {
> >  	.map = &exynos_iommu_map,
> >  	.unmap = &exynos_iommu_unmap,
> >  	.iova_to_phys = &exynos_iommu_iova_to_phys,
> > +	.add_device = &exynos_iommu_add_device,
> > +	.remove_device = &exynos_iommu_remove_device,
> >  	.pgsize_bitmap = SECT_SIZE | LPAGE_SIZE | SPAGE_SIZE,
> >  };
> >  
> 
> 
> 

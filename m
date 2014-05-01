Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbaEAOKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 10:10:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18207 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaEAOKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 10:10:52 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-c8-536255ebc7ac
Date: Thu, 01 May 2014 23:10:50 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        prathyush.k@samsung.com, grundler@chromium.org, joro@8bytes.org,
        tomasz.figa@gmail.com, joshi@samsung.com, sachin.kamat@linaro.org,
        s.nawrocki@samsung.com, Varun.Sethi@freescale.com,
        a.motakis@virtualopensystems.com, t.figa@samsung.com,
        rahul.sharma@samsung.com
Subject: Re: [PATCH v12 18/31] iommu/exynos: allow having multiple System MMUs
 for a master H/W
Message-id: <20140501231050.81390a28ca44f97499a5e22e@samsung.com>
In-reply-to: <535E2F96.908@linaro.org>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
 <1398584283-22846-19-git-send-email-shaik.ameer@samsung.com>
 <535E2F96.908@linaro.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t8zI93XoUnBBqcmKFrcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLf4vusLu0XvgqtsFpseX2O1uLxrDpvFjPP7mCwurNjIbjFl0WFWi8Nv
	2lktTv7pZbQ48nA3u8X6Ga9ZLFbt+sNo0f53L5vFzFtrWByEPZ4cnMfkMbvhIovHv8P9TB47
	Z91l97hzbQ+bx+Yl9R6Tbyxn9OjbsorR4/MmOY8rR88wBXBFcdmkpOZklqUW6dslcGVcOnqJ
	qeCkQEXD65dsDYz/eLoYOTkkBEwkHtz/wAxhi0lcuLeerYuRi0NIYBmjxKzWiywwRUvPfmaC
	SCxilGjfMokVwpnMJPHh3R+wdhYBVYndD36D2WwCWhKr5x5nBLFFBHQkHizaywLSwCzQwCKx
	tX0WUBEHh7BAosSTqZUgNbwCjhLtPztZQWxOATWJI/8msMFtu/C3lwniDAuJC00d7BANghI/
	Jt8DO48ZaNnmbU2sELa8xOY1b5lBmiUEjnBIHOzqZoe4TkDi2+RDLCCLJQRkJTYdgPpZUuLg
	ihssExjFZiEZOwvJ2FlIxi5gZF7FKJpakFxQnJReZKJXnJhbXJqXrpecn7uJEZIgJuxgvHfA
	+hBjMtDKicxSosn5wASTVxJvaGxmZGFqYmpsZG5pRpqwkjiv2qOkICGB9MSS1OzU1ILUovii
	0pzU4kOMTBycUg2MHisaXiufiVRUPiOz4SvbtaLYPX+8T+0rrjmpoHLqVO+qTl3XR9saCqbr
	dXRmvOGdczB02kmmrvzilPOus2cz1TE2XNBdVP19/j/eGTciSviKxJYVzZ9jf3H5ZIl0vb2O
	n1l5p4Ruf7q5VWSK5nuNgELXy/+0Hrr8mM259ZRepMrMxpezbiZ/V2Ipzkg01GIuKk4EAEys
	L9EmAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsVy+t9jAd3XoUnBBnMapC3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFt83/WF3aJ3wVU2i02Pr7FaXN41h81ixvl9TBYXVmxkt5iy6DCrxeE3
	7awWJ//0Mlocebib3WL9jNcsFqt2/WG0aP+7l81i5q01LA7CHk8OzmPymN1wkcXj3+F+Jo+d
	s+6ye9y5tofNY/OSeo/JN5YzevRtWcXo8XmTnMeVo2eYAriiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4BeU1IoS8wpBQoFJBYXK+nbYZoQGuKm
	awHTGKHrGxIE12NkgAYS1jFmXDp6iangpEBFw+uXbA2M/3i6GDk5JARMJJae/cwEYYtJXLi3
	nq2LkYtDSGARo0T7lkmsEM5kJokP7/4wg1SxCKhK7H7wG8xmE9CSWD33OCOILSKgI/Fg0V4W
	kAZmgQYWia3ts4CKODiEBRIlnkytBKnhFXCUaP/ZyQpicwqoSRz5NwFh24W/vVBnWEhcaOpg
	h2gQlPgx+R4LiM0MtGzztiZWCFteYvOat8wTGAVmISmbhaRsFpKyBYzMqxhFUwuSC4qT0nON
	9IoTc4tL89L1kvNzNzGC088z6R2MqxosDjEKcDAq8fBOYEsMFmJNLCuuzD3EKMHBrCTCO08t
	KViINyWxsiq1KD++qDQntfgQYzIwOCYyS4km5wNTY15JvKGxiZmRpZGZhZGJuTlpwkrivAdb
	rQOFBNITS1KzU1MLUotgtjBxcEo1MPKEvg3fY2DpG7TnqGzewkt+qvu/Nu7b7uyzZaFh2q0l
	nAfZ1kwR3+ftfvQD2/9gh+ktpj7tm6JbpnetNd/9mL9S+gnvg0WHtnPqyf0W4z/0qqdtVvG6
	DYvLTHc4nzYsrnvvp7Av2iPPK1Pu0/V3sm+sH8q1Pzb48Nc0SMu1KKrjgkakv1ighBJLcUai
	oRZzUXEiAOSf48+DAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2014 16:08:14 +0530, Tushar Behera wrote:
> On 04/27/2014 01:07 PM, Shaik Ameer Basha wrote:
> > From: Cho KyongHo <pullip.cho@samsung.com>
> > 
> > Some master device descriptor like fimc-is which is an abstraction
> > of very complex H/W may have multiple System MMUs. For those devices,
> > the design of the link between System MMU and its master H/W is needed
> > to be reconsidered.
> > 
> > A link structure, sysmmu_list_data is introduced that provides a link
> > to master H/W and that has a pointer to the device descriptor of a
> > System MMU. Given a device descriptor of a master H/W, it is possible
> > to traverse all System MMUs that must be controlled along with the
> > master H/W.
> > 
> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> 
> Since you are posting the patches, you should also add your
> Signed-of-by.
>
> > ---
> >  drivers/iommu/exynos-iommu.c |  545 ++++++++++++++++++++++++++----------------
> >  1 file changed, 335 insertions(+), 210 deletions(-)
> > 
> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
> > index fefedec3..c2e6365 100755
> > --- a/drivers/iommu/exynos-iommu.c
> > +++ b/drivers/iommu/exynos-iommu.c
> 
> [ ... ]
> 
> >  static int sysmmu_pm_genpd_save_state(struct device *dev)
> > @@ -1215,7 +1349,7 @@ static int sysmmu_pm_genpd_save_state(struct device *dev)
> >  		ret = cb(dev);
> >  
> >  	if (ret == 0)
> > -		sysmmu_save_state(client->sysmmu);
> > +		sysmmu_save_state(dev);
> >  
> 
> client is now unused, remove the variable.
> 
> >  	return ret;
> >  }
> > @@ -1238,13 +1372,13 @@ static int sysmmu_pm_genpd_restore_state(struct device *dev)
> >  	if (!cb && dev->driver && dev->driver->pm)
> >  		cb = dev->driver->pm->runtime_resume;
> >  
> > -	sysmmu_restore_state(client->sysmmu);
> > +	sysmmu_restore_state(dev);
> >  
> >  	if (cb)
> >  		ret = cb(dev);
> >  
> >  	if (ret)
> > -		sysmmu_save_state(client->sysmmu);
> > +		sysmmu_restore_state(dev);
> >  
> 
> client is now unused, remove the variable.
> 

Ok.

Thanks.

KyongHo

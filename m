Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab3EUDxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 23:53:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:58438 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3EUDxi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 23:53:38 -0400
X-AuditID: cbfee691-b7fef6d000002d62-a2-519aefc01403
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <519AEFC3.1080004@samsung.com>
Date: Tue, 21 May 2013 12:53:39 +0900
From: =?UTF-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
To: Lars-Peter Clausen <lars@metafoo.de>, Inki Dae <inki.dae@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: Re: [PATCH] drm/exynos: exynos_hdmi: Pass correct pointer to free_irq()
References: <1369071126-7020-1-git-send-email-lars@metafoo.de>
In-reply-to: <1369071126-7020-1-git-send-email-lars@metafoo.de>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsWyRsSkSPfg+1mBBlvfMFv0njvJZHHl63s2
	i0n3J7BYvLh3kcXibNMbdoslk+ezWlzeNYfNYsbkl2wOHB7bvz1g9bjffZzJY8mbQ6wefVtW
	MXp83iQXwBrFZZOSmpNZllqkb5fAlXHh7jm2gpucFTdm7GJpYHzA3sXIySEhYCKxunUXM4Qt
	JnHh3nq2LkYuDiGBpYwS19a0McEUzZgzkRUiMZ1RouXEBDaQBK+AoMSPyfdYQGxmAXWJSfMW
	MUPYIhK/bs2EimtLLFv4mhmi+QWjxIG9axghmrUkPnY3gTWwCKhKtJ08BBZnEzCX6Px4CWyB
	kICCxJWJx4BO5eAQFQiT2Lk5HSQsIuApcWl+IxPITGaBp4wS6/9uBbtUWCBA4uWL38wQvXYS
	beePgx3BKWAv8eL6f7APJATesku07mtlglgsIPFt8iEWkAUSArISmw5Ag0JS4uCKGywTGCVm
	IflzFpI/ZyH5cxaSPxcwsqxiFE0tSC4oTkovMtUrTswtLs1L10vOz93ECIzl0/+eTdzBeP+A
	9SHGZKD1E5mlRJPzgakgryTe0NjMyMLUxNTYyNzSjDRhJXFe9RbrQCGB9MSS1OzU1ILUovii
	0pzU4kOMTBycUg2MS4r+Oxq0LhM8PXFqvtaVK0zT12zf0JXLMvXLp8WrWU221BZ/OyZwwk6p
	+uYDaUOL7OqM3BtN++Z9nRB06nhArHxcanmvKB+vb+plHsWP3lMfn9rvG8q5TSXg0xcHT4/d
	/Qs9/E+28l+aXs21NNK/2W3/LqVo9guqM9427vkexsXTv77R3e+wEktxRqKhFnNRcSIAPvRi
	8vsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQd0D72cFGrROtbDoPXeSyeLK1/ds
	FpPuT2CxeHHvIovF2aY37BZLJs9ntbi8aw6bxYzJL9kcODy2f3vA6nG/+ziTx5I3h1g9+ras
	YvT4vEkugDWqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA
	1y0zB+gYJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPG1d/zGAuOclbc
	bExoYDzD3sXIySEhYCIxY85EVghbTOLCvfVsXYxcHEIC0xklWk5MYANJ8AoISvyYfI+li5GD
	g1lAXuLIpWyQMLOAusSkeYuYIepfMEoc2LuGEaJeS+JjdxMziM0ioCrRdvIQWJxNwFyi8+Ml
	sJlCAgoSVyYeYweZKSoQJrFzczpIWETAU+LS/EYmkJnMAk8ZJdb/3coEkhAWCJB4+eI3M0Sv
	nUTb+eMsIDangL3Ei+v/WScwCs5CcuoshFNnITl1ASPzKkbR1ILkguKk9FxDveLE3OLSvHS9
	5PzcTYzgmH8mtYNxZYPFIUYBDkYlHl4Bw1mBQqyJZcWVuYcYJTiYlUR4vzcDhXhTEiurUovy
	44tKc1KLDzEmAz06kVlKNDkfmI7ySuINjU3MjCyNzA0tjIzNSRNWEuc90GodKCSQnliSmp2a
	WpBaBLOFiYNTqoGR4Yvtjn+dDedeHhWcWrLNt/oAO5f23pM/8nXSzk1OtHjqMLdab0e8wYE9
	WVLrX7+TLpaf7HR6+0azH1r3jm8KvaF2w2n59+PTry10Vn4+hTXpnD8To0Ivm6PZPpvrT24I
	pT75k/tk3Y2di6Qe7X+hYd24032F1tu4t2y2v1LPW1XLfNWZ0vyhQImlOCPRUIu5qDgRAPui
	S8o9AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good point,

On 2013년 05월 21일 02:32, Lars-Peter Clausen wrote:
> free_irq() expects the same pointer that was passed to request_threaded_irq(),
> otherwise the IRQ is not freed.
> 
> The issue was found using the following coccinelle script:
> 
> <smpl>
> @r1@
> type T;
> T devid;
> @@
> request_threaded_irq(..., devid)
> 
> @r2@
> type r1.T;
> T devid;
> position p;
> @@
> free_irq@p(..., devid)
> 
> @@
> position p != r2.p;
> @@
> *free_irq@p(...)
> </smpl>
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>

> ---
>  drivers/gpu/drm/exynos/exynos_hdmi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
> index bbfc384..7e99853 100644
> --- a/drivers/gpu/drm/exynos/exynos_hdmi.c
> +++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
> @@ -2082,7 +2082,7 @@ static int hdmi_remove(struct platform_device *pdev)
>  
>  	pm_runtime_disable(dev);
>  
> -	free_irq(hdata->irq, hdata);
> +	free_irq(hdata->irq, ctx);
>  
>  
>  	/* hdmiphy i2c driver */
> 

-- 
Seung-Woo Kim
Samsung Software R&D Center
--


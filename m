Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbaGIOrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:47:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51194 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbaGIOrv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:47:51 -0400
X-AuditID: cbfee690-b7fb56d000003439-72-53bd5615af9c
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <53BD5615.8060900@samsung.com>
Date: Wed, 09 Jul 2014 23:47:49 +0900
From: Inki Dae <inki.dae@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 00/12] drm/exynos/ipp: image post processing improvements,
 part three
References: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1404393037-17299-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsWyRsSkSFc0bG+wweN96ha31p1jtbjy9T2b
	xYt7F1kszja9Ybe4vGsOm8WM8/uYLNYeuctuMWPySzYHDo/73ceZPPq2rGL0+LxJLoA5issm
	JTUnsyy1SN8ugSvj2+b1rAUXuCp2/+9jbGC8zdHFyMkhIWAi8bTnPCuELSZx4d56ti5GLg4h
	gaWMEr+ezmOHKdp5eAsLRGI6o8S/aYvAOngFBCV+TL7HAmIzC6hLTJq3iBnCFpE4dmoVE4St
	LbFs4WtmiOZXjBIfDzxkgmjWkng+dzaQzcHBIqAq0XyeCyTMBmROXHGfDcQWFQiTePFqF9hM
	EaD5s0/eAZvDLHCGSeLkgTWMIAlhgWiJOQ9fg80UEnCWWLtkLlgzp4CLxKGZSxlBGiQETrFL
	7L8+ByzBIiAg8W3yIRaQxRICshKbDjBDfCkpcXDFDZYJjOKzkPw2C8lvs5D8NgvJbwsYWVYx
	iqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBMbn6X/PJuxgvHfA+hBjMtD6icxSosn5wPjOK4k3
	NDYzsjA1MTU2Mrc0I01YSZxX7VFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGxWr/DHKK
	nJoY3KI2dN3NW7W2/UdHxoKnsW0H9yQfLilXbOFax2tc+r1zJ5vYN67exTNOzb73Y8pRnlXN
	xzKkvgsX/X+wPfuMeKpkXzWPagj/WVtBvUNfTwsu421MNlDb/al/o3jn/7qkD7Lvuk7eOtsQ
	350VJD/XWbl45rQH1qx/mLfsvCmpxFKckWioxVxUnAgAiidILeUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jQV3RsL3BBrs75S1urTvHanHl63s2
	ixf3LrJYnG16w25xedccNosZ5/cxWaw9cpfdYsbkl2wOHB73u48zefRtWcXo8XmTXABzVAOj
	TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QCUoKZYk5
	pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjDvfPjIV7OKqeLnUqIHxKEcXIyeH
	hICJxM7DW1ggbDGJC/fWs3UxcnEICUxnlPg3bRErSIJXQFDix+R7QEUcHMwC8hJHLmWDhJkF
	1CUmzVvEDFH/ilHi44GHTBD1WhLP585mAqlnEVCVaD7PBRJmAzInrrjPBmKLCoRJvHi1ixnE
	FgGaM/vkHbA5zAJnmCROHljDCJIQFoiWmPPwNdhMIQFnibVL5oI1cwq4SByauZRxAqPALCTn
	zUI4bxaS8xYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7jZ9I7GFc1WBxiFOBgVOLh
	VeDZEyzEmlhWXJl7iFGCg1lJhNfVeW+wEG9KYmVValF+fFFpTmrxIUZToOcmMkuJJucDU0xe
	SbyhsYmZkaWRuaGFkbG5kjjvwVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQbGcJNaH/5cs1eis2T6
	0hv2Pr7mcVaNa/o6Sfdod8+GRWy3Z2090q3heXFBi84JmwUSc94d4L0qqRIkl6vL8PVZzUW1
	BbVvnu74O6FMVeTVR0mBQwelZPlktgV+afaeks3+Rl0spmb5YVMrlSaVFqEdy9UWa1TVHfsl
	udHXwHCJbqRhrk/ZwRwlluKMREMt5qLiRABG+BRU+QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 07월 03일 22:10, Andrzej Hajda wrote:
> This set of independent patches contains various improvement and fixes
> for exynos_drm ipp framework.
> The patchset is based on exynos-drm-next branch.
> 

Did you test ipp module using libdrm? If so, can you share the app? I
would try to test this patch series before merging them. Mainline libdrm
has no any ipp interfaces.

Thanks,
Inki Dae

> Regards
> Andrzej
> 
> 
> Andrzej Hajda (12):
>   drm/exynos/ipp: remove type casting
>   drm/exynos/ipp: remove unused field from exynos_drm_ipp_private
>   drm/exynos/ipp: remove struct exynos_drm_ipp_private
>   drm/exynos/ipp: correct address type
>   drm/exynos/ipp: remove temporary variable
>   drm/exynos/ipp: remove incorrect checks of list_first_entry result
>   drm/exynos/ipp: simplify memory check function
>   drm/exynos/ipp: remove useless registration checks
>   drm/exynos/ipp: simplify ipp_find_obj
>   drm/exynos/ipp: remove redundant messages
>   drm/exynos/ipp: simplify ipp_create_id
>   drm/exynos/ipp: simplify ipp_find_driver
> 
>  drivers/gpu/drm/exynos/exynos_drm_drv.h |   7 +-
>  drivers/gpu/drm/exynos/exynos_drm_ipp.c | 259 +++++++++-----------------------
>  drivers/gpu/drm/exynos/exynos_drm_ipp.h |   4 +-
>  3 files changed, 73 insertions(+), 197 deletions(-)
> 


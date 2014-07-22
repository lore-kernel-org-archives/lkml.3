Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbaGVNmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:42:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:15006 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaGVNmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:42:04 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7fef6d000003970-d1-53ce6a2a3ff9
Content-transfer-encoding: 8BIT
Message-id: <53CE6A2A.7090602@samsung.com>
Date: Tue, 22 Jul 2014 22:42:02 +0900
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
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsWyRsSkQFcr61ywwfENRha31p1jtbjy9T2b
	xYt7F1kszja9Ybe4vGsOm8WM8/uYLNYeuctuMWPySzYHDo/73ceZPPq2rGL0+LxJLoA5issm
	JTUnsyy1SN8ugStjya5jjAXTOSsO3N7M2sB4mL2LkZNDQsBEYuuUDcwQtpjEhXvr2boYuTiE
	BJYySrw628QMU/R11R1WiMR0RonOF7MYQRK8AoISPybfY+li5OBgFpCXOHIpGyTMLKAuMWne
	ImaI+leMEu9/PGGGqNeSaOn9zAZiswioSnQemQo2hw3InrjiPlhcVCBM4sWrXWD1IkCDZp+8
	AzaIWeAMk8TJA2vAGoQFoiXmPHzNBGILCThLrF0yF6yZU8BF4tDMpYwgDRICp9glWr+8ZIHY
	JiDxbfIhsEslBGQlNh2A+kxS4uCKGywTGMVmIflnFsI/s5D8s4CReRWjaGpBckFxUnqRsV5x
	Ym5xaV66XnJ+7iZGYLSd/vesfwfj3QPWhxiTgTZOZJYSTc4HRmteSbyhsZmRhamJqbGRuaUZ
	acJK4rz3HyYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBUnhD3IHnuTsVkRSm11zyTPwiE
	VrWzBThZVXp1bMkwzFgRVvTYpjt9zdPwoF+hxwwTw3++i3fz5lBe9TZxv+wkiawv6vW3v4TY
	L13b/qXQ3qklIJNh13KRMxMFRNhE71WscpQpnBBjXno6lrHl0PPStxH1LX/SPqy78CiTf+5H
	+6/3la8dCFdiKc5INNRiLipOBADVerZKzAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t9jQV2trHPBBnM/aFncWneO1eLK1/ds
	Fi/uXWSxONv0ht3i8q45bBYzzu9jslh75C67xYzJL9kcODzudx9n8ujbsorR4/MmuQDmqAZG
	m4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygE5QUyhJz
	SoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGUt2HWMsmM5ZceD2ZtYGxsPsXYyc
	HBICJhJfV91hhbDFJC7cW8/WxcjFISQwnVGi88UsRpAEr4CgxI/J91i6GDk4mAXkJY5cygYJ
	MwuoS0yat4gZov4Vo8T7H0+YIeq1JFp6P7OB2CwCqhKdR6aCzWEDsieuuA8WFxUIk3jxahdY
	vQjQoNkn74ANYhY4wyRx8sAasAZhgWiJOQ9fM4HYQgLOEmuXzAVr5hRwkTg0cynjBEaBWUju
	m4Vw3ywk9y1gZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzLz6R3MK5qsDjEKMDBqMTD
	O0HxbLAQa2JZcWXuIUYJDmYlEd7UxHPBQrwpiZVVqUX58UWlOanFhxhNgb6byCwlmpwPTDN5
	JfGGxiZmRpZG5oYWRsbmSuK8B1utA4UE0hNLUrNTUwtSi2D6mDg4pRoYjUMqrBojCn0tcw+v
	WaJ8RKrz+IOTb978bps5d+Oqc++frvDyn5vmtHzmvBdzWM6rf/768syClk3HDhowGfo1HTzQ
	EFh64uHMudz5fpnrS/Q9mkp5JHRZ2tiVGWTilyhnr/4ZynzpdvZ94aWz3vp+ndTuwfp/Yvy/
	TzoTrn/4MPtBiqrD4mku55RYijMSDbWYi4oTAZdu4yn7AgAA
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

Applied.

Thanks,
Inki Dae

> 
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653AbaJ3Mjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:39:47 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:28083 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759060AbaJ3Mjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:39:43 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-7d-5452318d5b0d
Message-id: <5452318C.1030107@samsung.com>
Date: Thu, 30 Oct 2014 13:39:40 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Inki Dae <inki.dae@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "open list:DRM DRIVERS FOR E..." <dri-devel@lists.freedesktop.org>,
        "moderated list:ARM/S5P EXYNOS AR..." 
	<linux-samsung-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] drm/exynos/dsi: remove global display variable
References: <1412683271-15835-1-git-send-email-a.hajda@samsung.com>
In-reply-to: <1412683271-15835-1-git-send-email-a.hajda@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t/xy7q9hkEhBi9+KVpc+fqezWLS/Qks
	Fi/uXWSx6F1wlc3ibNMbdovLu+awWcw4v4/JYu2Ru+wWMya/ZHPg9LjffZzJo2/LKkaPz5vk
	ApijuGxSUnMyy1KL9O0SuDKOH3zDVPCIo+J/X1ED4wT2LkZODgkBE4nvnW+YIWwxiQv31rOB
	2EICSxklji3w7GLkArI/MUp0/TnJ2sXIwcEroCWxZrc5SA2LgKrEj1WPwOrZBDQl/m6+CWaL
	CkRIXFkzhxHE5hUQlPgx+R4LiC0ioCyxal87O8hMZoGpzBIXFvWAJYQF3CUerV7DArHYWWLy
	6a1MIDangIvEvA2v2ED2MgvoSdy/qAUSZhaQl9i85i3zBEaBWUhWzEKomoWkagEj8ypG0dTS
	5ILipPRcQ73ixNzi0rx0veT83E2MkPD+soNx8TGrQ4wCHIxKPLwOGwNChFgTy4orcw8xSnAw
	K4nwHtUJChHiTUmsrEotyo8vKs1JLT7EyMTBKdXAKNFw/fC56t9Wj6wfzb/TcUv7PfsyBgkT
	fkvuHHE+c67lrzo2MV0U9n/51VFZcGl6w+dOjqt/vXL99M7+vV4Rf0Wq/V2z6cw9n0oW9y71
	/Xjk8bl74QIJFpGKtf/97gQuPWRQaMNs3jx5+hbd+ma9hAWLV2u7v1EpvmN8wKTlkce9fT/t
	7/66ocRSnJFoqMVcVJwIABeGfT9NAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 02:01 PM, Andrzej Hajda wrote:
> Hi Inki,
>
> Many Exynos DRM drivers uses global variables to represent associated devices
> in Exynos DRM internal framework. It is quite confusing, it adds data duplication
> and finally it does not allow to handle more than one device in system.
> It seems better to embed such structures in private context of the device.

Gently ping.

Regards
Andrzej

>
> The patchset is based on exynos_drm_next plus my patch [1]:
> 'drm/exynos: remove explicit encoder/connector de-initialization'.
>
> If the patchset is OK for you I can prepare similar patches for other Exynos DRM components.
>
> [1]: https://lkml.org/lkml/2014/9/22/148
>
> Regards
> Andrzej
>
>
> Andrzej Hajda (4):
>   drm/exynos/dsi: remove global variable exynos_dsi_display
>   drm/exynos/dsi: simplify device pointer evaluation
>   drm/exynos/dsi: remove redundant encoder field
>   drm/exynos/dsi: stop using display->ctx pointer
>
>  drivers/gpu/drm/exynos/exynos_drm_dsi.c | 96 ++++++++++++++++-----------------
>  1 file changed, 47 insertions(+), 49 deletions(-)
>


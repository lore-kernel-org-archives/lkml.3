Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab3LRPv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:51:58 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18837 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab3LRPvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:51:55 -0500
X-AuditID: cbfec7f5-b7f6f6d000005b3b-57-52b1c49949e3
From: Tomasz Figa <t.figa@samsung.com>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-pm@vger.kernel.org, naveenkrishna.ch@gmail.com, rui.zhang@intel.com,
        eduardo.valentin@ti.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, amit.daniel@samsung.com,
        kgene.kim@samsung.com, devicetree@vger.kernel.org,
        b.zolnierkie@samsung.com, cpgs@samsung.com
Subject: Re: [PATCH v11 2/4] thermal: samsung: change base_common to more
 meaningful base_second
Date: Wed, 18 Dec 2013 16:51:37 +0100
Message-id: <2079238.D0LMFQmTKa@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <1386657716-21572-1-git-send-email-ch.naveen@samsung.com>
References: <1378268629-2886-2-git-send-email-ch.naveen@samsung.com>
 <1386657716-21572-1-git-send-email-ch.naveen@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/xa7ozj2wMMth0h9Oi4WqIxcYZ61kt
	7j4/zGjx8pCmxfwj51gt1uz/yWTRu+Aqm8XlXXPYLD73HmG0mHF+H5PFom3/mS2ePOxjc+Dx
	2DnrLrvH4j0vmTz6tqxi9Dh+YzuTx+dNcgGsUVw2Kak5mWWpRfp2CVwZZz8fYCuYw1nxf/px
	pgbGWexdjJwcEgImEldmHGGFsMUkLtxbz9bFyMUhJLCUUeLFvw4mkISQQBeTxPZZViA2m4Ca
	xOeGR2wgtghQ8/FXZ9hBGpgFljJJzF+2iLmLkYNDWCBJYsFbF5AaFgFViZudr8HqeQU0JX60
	rmIBsfkF1CXebXsKNl9UwE3ixb4tYAdxAtlTjnyGOqKBUeL+jZuMEM2CEj8m3wNrZhaQl9i3
	fyorhK0lsX7ncaYJjIKzkJTNQlI2C0nZAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxgh
	0fJ1B+PSY1aHGAU4GJV4eBf4bAwSYk0sK67MPcQowcGsJMIrtBUoxJuSWFmVWpQfX1Sak1p8
	iJGJg1OqgdH11eEQIz7V/z/zv8o/XPUv5f4eE5dv2T3fuo4uOyVmde9V3Nt9W5gN+7Ydf613
	eWvYJbOs9D+P/+Q8EeTct/FOfOG+xKxVLTlrLPYc2806pWXJRvmVd6uvlZluEFwbEqR5asI8
	RpGjT1vcOtyuXZrxNWnNRkWX1Es2+VW3njyIP/bMv672ZKC1EktxRqKhFnNRcSIAzqXZbnQC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 of December 2013 12:11:56 Naveen Krishna Chatradhi wrote:
> On Exynos5440 and Exynos5420 there are registers common
> across the TMU channels.
> 
> To support that, we introduced a ADDRESS_MULTIPLE flag in the
> driver and the 2nd set of register base and size are provided
> in the "reg" property of the node.
> 
> As per Amit's suggestion, this patch changes the base_common
> to base_second and SHARED_MEMORY to ADDRESS_MULTIPLE.
> 
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Acked-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
> Changes since v10:
> Documentation rephrased as per comments from Tomasz Figa
> 
>  .../devicetree/bindings/thermal/exynos-thermal.txt       |    4 ++--
>  drivers/thermal/samsung/exynos_tmu.c                     |   14 +++++++-------
>  drivers/thermal/samsung/exynos_tmu.h                     |    4 ++--
>  drivers/thermal/samsung/exynos_tmu_data.c                |    2 +-
>  4 files changed, 12 insertions(+), 12 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz


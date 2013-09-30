Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab3I3CDM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 22:03:12 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:45226 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab3I3CDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 22:03:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130930105234.73b5380ec08bf4cc6b2c9677@samsung.com>
References: <003a01cde30b$e13c1910$a3b44b30$%cho@samsung.com>
	<CAOw6vbJfi7UhwxgFKmMzO91fnywWZNTRVDLLSWQOkbbU=C5ndA@mail.gmail.com>
	<20130930093500.ffa527f8f5f004e02a9cb187@samsung.com>
	<CAOw6vbKSQ2xTj7__D5F40vRLxU5Yt1NH4zEp4WcRtB1rVK5gQQ@mail.gmail.com>
	<20130930105234.73b5380ec08bf4cc6b2c9677@samsung.com>
Date: Sun, 29 Sep 2013 19:03:06 -0700
X-Google-Sender-Auth: QmixMZA5XT6-1uAYg-J_UsZhgMc
Message-ID: <CALiw-2HwQvpHCoJw0JyGn87ZV1vuvqMtPv8i+AcVGQHnAKtEJw@mail.gmail.com>
Subject: Re: [PATCH v6 07/12] ARM: EXYNOS: remove system mmu initialization
 from exynos tree
From: Olof Johansson <olof@lixom.net>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Sean Paul <seanpaul@chromium.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Hyunwoong Kim <khw0178.kim@samsung.com>,
        Joerg Roedel <joro@8bytes.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Subash Patel <supash.ramaswamy@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013/9/29 Cho KyongHo <pullip.cho@samsung.com>:

> Ah, I remember that this is merged.
> I agreed to merge this patch because iommu driver need to be completely changed.
> Whenever I change exynos-iommu driver, synchronizing samsung-next and iommu-next
> branches is a big challenge.
> Thus I decided to remove dependencies to samsung-next branch.
> But I didn't know that the rest of the new driver is not merged soon. :(
> I am sorry about that.
>
> new patch (v10) will be posted soon.

Will the v10 patch set be incremental based on v6?

How have you tested v10 on mainline?

Thanks,

-Olof

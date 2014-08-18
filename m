Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaHRL00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:26:26 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37917 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaHRL0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:26:24 -0400
Message-ID: <53F1E2D9.7040101@gmail.com>
Date: Mon, 18 Aug 2014 13:26:17 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        iommu@lists.linux-foundation.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
CC: linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Inki Dae <inki.dae@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 03/29] clk: exynos: add missing smmu_g2d clock and update
 comments
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com> <1407235677-26324-4-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1407235677-26324-4-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.08.2014 12:47, Marek Szyprowski wrote:
> This patch adds missing smmu_g2d clock implementation and updates
> comment about Exynos4 clocks from 278-282 range. Those clocks are
> available on all Exynos4 SoC series, so the misleading comment has been
> removed.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/clk/samsung/clk-exynos4.c   |  1 +
>  include/dt-bindings/clock/exynos4.h | 10 +++++-----
>  2 files changed, 6 insertions(+), 5 deletions(-)

Acked-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

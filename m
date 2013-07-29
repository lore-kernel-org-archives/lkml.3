Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab3G2Gh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 02:37:58 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:61583 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab3G2Gh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 02:37:57 -0400
MIME-Version: 1.0
In-Reply-To: <003c01ce89f3$3abc4bc0$b034e340$@samsung.com>
References: <003c01ce89f3$3abc4bc0$b034e340$@samsung.com>
Date: Mon, 29 Jul 2013 12:07:56 +0530
Message-ID: <CAK9yfHy2btp1W+5-GiVQnkffDnJ-CgqXuAjGktkiKYyf7kKQbQ@mail.gmail.com>
Subject: Re: [PATCH v8 06/12] ARM: dts: Add description of System MMU of
 Exynos SoCs
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Hyunwoong Kim <khw0178.kim@samsung.com>,
        Joerg Roedel <joro@8bytes.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Keyyoung Park <keyyoung.park@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi KyongHo,

On 26 July 2013 16:58, Cho KyongHo <pullip.cho@samsung.com> wrote:
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>  .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |  103 +++++++
>  arch/arm/boot/dts/exynos4.dtsi                     |  122 ++++++++
>  arch/arm/boot/dts/exynos4210.dtsi                  |   25 ++
>  arch/arm/boot/dts/exynos4x12.dtsi                  |   76 +++++
>  arch/arm/boot/dts/exynos5250.dtsi                  |  291 ++++++++++++++++++++
>  5 files changed, 617 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt

This patch does not apply on the mainline Linus' tree (3.11-rc2). Please rebase.

-- 
With warm regards,
Sachin

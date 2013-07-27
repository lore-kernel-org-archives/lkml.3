Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab3G0OGu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 10:06:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43377 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab3G0OGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 10:06:48 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Antonios Motakis'" <a.motakis@virtualopensystems.com>,
        kvmarm@lists.cs.columbia.edu,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>
Subject: Re: [PATCH v8 07/12] iommu/exynos: support for device tree
Date: Sat, 27 Jul 2013 16:06:40 +0200
Message-ID: <1743111.Ek7FldnHal@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <003d01ce89f3$44ec2cf0$cec486d0$@samsung.com>
References: <003d01ce89f3$44ec2cf0$cec486d0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 26 of July 2013 20:28:36 Cho KyongHo wrote:
> This commit adds device tree support for System MMU.
> This also include the following changes and enhancements:
> 
> * use managed device helper functions.
> Simplyfies System MMU device driver.
> 
> * use only a single clock descriptor.
> System MMU device descriptor is seperate if it is imposible to make
> a single clock descriptor to make a device descriptor for a group of
> System MMUs.
> 
> * removed dbgname member from sysmmu_drvdata structure.
> debugging kernel message for a System MMU is distinguisheable with the
> name of device descroptors.
> 
> Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
> ---
>  drivers/iommu/Kconfig        |    5 +-
>  drivers/iommu/exynos-iommu.c |  182
> ++++++++++++++++-------------------------- 2 files changed, 70
> insertions(+), 117 deletions(-)

Whenever you introduce or modify (extend) a device tree binding please 
don't forget about reflecting that in documentation 
(Documentation/devicetree/bindings) and CCing devicetree mailing list 
(devicetree@vger.kernel.org). Both of these steps are necessary to get any 
device tree stuff merged.

Best regards,
Tomasz


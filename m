Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbaELKIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 06:08:48 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:57211 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaELKIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 06:08:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, joro@8bytes.org, t.figa@samsung.com,
        kgene.kim@samsung.com, pullip.cho@samsung.com,
        a.motakis@virtualopensystems.com, grundler@chromium.org,
        s.nawrocki@samsung.com, prathyush.k@samsung.com,
        rahul.sharma@samsung.com, sachin.kamat@linaro.org,
        supash.ramaswamy@linaro.org, varun.sethi@freescale.com,
        joshi@samsung.com, tomasz.figa@gmail.com
Subject: Re: [PATCH v13 00/19] iommu/exynos: Fixes and Enhancements of System MMU driver with DT
Date: Mon, 12 May 2014 12:07:52 +0200
Message-ID: <5576160.rCaFbvon4G@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:oMY7qO7iqEBoDXHm3oGL35mmvngOL4ceng8p3FwLHL/
 GvPf0+Cyr28FL4f0dgLhuRlO1FUdOZp36X66H7FJWVVnq6ZNAK
 Xbqw4yl5A/4Fd6FSDhmtyDge1D9EkW1emGK25gM7YYQ2pu+b81
 2ZteJBKeBfiwA0JJDpUcX7fqLKvMuUFvDMTnIqF7pAIUPWmRT4
 ZrvOIM1dkuyF1uUCdt4CkkbquV933+wWEwQH3BfCeUc2s/kXb7
 1ZHQ9j2g81qBspmPPG6TVtWRlng+ohmMN0Ra5MJiv6WAfT4jgs
 iKaw98H6obTe4ByzhYZjNvXYIcldnZm9YbF+IJ3StZPqg1y257
 8/ODzkzVQ3LjY3l64XHw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 May 2014 11:44:45 Shaik Ameer Basha wrote:
> This is the subset of previous v12 series and includes only the fixes and
> enhancements, leaving out the private DT bindings as discussed in the below thread.
>     -- http://www.gossamer-threads.com/lists/linux/kernel/1918178
> 
> This patch series includes,
> 1] fixes for exynos-iommu driver build break
> 2] includes several bug fixes and enhancements for the exynos-iommu driver
> 3] code to handle multiple exynos sysmmu versions
> 4] adding support for device tree
>         Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt

The patches look good to me, but please add a note into the samsung,sysmmu.txt
file explaining that the binding is incomplete and that it's possible to
change in incompatible ways when we add support for attaching devices to
the IOMMU through the generic IOMMU binding.

	Arnd

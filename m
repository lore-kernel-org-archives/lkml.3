Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaHSLjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:39:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48589 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaHSLjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:39:17 -0400
Message-ID: <53F3375E.6030402@suse.de>
Date: Tue, 19 Aug 2014 13:39:10 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
CC: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Thierry Reding <treding@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ajay Kumar <ajaykumar.rs@samsung.com>
Subject: Re: [PATCH 00/29] Exynos SYSMMU (IOMMU) integration with DT and DMA-mapping
 subsystem
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com> <20140818233201.GL9809@8bytes.org> <53F2E9AD.9030308@samsung.com>
In-Reply-To: <53F2E9AD.9030308@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek and Inki,

Am 19.08.2014 08:07, schrieb Marek Szyprowski:
> On 2014-08-19 01:32, Joerg Roedel wrote:
>> On Tue, Aug 05, 2014 at 12:47:28PM +0200, Marek Szyprowski wrote:
[...]
>>>   33 files changed, 1016 insertions(+), 356 deletions(-)
>> This touches a lot of non-iommu stuff. What is your strategy on getting
>> this in, do you plan to get the non-iommu changes merged first or do you
>> want to collect the respective Acks and merge this all through one tree?
> 
> Those patches are posted as one patchset mainly to demonstrate how to get
> everything to work together. I also posted this as a single patch series
> to get some feedback from other iommu developers, especially all those
> involved in the generic iommu dt bindings.
> 
> For merging, I will split them into smaller series and try to get
> respective acks.

I'm working on 5250 based Spring Chromebook and noticed that v3.17-rc1
got some more iommu support. With the new CONFIG_DRM_EXYNOS_IOMMU=y my
machine stops booting. So I'm wondering, is any of this a fix for 3.17,
or is all of this "unrelated" -next material? Also, are you or someone
working on the respective DT changes for Exynos5?

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg

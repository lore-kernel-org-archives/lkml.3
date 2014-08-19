Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaHSMBj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:01:39 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50558 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbaHSMBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:01:37 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed
X-AuditID: cbfec7f5-b7f776d000003e54-13-53f33c9ee951
Content-transfer-encoding: 8BIT
Message-id: <53F33C9C.1080601@samsung.com>
Date: Tue, 19 Aug 2014 14:01:32 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        Inki Dae <inki.dae@samsung.com>
Cc: Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
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
Subject: Re: [PATCH 00/29] Exynos SYSMMU (IOMMU) integration with DT and
 DMA-mapping subsystem
References: <1407235677-26324-1-git-send-email-m.szyprowski@samsung.com>
 <20140818233201.GL9809@8bytes.org> <53F2E9AD.9030308@samsung.com>
 <53F3375E.6030402@suse.de>
In-reply-to: <53F3375E.6030402@suse.de>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t/xq7rzbD4HGzxqlbJo3lRsceD9QRaL
	v5OOsVs0L17PZjHp/gQWiwX7rS06Z29gt+hdcJXN4mzTG3aLzolL2C2+XHnIZLHp8TVWi8u7
	5rBZzDi/j8ni1PXPbBb/eg8yWpw5fYnV4v+eHewWh9+0s1ocebib3WLVrj+MFrd/8zmIeTw5
	OI/J4/evSYweO2fdZfeY3TGT1WPTqk42j/1z17B7bF5S73H732Nmj8k3ljN6XDnRxOrR2/yO
	zWPL1XYWj74tqxg9Np+u9vi8SS6AP4rLJiU1J7MstUjfLoEr4+HbT+wFMwUqFlx9xNjA2Mbb
	xcjJISFgItG3YQcrhC0mceHeerYuRi4OIYGljBJnFiwDS/AKCEr8mHyPpYuRg4NZQF7iyKVs
	kDCzgJnEl5eHWSHqPzFKvD6ymBGiXkvi0fM3YDaLgKpE+76tLCA2m4ChRNfbLjaQOaICURLH
	vuaBhEWAzI89M1ggZk5hk5jSZQViCwskSPz708ECMX8lo8ScRa/BZnIKqEu8mXyOZQKjwCwk
	581COG8WkvMWMDKvYhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAiJ6a87GJceszrEKMDBqMTD
	q/DlY7AQa2JZcWXuIUYJDmYlEd4O6c/BQrwpiZVVqUX58UWlOanFhxiZODilGhjnLhRVU9n1
	ZPHrw7tOT9CaeND3qvHt5Hsvfp7VF1KJ4S/K8/q9TkSSZcmvNN3LIV7VzpmGPXZ+a5N8uQTW
	MyurSU0Olvt0t3D7dD3ddws/Hjz2f+I0o82eQSfCbqne7+b8xtnlNVH4SqLSsu6Ym6f3z7G4
	cefZSbU/YTt6XGOjl/Z7Z08Lma6vxFKckWioxVxUnAgAshKhaMcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-08-19 13:39, Andreas Färber wrote:
> Hi Marek and Inki,
>
> Am 19.08.2014 08:07, schrieb Marek Szyprowski:
>> On 2014-08-19 01:32, Joerg Roedel wrote:
>>> On Tue, Aug 05, 2014 at 12:47:28PM +0200, Marek Szyprowski wrote:
> [...]
>>>>    33 files changed, 1016 insertions(+), 356 deletions(-)
>>> This touches a lot of non-iommu stuff. What is your strategy on getting
>>> this in, do you plan to get the non-iommu changes merged first or do you
>>> want to collect the respective Acks and merge this all through one tree?
>> Those patches are posted as one patchset mainly to demonstrate how to get
>> everything to work together. I also posted this as a single patch series
>> to get some feedback from other iommu developers, especially all those
>> involved in the generic iommu dt bindings.
>>
>> For merging, I will split them into smaller series and try to get
>> respective acks.
> I'm working on 5250 based Spring Chromebook and noticed that v3.17-rc1
> got some more iommu support. With the new CONFIG_DRM_EXYNOS_IOMMU=y my
> machine stops booting. So I'm wondering, is any of this a fix for 3.17,
> or is all of this "unrelated" -next material?

This is probably a side effect of patch 
3170447c1f264d51b8d1f3898bf2588588a64fdc
("iommu/exynos: Select ARM_DMA_USE_IOMMU"). It added selection of 
ARM_DMA_USE_IOMMU
symbol, on which IOMMU support in Exynos DRM subsystem depends. However 
selecting
this symbol is all that this patch does, without providing any code code 
which
implements real support for ARM DMA IOMMU integration, which is needed 
by Exynos
DRM driver. Please disable CONFIG_DRM_EXYNOS_IOMMU in kernel .config and 
your
system should be bootable again.

> Also, are you or someone
> working on the respective DT changes for Exynos5?

I can prepare DT changes for Exynos5 as well, but first I wanted to 
clarify if
everyone involved in generic IOMMU bindings and Exynos IOMMU driver 
agrees on my
proposal.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


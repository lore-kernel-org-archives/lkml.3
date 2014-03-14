Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbaCNL7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 07:59:38 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:47145 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbaCNL7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 07:59:36 -0400
MIME-Version: 1.0
In-Reply-To: <000e01cf3f7b$6edcdfd0$4c969f70$@samsung.com>
References: <20140314140129.68a41cc1bd9e0a48a198ca13@samsung.com>
	<CAK9yfHzRasE3jroDUZgAa=DN5N=2ZDAxgNiHDCip+f2868BAVQ@mail.gmail.com>
	<000e01cf3f7b$6edcdfd0$4c969f70$@samsung.com>
Date: Fri, 14 Mar 2014 17:29:36 +0530
Message-ID: <CAK9yfHyGfdP+0RKtdSCdU4tO=PX8GbQRQ7ar=ST5B2RenZMMsg@mail.gmail.com>
Subject: Re: [PATCH v11 01/27] iommu/exynos: do not include removed header
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 March 2014 17:19, Cho KyongHo <pullip.cho@samsung.com> wrote:
>> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
>> Sent: Friday, March 14, 2014 7:00 PM
>>
>> On 14 March 2014 10:31, Cho KyongHo <pullip.cho@samsung.com> wrote:
>> > Commit 25e9d28d92 (ARM: EXYNOS: remove system mmu initialization from
>> > exynos tree) removed arch/arm/mach-exynos/mach/sysmmu.h header without
>> > removing remaining use of it from exynos-iommu driver, thus causing a
>> > compilation error.
>> >
>> > This patch fixes the error by removing respective include line
>> > from exynos-iommu.c.
>> >
>> > CC: Tomasz Figa <t.figa@samsung.com>
>> > Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
>> > ---
>> >  drivers/iommu/exynos-iommu.c |    3 +--
>> >  1 file changed, 1 insertion(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
>> > index 0740189..4876d35 100644
>> > --- a/drivers/iommu/exynos-iommu.c
>> > +++ b/drivers/iommu/exynos-iommu.c
>> > @@ -12,6 +12,7 @@
>> >  #define DEBUG
>> >  #endif
>> >
>> > +#include <linux/kernel.h>
>>
>> This change doesn't look related to the patch subject/description.
>>
> Yes. But it is simply added without any side-effect.
> Do you think it should be in a separate patch?.
> Actually, the added line is a redundant.

If it is redundant, then you shouldn't be adding it. If it is
required, then please
mention about the need in the commit description if not a separate patch.

-- 
With warm regards,
Sachin

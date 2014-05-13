Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638AbaEMNdE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:33:04 -0400
Received: from mail-yk0-f180.google.com ([209.85.160.180]:33080 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933504AbaEMNdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:33:00 -0400
MIME-Version: 1.0
In-Reply-To: <5576160.rCaFbvon4G@wuerfel>
References: <1399875304-19948-1-git-send-email-shaik.ameer@samsung.com> <5576160.rCaFbvon4G@wuerfel>
From: Shaik Ameer Basha <shaik.samsung@gmail.com>
Date: Tue, 13 May 2014 19:02:39 +0530
Message-ID: <CAOD6ATou_4aNce-0NVFWOXO66W0dsEva0MQddAqQCqhCGRWxMQ@mail.gmail.com>
Subject: Re: [PATCH v13 00/19] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
To: Arnd Bergmann <arnd@arndb.de>, Joerg Roedel <joro@8bytes.org>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Prathyush <prathyush.k@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        "supash.ramaswamy" <supash.ramaswamy@linaro.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        sunil joshi <joshi@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Varun Sethi <varun.sethi@freescale.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Rahul Sharma <rahul.sharma@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 3:37 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 12 May 2014 11:44:45 Shaik Ameer Basha wrote:
>> This is the subset of previous v12 series and includes only the fixes and
>> enhancements, leaving out the private DT bindings as discussed in the below thread.
>>     -- http://www.gossamer-threads.com/lists/linux/kernel/1918178
>>
>> This patch series includes,
>> 1] fixes for exynos-iommu driver build break
>> 2] includes several bug fixes and enhancements for the exynos-iommu driver
>> 3] code to handle multiple exynos sysmmu versions
>> 4] adding support for device tree
>>         Documentation/devicetree/bindings/iommu/samsung,sysmmu.txt
>
> The patches look good to me, but please add a note into the samsung,sysmmu.txt
> file explaining that the binding is incomplete and that it's possible to
> change in incompatible ways when we add support for attaching devices to
> the IOMMU through the generic IOMMU binding.

Hi Arnd,

Thank you.
If there are no more comments on this series, I can send one more
incremental patch
with the note mentioned in your review comment.

Hi Joerg Roedel,
Can you please add this series to your tree.

Regards,
Shaik Ameer Basha

>
>         Arnd
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu

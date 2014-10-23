Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbaJWQQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:16:36 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:40717 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbaJWQQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:16:07 -0400
MIME-Version: 1.0
In-Reply-To: <20141022152019.GK10074@8bytes.org>
References: <1412158843-8115-1-git-send-email-djkurtz@chromium.org> <20141022152019.GK10074@8bytes.org>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Fri, 24 Oct 2014 00:15:44 +0800
X-Google-Sender-Auth: PtaykxvPLmRI6_C4a85dSADRM5w
Message-ID: <CAGS+omDyKLVqmvVtJBez7SuC_oqkpov1e-ikfLE=NBcY0Mx45A@mail.gmail.com>
Subject: Re: [PATCH 0/3] Rockchip IOMMU driver and devicetree bindings
To: Joerg Roedel <joro@8bytes.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Simon Xue <xxm@rock-chips.com>,
        Grant Grundler <grundler@chromium.org>,
        =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 11:20 PM, Joerg Roedel <joro@8bytes.org> wrote:
> On Wed, Oct 01, 2014 at 06:20:40PM +0800, Daniel Kurtz wrote:
>> Add a driver and devicetree bindings for the IOMMU found in Rockchip RK3288
>> SoCs.
>>
>> Daniel Kurtz (3):
>>   iommu/rockchip: rk3288 iommu driver
>>   dt-bindings: iommu: Add documentation for rockchip iommu
>>   ARM: dts: rk3288: add VOP iommu nodes
>>
>>  .../devicetree/bindings/iommu/rockchip,iommu.txt   |  26 +
>>  arch/arm/boot/dts/rk3288.dtsi                      |  18 +
>>  drivers/iommu/Kconfig                              |  11 +
>>  drivers/iommu/Makefile                             |   1 +
>>  drivers/iommu/rockchip-iommu.c                     | 924 +++++++++++++++++++++
>>  5 files changed, 980 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/iommu/rockchip,iommu.txt
>>  create mode 100644 drivers/iommu/rockchip-iommu.c
>
> Please make sure you also get Acks for the DT bindings. With that and
> the issue I mentioned in the other email fixed, I will apply these
> patches?
>
>
>         Joerg

Hi Joerg,

Thanks for your reviews.
Can you help get these DT bindings Acked?
AFAICT, the DT maintainers are CC'ed on this patch, I'm not sure what
else to do.

Thanks,
-Daniel

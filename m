Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbaLDTaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 14:30:16 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:43585 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921AbaLDTaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 14:30:12 -0500
MIME-Version: 1.0
In-Reply-To: <2556534.qktPW9tbxy@diego>
References: <1417511600-7054-1-git-send-email-mark.yao@rock-chips.com> <2556534.qktPW9tbxy@diego>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Thu, 4 Dec 2014 11:29:51 -0800
X-Google-Sender-Auth: nuBlOE2lHUluZbxCVyz3YLDj9SY
Message-ID: <CAGS+omAqkQaK99OX_uAf2Z6-fep2Euwn112Oj5gFpRca8ZAgew@mail.gmail.com>
Subject: Re: [PATCH v15 0/3] Add drm driver for Rockchip Socs
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Mark Yao <mark.yao@rock-chips.com>, Mark Rutland <mark.rutland@arm.com>,
        linux-doc@vger.kernel.org, Kever Yang <kever.yang@rock-chips.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, David Airlie <airlied@gmail.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        simon xue <xxm@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Dominik Behr <dbehr@chromium.org>,
        =?UTF-8?B?6Zer5a2d5Yab?= <yxj@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
        Rom Lemarchand <romlem@google.com>, xw@rock-chips.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Douglas Anderson <dianders@chromium.org>,
        Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 1:31 AM, Heiko Stübner <heiko@sntech.de> wrote:
> Hi Mark,
>
> Am Dienstag, 2. Dezember 2014, 17:13:20 schrieb Mark Yao:
>> This a series of patches is a DRM Driver for Rockchip Socs, add support
>> for vop devices. Future patches will add additional encoders/connectors,
>> such as eDP, HDMI.
>>
>> The basic "crtc" for rockchip is a "VOP" - Video Output Processor.
>> the vop devices found on Rockchip rk3288 Soc, rk3288 soc have two similar
>> Vop devices. Vop devices support iommu mapping, we use dma-mapping API with
>> ARM_DMA_USE_IOMMU.
>
> [...]
>
>> Changes in v15:
>> - remove depends on ARM_DMA_USE_IOMMU & IOMMU_API which cause
>>   recursive dependency problem

I thought the recommended solution for this was to fix OMAP3 to not
select  ARM_DMA_USE_IOMMU and OMAP_IOMMU, not to drop the 'depends on'
in drm/rockchip?

>> - fix compile problems when build as a module.
>
> maybe you could also already create a new pull request for this version [like
> the last one based on the iommu branch], so that we save time and Dave can
> pull it in easily for testing if he likes.
>
>
> Heiko
>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip

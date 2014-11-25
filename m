Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaKYXNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 18:13:01 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:44573 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaKYXM6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 18:12:58 -0500
MIME-Version: 1.0
In-Reply-To: <23617908.6oA5uRuO3l@diego>
References: <1416447994-9921-1-git-send-email-mark.yao@rock-chips.com>
	<23617908.6oA5uRuO3l@diego>
Date: Wed, 26 Nov 2014 09:12:56 +1000
Message-ID: <CAPM=9tzvvb5U+8KaCO+K6CJi=rwWOkoW+4ZSFW_Oo9gTncvkWA@mail.gmail.com>
Subject: Re: [PATCH v14 0/3] Add drm driver for Rockchip Socs
From: Dave Airlie <airlied@gmail.com>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>
Cc: Mark Yao <mark.yao@rock-chips.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Rob Clark <robdclark@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>, linux-api@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Douglas Anderson <dianders@chromium.org>,
        =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
        dbehr@chromium.org, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>, Eddie Cai <cf@rock-chips.com>,
        simon xue <xxm@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>, yxj@rock-chips.com,
        xw@rock-chips.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 November 2014 at 02:38, Heiko Stübner <heiko@sntech.de> wrote:
> Mark,
>
> Am Donnerstag, 20. November 2014, 09:46:34 schrieb Mark Yao:
>> This a series of patches is a DRM Driver for Rockchip Socs, add support
>> for vop devices. Future patches will add additional encoders/connectors,
>> such as eDP, HDMI.
>>
>> The basic "crtc" for rockchip is a "VOP" - Video Output Processor.
>> the vop devices found on Rockchip rk3288 Soc, rk3288 soc have two similar
>> Vop devices. Vop devices support iommu mapping, we use dma-mapping API with
>> ARM_DMA_USE_IOMMU.
>
> it looks like everybody is more or less happy with this version - in past
> versions responses voicing concerns where quite swift.
>
> As David requested a pull request the last time, it might be time to do so, so
> that we maybe still reach 3.19.
>

I need the iommu changes the drm driver depends on in a stable
maintainer git tree,
I'm not pulling in code I can't build.

I'm happy if the rockchip drm pull stays static and I can pull it in
once the iommu bits
are done.

Dave.

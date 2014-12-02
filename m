Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918AbaLBDxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 22:53:07 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:50135 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850AbaLBDxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 22:53:04 -0500
MIME-Version: 1.0
In-Reply-To: <5476CC59.6080607@rock-chips.com>
References: <1416447994-9921-1-git-send-email-mark.yao@rock-chips.com>
	<5476CC59.6080607@rock-chips.com>
Date: Tue, 2 Dec 2014 13:53:01 +1000
Message-ID: <CAPM=9tzaapZr7UoOu0J5F55tWt36f4SShM8bHXdWkGyED5pd5A@mail.gmail.com>
Subject: Re: [GIT PULL] core drm support for Rockchip SoCs v14
From: Dave Airlie <airlied@gmail.com>
To: Mark yao <mark.yao@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2014 at 17:01, Mark yao <mark.yao@rock-chips.com> wrote:
> Hi Dave
>
>     this pull request is for rockchip drm v14, based on Joerg's iommu
> arm/rockchip branch.
>
> The following changes since commit 656d7077d8ffd1c2492d4a0a354367ab2e545059:
>
>   dt-bindings: iommu: Add documentation for rockchip iommu (2014-11-03
> 17:29:09 +0100)
>
> are available in the git repository at:
>
>   https://github.com/markyzq/kernel-drm-rockchip.git drm_iommu
>
> for you to fetch changes up to aab18af3a93353bc43897b716fd7e12d5998b9bc:
>
>   dt-bindings: video: Add documentation for rockchip vop (2014-11-27

For list prosperity, now that I can build this, I find it can't build
as a module

 LD [M]  drivers/gpu/drm/rockchip/rockchipdrm.o
drivers/gpu/drm/rockchip/rockchip_drm_vop.o: In function `init_module':
rockchip_drm_vop.c:(.init.text+0x0): multiple definition of `init_module'
drivers/gpu/drm/rockchip/rockchip_drm_drv.o:rockchip_drm_drv.c:(.init.text+0x0):
first defined here
drivers/gpu/drm/rockchip/rockchip_drm_vop.o: In function `cleanup_module':
rockchip_drm_vop.c:(.exit.text+0x0): multiple definition of `cleanup_module'
drivers/gpu/drm/rockchip/rockchip_drm_drv.o:rockchip_drm_drv.c:(.exit.text+0x0):
first defined here

not sure what your plan for the vop.c variant should be, is it an extra module,
or just part of rockchipdrm?

Dave.

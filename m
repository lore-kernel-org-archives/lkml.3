Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaK0CMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 21:12:36 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:35384 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbaK0CMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 21:12:32 -0500
MIME-Version: 1.0
In-Reply-To: <54768107.2090402@rock-chips.com>
References: <1416447994-9921-1-git-send-email-mark.yao@rock-chips.com>
	<23617908.6oA5uRuO3l@diego>
	<CAPM=9tzvvb5U+8KaCO+K6CJi=rwWOkoW+4ZSFW_Oo9gTncvkWA@mail.gmail.com>
	<1557742.FTdLsE0bVs@diego>
	<20141126073430.GD3156@suse.de>
	<CAPM=9tzhZLShA5=ShGTKhyZR6ddKycQDUWBZxXpUBb+1tGp-mQ@mail.gmail.com>
	<54768107.2090402@rock-chips.com>
Date: Thu, 27 Nov 2014 12:12:30 +1000
Message-ID: <CAPM=9tyZpDEPcipYDq2_qdQ9zK2bnPFYTUL2qDvAd7QoUOm-QQ@mail.gmail.com>
Subject: Re: [PATCH v14 0/3] Add drm driver for Rockchip Socs
From: Dave Airlie <airlied@gmail.com>
To: Mark yao <mark.yao@rock-chips.com>
Cc: Joerg Roedel <jroedel@suse.de>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
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

>>
>>
> Hi Dave
>     Do you mean that I need send you a branch, based on drm-next, merge with
> iommu tree and rockchip drm?

Yes, grab drm-next, git pull the arm/rockchip branch from Joerg's
tree, put rockchip drm
patches on top, send me pull request.

I'll validate it then.

Dave.

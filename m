Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaKZHek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 02:34:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752143AbaKZHeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 02:34:37 -0500
Date: Wed, 26 Nov 2014 08:34:30 +0100
From: Joerg Roedel <jroedel@suse.de>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Dave Airlie <airlied@gmail.com>, Mark Yao <mark.yao@rock-chips.com>,
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
        =?iso-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>,
        dbehr@chromium.org, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>, Eddie Cai <cf@rock-chips.com>,
        simon xue <xxm@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>, yxj@rock-chips.com,
        xw@rock-chips.com
Subject: Re: [PATCH v14 0/3] Add drm driver for Rockchip Socs
Message-ID: <20141126073430.GD3156@suse.de>
References: <1416447994-9921-1-git-send-email-mark.yao@rock-chips.com>
 <23617908.6oA5uRuO3l@diego>
 <CAPM=9tzvvb5U+8KaCO+K6CJi=rwWOkoW+4ZSFW_Oo9gTncvkWA@mail.gmail.com>
 <1557742.FTdLsE0bVs@diego>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1557742.FTdLsE0bVs@diego>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 01:37:51AM +0100, Heiko Stübner wrote:
> 
> Joerg, is your arm/rockchip branch [0] considered stable?
> 
> [0] https://git.kernel.org/cgit/linux/kernel/git/joro/iommu.git/log/?h=arm/rockchip
>

Yes, this branch will not be rebased. It can be pulled into another
tree.


	Joerg

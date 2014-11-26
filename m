Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaKZWxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:53:48 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:63229 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaKZWxp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:53:45 -0500
MIME-Version: 1.0
In-Reply-To: <20141126073430.GD3156@suse.de>
References: <1416447994-9921-1-git-send-email-mark.yao@rock-chips.com>
	<23617908.6oA5uRuO3l@diego>
	<CAPM=9tzvvb5U+8KaCO+K6CJi=rwWOkoW+4ZSFW_Oo9gTncvkWA@mail.gmail.com>
	<1557742.FTdLsE0bVs@diego>
	<20141126073430.GD3156@suse.de>
Date: Thu, 27 Nov 2014 08:53:43 +1000
Message-ID: <CAPM=9tzhZLShA5=ShGTKhyZR6ddKycQDUWBZxXpUBb+1tGp-mQ@mail.gmail.com>
Subject: Re: [PATCH v14 0/3] Add drm driver for Rockchip Socs
From: Dave Airlie <airlied@gmail.com>
To: Joerg Roedel <jroedel@suse.de>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Mark Yao <mark.yao@rock-chips.com>,
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

On 26 November 2014 at 17:34, Joerg Roedel <jroedel@suse.de> wrote:
> On Wed, Nov 26, 2014 at 01:37:51AM +0100, Heiko Stübner wrote:
>>
>> Joerg, is your arm/rockchip branch [0] considered stable?
>>
>> [0] https://git.kernel.org/cgit/linux/kernel/git/joro/iommu.git/log/?h=arm/rockchip
>>
>
> Yes, this branch will not be rebased. It can be pulled into another
> tree.

Great, so if we can get a rockchip drm tree based on drm-next with
that tree pulled into it
that would be good.

Dave.

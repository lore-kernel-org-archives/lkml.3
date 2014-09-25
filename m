Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaIYTak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:30:40 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:59529 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaIYTah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:30:37 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <542367AC.2010105@rock-chips.com>
References: <1411382820-1615-1-git-send-email-mark.yao@rock-chips.com>
	<1411382934-1763-1-git-send-email-mark.yao@rock-chips.com>
	<20140924082037.GJ15734@phenom.ffwll.local>
	<54228F7B.2050608@rock-chips.com>
	<CAKMK7uHiQFDH-qyPBsyVa953F5SY2UgSv7Nbsu73AKvjqUm1jw@mail.gmail.com>
	<542367AC.2010105@rock-chips.com>
Date: Thu, 25 Sep 2014 21:30:36 +0200
X-Google-Sender-Auth: JXT_buUANRz_E9-bRNYJuS_AXT8
Message-ID: <CAKMK7uFO5MLAjWVwDqEf49Y=kJcBy3JV6hhnB-DEJiH6Zc+Atg@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] drm/rockchip: Add basic drm driver
From: Daniel Vetter <daniel@ffwll.ch>
To: Mark yao <mark.yao@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        David Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rom Lemarchand <romlem@google.com>, linux-doc@vger.kernel.org,
        Kever Yang <kever.yang@rock-chips.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Douglas Anderson <dianders@chromium.org>,
        Jianqun Xu <xjq@rock-chips.com>, Chris Zhong <zyw@rock-chips.com>,
        jeff chen <cym@rock-chips.com>, linux-rockchip@lists.infradead.org,
        kfx@rock-chips.com, =?UTF-8?B?546L5pmT6IW+?= <wxt@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        yxj@rock-chips.com,
        =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
        simon xue <xxm@rock-chips.com>, xw@rock-chips.com,
        linux-api@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eddie Cai <cf@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 2:54 AM, Mark yao <mark.yao@rock-chips.com> wrote:
> Hi, Daniel
> this version is old, newest is v5. and I remove uapi at v5.
> you can see v5 patch at:
> https://lkml.org/lkml/2014/9/23/1061
> thanks
>
> This version doesn't seem to be cc'ed to dri-devel, at least it didn't
> yet show up. Can you please double-check?
>
> actually I cc the v5 version to dri-devel@lists.freedesktop.org.
> and we can found the patch at https://patchwork.kernel.org/patch/4967501/(
> Project: dri-devel)

Yeah it eventually showed up here too. Looks sane from a really high
level up I think, so Ack: me.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch

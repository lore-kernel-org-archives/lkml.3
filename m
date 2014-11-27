Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbaK0Bkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 20:40:40 -0500
Received: from regular1.263xmail.com ([211.150.99.134]:36523 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbaK0Bki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 20:40:38 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: airlied@gmail.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <076755bccb4edbdf399fdaa7941f17b9>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <54768107.2090402@rock-chips.com>
Date: Thu, 27 Nov 2014 09:40:23 +0800
From: Mark yao <mark.yao@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>, Joerg Roedel <jroedel@suse.de>
CC: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
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
        =?UTF-8?B?U3TDqXBoYW5lIE1hcmNoZXNpbg==?= <marcheu@chromium.org>,
        dbehr@chromium.org, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>, Eddie Cai <cf@rock-chips.com>,
        simon xue <xxm@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>, yxj@rock-chips.com,
        xw@rock-chips.com
Subject: Re: [PATCH v14 0/3] Add drm driver for Rockchip Socs
References: <1416447994-9921-1-git-send-email-mark.yao@rock-chips.com>	<23617908.6oA5uRuO3l@diego>	<CAPM=9tzvvb5U+8KaCO+K6CJi=rwWOkoW+4ZSFW_Oo9gTncvkWA@mail.gmail.com>	<1557742.FTdLsE0bVs@diego>	<20141126073430.GD3156@suse.de> <CAPM=9tzhZLShA5=ShGTKhyZR6ddKycQDUWBZxXpUBb+1tGp-mQ@mail.gmail.com>
In-Reply-To: <CAPM=9tzhZLShA5=ShGTKhyZR6ddKycQDUWBZxXpUBb+1tGp-mQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年11月27日 06:53, Dave Airlie wrote:
> On 26 November 2014 at 17:34, Joerg Roedel <jroedel@suse.de> wrote:
>> On Wed, Nov 26, 2014 at 01:37:51AM +0100, Heiko Stübner wrote:
>>> Joerg, is your arm/rockchip branch [0] considered stable?
>>>
>>> [0] https://git.kernel.org/cgit/linux/kernel/git/joro/iommu.git/log/?h=arm/rockchip
>>>
>> Yes, this branch will not be rebased. It can be pulled into another
>> tree.
> Great, so if we can get a rockchip drm tree based on drm-next with
> that tree pulled into it
> that would be good.
>
> Dave.
>
>
>
Hi Dave
     Do you mean that I need send you a branch, based on drm-next, merge 
with iommu tree and rockchip drm?

- Mark



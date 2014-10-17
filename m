Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaJQAqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 20:46:23 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:41397 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaJQAqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 20:46:21 -0400
MIME-Version: 1.0
In-Reply-To: <5440658D.6020504@rock-chips.com>
References: <1412763781-31533-1-git-send-email-mark.yao@rock-chips.com>
	<5440658D.6020504@rock-chips.com>
Date: Fri, 17 Oct 2014 10:46:18 +1000
Message-ID: <CAPM=9twVrmni_BRV_9-QLk+JUbcgXEjAM0g-tYH6su8=sDQ35g@mail.gmail.com>
Subject: Re: [PATCH v11 0/3] Add drm driver for Rockchip Socs
From: Dave Airlie <airlied@gmail.com>
To: Mark yao <mark.yao@rock-chips.com>
Cc: heiko@sntech.de, Boris BREZILLON <boris.brezillon@free-electrons.com>,
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
        linux-rockchip@lists.infradead.org, dianders@chromium.org,
        =?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
        dbehr@chromium.org, Olof Johansson <olof@lixom.net>,
        djkurtz@chromium.org, xjq@rock-chips.com, kfx@rock-chips.com,
        cym@rock-chips.com, cf@rock-chips.com, zyw@rock-chips.com,
        xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com,
        yxj@rock-chips.com, wxt@rock-chips.com, xw@rock-chips.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 October 2014 10:40, Mark yao <mark.yao@rock-chips.com> wrote:
> Hi
> I think Rockchip drm driver is ready now, can it land?

I probably want to wait until -rc1 though I suppose since its a new
driver and self contained we might be able to see if Linus is
interested in squeezing it in.

Can you send me a git pull request for it against drm-next or even 3.17.

Dave.

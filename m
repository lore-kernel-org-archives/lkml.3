Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbaI3IRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 04:17:17 -0400
Received: from gloria.sntech.de ([95.129.55.99]:46321 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399AbaI3IRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 04:17:12 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Mark Yao <mark.yao@rock-chips.com>,
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
        Rom Lemarchand <romlem@google.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-api@vger.kernel.org,
        linux-rockchip@lists.infradead.org, dianders@chromium.org,
        marcheu@chromium.org, dbehr@chromium.org, olof@lixom.net,
        djkurtz@chromium.org, xjq@rock-chips.com, kfx@rock-chips.com,
        cym@rock-chips.com, cf@rock-chips.com, zyw@rock-chips.com,
        xxm@rock-chips.com, huangtao@rock-chips.com, kever.yang@rock-chips.com,
        yxj@rock-chips.com, wxt@rock-chips.com, xw@rock-chips.com
Subject: Re: [PATCH v8 2/3] dt-bindings: video: Add for rockchip display subsytem
Date: Tue, 30 Sep 2014 10:16:45 +0200
Message-ID: <2305060.Sjt6sMLV0g@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <20140930081020.GE24667@phenom.ffwll.local>
References: <1412057386-19375-1-git-send-email-mark.yao@rock-chips.com> <1412057659-19483-1-git-send-email-mark.yao@rock-chips.com> <20140930081020.GE24667@phenom.ffwll.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 30. September 2014, 10:10:20 schrieb Daniel Vetter:
> On Tue, Sep 30, 2014 at 02:14:19PM +0800, Mark Yao wrote:
> > From: Mark yao <mark.yao@rock-chips.com>
> > 
> > This add a display subsystem comprise the all display interface nodes.
> > 
> > Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> > Acked-by: Daniel Vetter <daniel@ffwll.ch>
> > Reviewed-by: Rob Clark <robdclark@gmail.com>
> 
> Just a quick clarification: My ack was only about the drm driver itself, I
> try really hard to stay away from DT insanity ;-) So please drop my ack
> from these two patches.
> 
> Aside: DT patches need to go through a special process and you must cc dt
> maintainers and mailing lists. Your patch seems to lack this, which afaiui
> is a blocker for merging the driver.

Looking at the recipients I see the dt list (devicetree@vger.kernel.org) as 
well as the dt maintainers (Rob Herring, Pawel Moll, Mark Rutland, Ian 
Campbell and Kumar Gala) listed there. So from this side it should be fine


Heiko

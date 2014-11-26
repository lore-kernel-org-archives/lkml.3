Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaKZRkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:40:12 -0500
Received: from gloria.sntech.de ([95.129.55.99]:46520 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbaKZRkJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:40:09 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: jeff chen <cym@rock-chips.com>, Mike Turquette <mturquette@linaro.org>,
        Derek Basehore <dbasehore@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kever Yang <kever.yang@rock-chips.com>,
        Mark yao <mark.yao@rock-chips.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] clk: rockchip: add binding ID for DMC (memory controller) clocks on rk3288
Date: Wed, 26 Nov 2014 18:43:40 +0100
Message-ID: <3545025.lFcuKWk0o9@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <CAD=FV=WxeFFZekYOkttx4YcDq=td+Vpu9rFALuNu_6zs+7b2tw@mail.gmail.com>
References: <1416960783-25119-1-git-send-email-dianders@chromium.org> <1717801.sWHeWsmqUi@diego> <CAD=FV=WxeFFZekYOkttx4YcDq=td+Vpu9rFALuNu_6zs+7b2tw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 25. November 2014, 16:49:08 schrieb Doug Anderson:
> Heiko,
> 
> On Tue, Nov 25, 2014 at 4:45 PM, Heiko Stübner <heiko@sntech.de> wrote:
> > Am Dienstag, 25. November 2014, 16:13:02 schrieb Doug Anderson:
> >> From: Jeff Chen <cym@rock-chips.com>
> >> 
> >> The DMC clocks need to be turned off at runtime, so we should have IDs
> >> so we can export them.
> >> 
> >> Signed-off-by: Jeff Chen <cym@rock-chips.com>
> >> [dianders: split into two patches; adjusted commit msg]
> >> Signed-off-by: Doug Anderson <dianders@chromium.org>
> > 
> > both patches look ok to me and I'll probably pick them up tomorrow.
> 
> OK, thanks!

I've now added both patches to my clk branch.


> > We have currently three clock patches/series adding new clock ids [this
> > one, the mmc phases and Sonny's i2s_clkout] and I'm trying to dertermine
> > if I need a shared branch for those.
> > 
> > Currently it doesn't look like the others will provide dts patches using
> > the clocks in time, so it looks like I can skip the shared branch and we
> > can use the clock ids regularly after the merge-window. Some true for
> > your clocks?
> Yup, no problem for me.  I provided this as two patches to you just in
> case it was convenient, since I saw that as feedback in previous
> submissions.

Yep, I think it is the sanest of doing it in one way all the time, so we have 
the option of easily creating shared branches depending on what is needed.


Heiko

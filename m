Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbaK0ItR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:49:17 -0500
Received: from gloria.sntech.de ([95.129.55.99]:53576 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194AbaK0ItI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:49:08 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rockchip@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Douglas Anderson <dianders@chromium.org>,
        Mike Turquette <mturquette@linaro.org>,
        Mark yao <mark.yao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH] clk: rockchip: rk3288 export i2s0_clkout for use in DT
Date: Thu, 27 Nov 2014 09:52:55 +0100
Message-ID: <56685599.NrGFKacCZ1@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <CAPz6YkXOS08hv7x+DM3roTuZYMbh9n4=kpTrH8NGYUffczQwLA@mail.gmail.com>
References: <1416381319-31117-1-git-send-email-sonnyrao@chromium.org> <3863623.tcGxuFQcZa@diego> <CAPz6YkXOS08hv7x+DM3roTuZYMbh9n4=kpTrH8NGYUffczQwLA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 26. November 2014, 19:47:10 schrieb Sonny Rao:
> On Wed, Nov 26, 2014 at 3:32 PM, Heiko Stübner <heiko@sntech.de> wrote:
> > Am Dienstag, 18. November 2014, 23:15:19 schrieb Sonny Rao:
> >> This exposes the clock that comes out of the i2s block which generally
> >> goes to the audio codec.
> >> 
> >> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> > 
> > applied to my clk branch after removing the CLK_SET_RATE_PARENT
> 
> Hi, sorry for the delay, and thanks for fixing it.  I think when I
> applied the patch to next-20141118 that had a CLK_SET_RATE_PARENT in
> it from this patch:
> 
> commit fc69ed70c16a31d6a77ec47a30a9fe941f763f1e
> Author: Jianqun <jay.xu@rock-chips.com>
> Date:   Tue Sep 30 11:12:04 2014 +0800
> 
>     clk: rockchip: rk3288: i2s_frac adds flag to set parent's rate
> 
> 
> I agree that is is not necessary and maybe not desirable.  Thanks again!

glad to be of help :-)

Just for reference, the commit removing this CLK_SET_RATE_PARENT is [0] that 
incidentally got pulled in by Mike on the same 20141118 and was therefore part 
of linux-next 20141119



[0] https://git.kernel.org/cgit/linux/kernel/git/mmind/linux-rockchip.git/commit/?id=8f06f5d392b3fbd58a5d7e00b047b6ee08c6d9b0

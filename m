Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaKOKzO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 05:55:14 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:41070 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753840AbaKOKzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 05:55:12 -0500
Date: Sat, 15 Nov 2014 10:54:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Kurtz <djkurtz@chromium.org>, Andy Yan <andy.yan@rock-chips.com>
Cc: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>,
        David Airlie <airlied@linux.ie>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        fabio.estevam@freescale.com, Mark Rutland <mark.rutland@arm.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Yakir Yang <ykk@rock-chips.com>, devel@driverdev.osuosl.org,
        Arnd Bergmann <arnd@arndb.de>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Dave Airlie <airlied@redhat.com>, Xu Jianqun <jay.xu@rock-chips.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Sean Paul <seanpaul@chromium.org>,
        "mark.yao@rock-chips.com" <mark.yao@rock-chips.com>,
        Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v10 05/11] drm: bridge/dw_hdmi:split some phy
 configuration to platform driver
Message-ID: <20141115105447.GJ4042@n2100.arm.linux.org.uk>
References: <1415934583-16290-1-git-send-email-andy.yan@rock-chips.com>
 <1415935631-16826-1-git-send-email-andy.yan@rock-chips.com>
 <5465D73C.9030507@imgtec.com>
 <5465DF0C.50301@rock-chips.com>
 <5465DFB2.8060601@imgtec.com>
 <5465E2BB.1070507@rock-chips.com>
 <5465E3DF.6050307@imgtec.com>
 <CAGS+omANityD4ZbqLzgrbro6WSTWozXS9fvdwof=Mv_X8OpHRg@mail.gmail.com>
 <20141115101218.GI4042@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141115101218.GI4042@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2014 at 10:12:18AM +0000, Russell King - ARM Linux wrote:
> Once the wranglings on the patch series are complete, I do intend to test
> it on the platforms I have - and remember that I do have the ALSA based
> audio and CEC bits as well, some of which will probably need a little bit
> of re-work.
> 
> All in all, I welcome the renaming of this to include a reference to
> DesignWare - I've always thought it's a mistake that the HDMI interface
> in iMX6 was not named with a "dw" prefix as the docs contain references
> to it being a DesignWare IP module.

One thing I would ask is that the subsequent submissions do not thread
onto the previous submission.

It may seem a good idea (people claim that it allows the previous reviews
to be trivially found) but these people forget an important side effect
from this behaviour - when looking at the message index in a threaded
mail reader (like mutt), each reply to a thread moves the subject line
by three characters to the right.  What this means is that after about
five or six iterations of the submission, there is no longer any subject
line visible.

Moreover, it means that with lesser iterations, it becomes much more
difficult to see /any/ of the review thread structure.

I would suggest that if you do want to "connect" the subsequent
submissions, please use the same reference message for each submission.
In other words, rather than:

v1 0/2
+-> v1 1/2
+-> v1 2/2
+-> v2 0/2
    +-> v2 1/2
    +-> v2 2/2
        +-> v3 0/2
            +-> v3 1/2
            +-> v3 2/2
...

This is done instead:

v1 0/2
+-> v1 1/2
+-> v1 2/2
+-> v2 0/2
|   +-> v2 1/2
|   +-> v2 2/2
+-> v3 0/2
|   +-> v3 1/2
|   +-> v3 2/2
...

which is a compromise between threading the messages together, and
keeping stopping the thread pushing the subject line completely off
the right hand side of the screen.

In this case, I'd suggest a reference of:
  1415793593-5075-1-git-send-email-andy.yan@rock-chips.com

which is the v8 covering message which started this big thread.

Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.

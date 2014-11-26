Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaKZAlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:41:35 -0500
Received: from gloria.sntech.de ([95.129.55.99]:39850 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbaKZAld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:41:33 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: cym@rock-chips.com, Mike Turquette <mturquette@linaro.org>,
        Derek Basehore <dbasehore@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        kever.yang@rock-chips.com, mark.yao@rock-chips.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] clk: rockchip: add binding ID for DMC (memory controller) clocks on rk3288
Date: Wed, 26 Nov 2014 01:45:12 +0100
Message-ID: <1717801.sWHeWsmqUi@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1416960783-25119-1-git-send-email-dianders@chromium.org>
References: <1416960783-25119-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 25. November 2014, 16:13:02 schrieb Doug Anderson:
> From: Jeff Chen <cym@rock-chips.com>
> 
> The DMC clocks need to be turned off at runtime, so we should have IDs
> so we can export them.
> 
> Signed-off-by: Jeff Chen <cym@rock-chips.com>
> [dianders: split into two patches; adjusted commit msg]
> Signed-off-by: Doug Anderson <dianders@chromium.org>

both patches look ok to me and I'll probably pick them up tomorrow.

Just as handling question, do you plan on sending dts changes using these 
clocks in time for 3.19 [i.e. in the next couple of days]?

We have currently three clock patches/series adding new clock ids [this one, 
the mmc phases and Sonny's i2s_clkout] and I'm trying to dertermine if I need 
a shared branch for those.

Currently it doesn't look like the others will provide dts patches using the 
clocks in time, so it looks like I can skip the shared branch and we can use 
the clock ids regularly after the merge-window. Some true for your clocks?


Thanks
Heiko

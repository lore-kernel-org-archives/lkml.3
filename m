Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaKZXMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:12:17 -0500
Received: from gloria.sntech.de ([95.129.55.99]:50015 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbaKZXML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:12:11 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Sonny Rao <sonnyrao@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Mark yao <mark.yao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH] clk: rockchip: rk3288 export i2s0_clkout for use in DT
Date: Thu, 27 Nov 2014 00:15:58 +0100
Message-ID: <1452869.BD3Nj3iYiH@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <CAD=FV=W_t813jFgPgkxq7g3Bn5+MHj_t-G7=OP4xFmDnaMjF7w@mail.gmail.com>
References: <1416381319-31117-1-git-send-email-sonnyrao@chromium.org> <13759993.X1UzQR0utx@diego> <CAD=FV=W_t813jFgPgkxq7g3Bn5+MHj_t-G7=OP4xFmDnaMjF7w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

Am Mittwoch, 26. November 2014, 15:05:53 schrieb Doug Anderson:
> I'm no longer convinced that's a good idea, so we should just axe the
> CLK_SET_RATE_PARENT.
> 
> If timing is working out well and Sonny isn't available to spin this
> right now (it's Thanksgiving holidays here in the US), I doubt he
> would mind if you fixed up the patch and submitted it.

yep I can do that ... I just wanted some sort of confirmation to verify that 
I'm not missing anything obvious before I start modifying patches :-)


Heiko

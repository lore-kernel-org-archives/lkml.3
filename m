Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbaKMIlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 03:41:23 -0500
Received: from gloria.sntech.de ([95.129.55.99]:42193 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123AbaKMIlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 03:41:21 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>, Dmitry Torokhov <dtor@chromium.org>,
        Jianqun <jay.xu@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Mark yao <mark.yao@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: rockchip: ensure HCLK_VIO2_H2P and PCLK_VIO2_H2P stay enabled
Date: Thu, 13 Nov 2014 09:44:49 +0100
Message-ID: <6158549.ckz49I10o4@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141113004046.25314.61598@quantum>
References: <20141112213845.GA14153@dtor-ws> <CAD=FV=UsYWDw0wB6KSANXZYnnBFdTL9wOEqf9DoUF8aFuDpNSw@mail.gmail.com> <20141113004046.25314.61598@quantum>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Am Mittwoch, 12. November 2014, 16:40:46 schrieb Mike Turquette:
> Seems fine to me. Just to be clear, Heiko will be picking up the
> Rockchip clock patches and submitting a PR, correct? I believe last
> merge window was the first time we did that for Rockchip and it went
> well.

yep, I'm picking up the clock patches.


Heiko

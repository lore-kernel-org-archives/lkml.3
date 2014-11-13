Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934709AbaKMXlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 18:41:46 -0500
Received: from gloria.sntech.de ([95.129.55.99]:53808 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934359AbaKMXlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 18:41:45 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        Doug Anderson <dianders@chromium.org>, Jianqun <jay.xu@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Mark yao <mark.yao@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: rockchip: ensure HCLK_VIO2_H2P and PCLK_VIO2_H2P stay enabled
Date: Fri, 14 Nov 2014 00:45:09 +0100
Message-ID: <1483690.PjlKQiaGsb@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141112213845.GA14153@dtor-ws>
References: <20141112213845.GA14153@dtor-ws>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 12. November 2014, 13:38:45 schrieb Dmitry Torokhov:
> Currently there is no driver owning these clocks and they have to stay
> up for the system to function properly, so let's mark them as
> CLK_IGNORE_UNUSED.
> 
> Without this patch we have trouble with suspend/resume and we have
> trouble turning the eDP back on if it ever idles off.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>

I've added this patch to my v3.19-clk/next branch.

After talking with Doug we agreed on replacing his Signed-Off with the Reviewed 
and Tested tags, because his prior involvement was "mostly because I tweaked 
the commit message and tested this" - making the new tags fit better.

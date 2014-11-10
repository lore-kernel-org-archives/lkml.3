Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaKJT4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:56:54 -0500
Received: from gloria.sntech.de ([95.129.55.99]:60412 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbaKJT4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:56:53 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Chris Zhong <zyw@rock-chips.com>
Cc: dianders@chromium.org, mturquette@linaro.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>, khilman@kernel.org,
        linux-rockchip@lists.infradead.org, Tony Xie <xxx@rock-chips.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/5] clk: rockchip: RK3288: add suspend and resume
Date: Mon, 10 Nov 2014 21:00:03 +0100
Message-ID: <1718338.XO4HPi6an2@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1415368177-6637-2-git-send-email-zyw@rock-chips.com>
References: <1415368177-6637-1-git-send-email-zyw@rock-chips.com> <1415368177-6637-2-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Am Freitag, 7. November 2014, 21:49:33 schrieb Chris Zhong:
> save and restore some clks, which might be changed in suspend.
> 
> Signed-off-by: Tony Xie <xxx@rock-chips.com>
> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> Tested-by: Doug Anderson <dianders@chromium.org>

I've applied this patch to my v3.19-clk/next branch


Heiko

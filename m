Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaLEVgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:36:38 -0500
Received: from gloria.sntech.de ([95.129.55.99]:59040 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaLEVgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:36:37 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Mike Turquette <mturquette@linaro.org>, kever.yang@rock-chips.com,
        jay.xu@rock-chips.com, caesar.wang@rock-chips.com,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: rockchip: Add CLK_SET_RATE_PARENT to sclk_uart clocks
Date: Fri, 05 Dec 2014 22:40:29 +0100
Message-ID: <5769551.kTdgyxWvD4@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1417728785-18054-1-git-send-email-dianders@chromium.org>
References: <1417728785-18054-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 4. Dezember 2014, 13:33:05 schrieb Doug Anderson:
> We'd like to be able to set the clock rate of the sclk_uart clocks and
> actually be able to achieve clock rates greater than 24MHz.  To do
> this we need to be able to pass rate changes upward.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

applied this to my wip clk branch for 3.20 (on github)


Thanks
Heiko

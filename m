Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaLUOIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 09:08:37 -0500
Received: from gloria.sntech.de ([95.129.55.99]:43722 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbaLUOIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 09:08:36 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Cc: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "open list:COMMON CLK FRAMEWORK" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] clk: rockchip: add CLK_IGNORE_UNUSED flag to fix USB Host
Date: Sun, 21 Dec 2014 15:08:26 +0100
Message-ID: <3524012.TLQ4xTHULn@phil>
User-Agent: KMail/4.14.2 (Linux/3.16-3-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1418418352-3947-1-git-send-email-julien.chauveau@neo-technologies.fr>
References: <1418396066-31360-1-git-send-email-julien.chauveau@neo-technologies.fr> <1418418352-3947-1-git-send-email-julien.chauveau@neo-technologies.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 12. Dezember 2014, 22:05:52 schrieb Julien CHAUVEAU:
> This patch adds CLK_IGNORE_UNUSED flag to hclk_usb_peri, hclk_usbotg0
> and hclk_usbotg1 because these clocks must remain enabled to use the
> USB controllers in host mode.
> 
> This fixes a regression introduced by commit 78eaf6095cc7
> ("clk: rockchip: disable unused clocks").
> 
> Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>

applied to my clk/fixes branch with Romain's tags


Heiko

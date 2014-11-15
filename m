Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbaKOXh6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 18:37:58 -0500
Received: from gloria.sntech.de ([95.129.55.99]:59734 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbaKOXh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 18:37:57 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Mike Turquette <mturquette@linaro.org>, dianders@chromium.org,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, cf@rock-chips.com,
        dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: rockchip: fix clock select order for usbphy480m_src
Date: Sun, 16 Nov 2014 00:41:27 +0100
Message-ID: <8965478.SpyRElfG0W@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1415866309-3277-1-git-send-email-kever.yang@rock-chips.com>
References: <1415866309-3277-1-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 13. November 2014, 16:11:49 schrieb Kever Yang:
> According to rk3288 trm, the mux selector locate at bit[12:11]
> of CRU_CLKSEL13_CON shows:
> 2'b00: select HOST0 USB pll clock (clk_otgphy1)
> 2'b01: select HOST1 USB pll clock (clk_otgphy2)
> 2'b10: select OTG USB pll clock   (clk_otgphy0)
> 
> The clock map is in Fig. 3-4 CRU Clock Architecture Diagram 3
> - clk_otgphy0 -> USB PHY OTG
> - clk_otgphy1 -> USB PHY host0
> - clk_otgphy2 -> USB PHY host1
> 
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>

applied this to my clk branch for 3.19


Heiko

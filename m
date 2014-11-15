Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbaKOXAN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 18:00:13 -0500
Received: from gloria.sntech.de ([95.129.55.99]:59310 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754152AbaKOXAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 18:00:11 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Mike Turquette <mturquette@linaro.org>, dianders@chromium.org,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, cf@rock-chips.com,
        dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: rockchip: fix clk_usbphy480m_gate bit location in register
Date: Sun, 16 Nov 2014 00:03:33 +0100
Message-ID: <1455255.dvOV4oYdNo@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1415863161-15495-1-git-send-email-kever.yang@rock-chips.com>
References: <1415863161-15495-1-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 13. November 2014, 15:19:21 schrieb Kever Yang:
> According to rk3288 trm, the clk_usbphy480m_gate is locate at
> bit 14 of CRU_CLKGATE5_CON register.
> 
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>

applied this to my clk branch.


Heiko

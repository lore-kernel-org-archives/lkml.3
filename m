Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaKZX2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:28:42 -0500
Received: from gloria.sntech.de ([95.129.55.99]:50153 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861AbaKZX2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:28:41 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, dianders@chromium.org,
        Mike Turquette <mturquette@linaro.org>,
        Mark yao <mark.yao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH] clk: rockchip: rk3288 export i2s0_clkout for use in DT
Date: Thu, 27 Nov 2014 00:32:29 +0100
Message-ID: <3863623.tcGxuFQcZa@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1416381319-31117-1-git-send-email-sonnyrao@chromium.org>
References: <1416381319-31117-1-git-send-email-sonnyrao@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 18. November 2014, 23:15:19 schrieb Sonny Rao:
> This exposes the clock that comes out of the i2s block which generally
> goes to the audio codec.
> 
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>

applied to my clk branch after removing the CLK_SET_RATE_PARENT

Heiko

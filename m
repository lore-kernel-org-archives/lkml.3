Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbbALUr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 15:47:56 -0500
Received: from gloria.sntech.de ([95.129.55.99]:34727 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748AbbALUry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 15:47:54 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Mike Turquette <mturquette@linaro.org>, dianders@chromium.org,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, cf@rock-chips.com,
        dkl@rock-chips.com, huangtao@rock-chips.com,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark yao <mark.yao@rock-chips.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] clk: rockchip: add clock ID for usbphy480m_src
Date: Mon, 12 Jan 2015 21:47:26 +0100
Message-ID: <6235471.icZMzD14OV@phil>
User-Agent: KMail/4.14.2 (Linux/3.16.0-4-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1415863357-15680-1-git-send-email-kever.yang@rock-chips.com>
References: <1415863357-15680-1-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 13. November 2014, 15:22:36 schrieb Kever Yang:
> There are 3 different parent clock from different usbphy,
> all of them are fixed 480MHz, it is not able to auto select
> by clock core to the 2nd and the 3rd parent.
> For different use case for different board, we may need to
> select different usbphy clock out as parent manually.
> 
> Add the clock ID for it so that we can use in dts.
> 
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>

applied both patches to my tree

The clock-id addition is living in a separate branch, so if you have dts 
updates using this I can share the clock-id branch easily.


Heiko

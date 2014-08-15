Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaHOQJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:09:46 -0400
Received: from gloria.sntech.de ([95.129.55.99]:35249 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbaHOQJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:09:45 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Kever Yang <kever.yang@rock-chips.com>, Chris Zhong <zyw@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: Move the PMIC interrupt pinctrl line to rk3288-evb common
Date: Fri, 15 Aug 2014 18:11:13 +0200
Message-ID: <2248839.hV1QilfnQh@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1407782849-11056-1-git-send-email-dianders@chromium.org>
References: <1407782849-11056-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 11. August 2014, 11:47:29 schrieb Doug Anderson:
> The PMIC interrupt pinctrl line was added to the rk3288-evb-act8846,
> but it's the same line on both the ACT8846 version and the RK808
> version.  This makes a lot of sense since they share the same SoC
> daugherboard.  Move the pinctrl definition to the common file so we
> can use it for the RK808 version.
> 
> NOTE: The PMIC interrupt doesn't _actually_ go to the PMIC on the
> ACT8846 version of the board (it does on the RK808), but our
> convention is to label things as they're labelled on the schematics.
> In the very least you can argue that this is the interrupt from the
> PMIC daughtercard even if it doesn't actually go to the PMIC chip.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

I've added this to my v3.18 dts branch


Heiko

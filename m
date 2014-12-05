Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaLEVmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:42:09 -0500
Received: from gloria.sntech.de ([95.129.55.99]:59064 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbaLEVmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:42:06 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: dianders@chromium.org, amstan@chromium.org, sonnyrao@chromium.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, olof@lixom.net, hj@rock-chips.com,
        kever.yang@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, zhangqing@rock-chips.com, hl@rock-chips.com,
        wei.luo@rock-chips.com
Subject: Re: [PATCH] ARM: dts: rockchip: set dw_mmc max-freq 150Mhz
Date: Fri, 05 Dec 2014 22:45:53 +0100
Message-ID: <2413230.2M6GRRu59M@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1417661375-2872-1-git-send-email-addy.ke@rock-chips.com>
References: <1417661375-2872-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 4. Dezember 2014, 10:49:35 schrieb Addy Ke:
> All of mmc controllers include SDMMC, SDIO0, SDIO1, and EMMC on RK3288
> are limited to 150Mhz. It was mainly caused by two reasons:
> - RK3288's IO pad(except DDR IO pad) is generic, which can only support
>   the max of 150Mhz.
> - Mmc controller was designed at 150Mhz, and the pressure test by IC team
>   was based on this freequency point.
> 
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>

applied to my wip dts branch for 3.20 (on github)


Thanks
Heiko

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbaHMWPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:15:51 -0400
Received: from gloria.sntech.de ([95.129.55.99]:42032 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbaHMWPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:15:50 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Ulf Hansson <ulf.hansson@linaro.org>, Addy Ke <addy.ke@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux@arm.linux.org.uk, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, galak@codeaurora.org
Subject: Re: [PATCH v4 0/2] Add eMMC and SD card support for rk3288-evb
Date: Thu, 14 Aug 2014 00:15:19 +0200
Message-ID: <1896828.oB75TXBbSp@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1407885674-16469-1-git-send-email-dianders@chromium.org>
References: <1407885674-16469-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 12. August 2014, 16:21:12 schrieb Doug Anderson:
> This series adds basic eMMC and SD card support for the rk3288-evb
> board based on Addy's dw_mmc patch.

I've added both patches to the general dts branch for 3.18.
Currently as WIP and temporarily on github [0] until we reach -rc1.


Heiko


[0] https://github.com/mmind/linux-rockchip/tree/wip/v3.18-next/dts

> 
> Note that we don't have regulators specified yet (no regulator driver
> for rk808-based board).  We also don't yet support UHS modes or MMC
> DDR50 (which require regulator support plus dw_mmc driver support for
> tuning).  Those features can come later.
> 
> Changes in v4:
> - Add status="disabled".
> - Squash patch #1 and #4 since Jaehoon's patch landed.
> - Squashed patches #2 and #3 since Jaehoon's patch landed.
> 
> Changes in v3:
> - Removed DDR50 mode since it needs tuning, which isn't there yet.
> 
> Changes in v2:
> - Refer to the new title of Jaehoon's patch
> - New patchwork link for Addy's patch
> - Squashed in the DDR50 mode since Addy spun his patch.
> 
> Doug Anderson (2):
>   ARM: dts: Add emmc and sdmmc to the rk3288 device tree
>   ARM: dts: Enable emmc and sdmmc on the rk3288-evb boards
> 
>  arch/arm/boot/dts/rk3288-evb.dtsi | 24 ++++++++++++++++++++++++
>  arch/arm/boot/dts/rk3288.dtsi     | 20 ++++++++++++++++++++
>  2 files changed, 44 insertions(+)


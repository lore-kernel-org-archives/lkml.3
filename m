Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaKDNww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:52:52 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:53526 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbaKDNwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:52:50 -0500
Message-ID: <5458D9B9.5030606@imgtec.com>
Date: Tue, 4 Nov 2014 13:50:49 +0000
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Yan <andy.yan@rock-chips.com>, <airlied@linux.ie>, <heiko@sntech.de>,
        <fabio.estevam@freescale.com>, <rmk+kernel@arm.linux.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Josh Boyer <jwboyer@redhat.com>,
        Sean Paul <seanpaul@chromium.org>, Inki Dae <inki.dae@samsung.com>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Lucas Stach <l.stach@pengutronix.de>, <djkurtz@google.com>,
        <ykk@rock-chips.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <devel@driverdev.osuosl.org>,
        <devicetree@vger.kernel.org>, <linux-rockchip@lists.infradead.org>
Subject: Re: [PATCH 2/2] move imx-hdmi to bridge/dw-hdmi
References: <1415108398-34376-1-git-send-email-andy.yan@rock-chips.com>
In-Reply-To: <1415108398-34376-1-git-send-email-andy.yan@rock-chips.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/11/14 13:39, Andy Yan wrote:
> From: Andy yan <andy.yan@rock-chips.com>
> 
> the original imx hdmi driver is under staging/imx-drm,
> which depends on imx-drm, so move the imx hdmi drvier out
> to drm/bridge and rename imx-hdmi to dw-hdmi
> 
> Change-Id: I5f417372f256aa26cd00a3cd0160741680afd39d
> ---
>  drivers/gpu/drm/bridge/Kconfig        |    5 +
>  drivers/gpu/drm/bridge/Makefile       |    1 +
>  drivers/gpu/drm/bridge/dw_hdmi.c      | 1651 +++++++++++++++++++++++++++++++++
>  drivers/gpu/drm/bridge/dw_hdmi.h      | 1032 +++++++++++++++++++++
>  drivers/staging/imx-drm/Kconfig       |    1 +
>  drivers/staging/imx-drm/Makefile      |    2 +-
>  drivers/staging/imx-drm/dw_hdmi-imx.c |   66 +-
>  drivers/staging/imx-drm/imx-hdmi.c    | 1651 ---------------------------------
>  drivers/staging/imx-drm/imx-hdmi.h    | 1032 ---------------------
>  include/drm/bridge/dw_hdmi.h          |   26 +-
>  10 files changed, 2737 insertions(+), 2730 deletions(-)
>  create mode 100644 drivers/gpu/drm/bridge/dw_hdmi.c
>  create mode 100644 drivers/gpu/drm/bridge/dw_hdmi.h
>  delete mode 100644 drivers/staging/imx-drm/imx-hdmi.c
>  delete mode 100644 drivers/staging/imx-drm/imx-hdmi.h
> 


Could you try generating this patch with the -M option?

git format-patch should then understand its a rename.
Then it should generate a smaller patch that is possible to review easily.

Thanks
ZubairLK

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaKKOgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:36:52 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:5720 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaKKOgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:36:50 -0500
Message-ID: <54621EF7.4000300@imgtec.com>
Date: Tue, 11 Nov 2014 14:36:39 +0000
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
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
        <devicetree@vger.kernel.org>, <linux-rockchip@lists.infradead.org>,
        <jay.xu@rock-chips.com>
Subject: Re: [PATCH v7 6/7] drm: bridge/dw-hdmi: convert dw-hdmi to drm_bridge
 mode
References: <1415710229-11935-1-git-send-email-andy.yan@rock-chips.com> <1415710469-12213-1-git-send-email-andy.yan@rock-chips.com>
In-Reply-To: <1415710469-12213-1-git-send-email-andy.yan@rock-chips.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On 11/11/14 12:54, Andy Yan wrote:
> From: Yakir Yang <ykk@rock-chips.com>
> 
> keep the connector & birdge in dw_hdmi.c, handle encoder in dw_hdmi-imx.c

Is there a reason for this separation? Keeping encoder in platform files?
If yes, then the commit message should explain that.

> 
> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
> Signed-off-by: Yakir Yang <ykk@rock-chips.com>
> 
> ---
> 
> Changes in v7: None
> Changes in v6:
> - move some modification from patch#5
> 
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
>  drivers/gpu/drm/bridge/dw_hdmi.c      | 228 +++++++++++++++-------------------
>  drivers/staging/imx-drm/dw_hdmi-imx.c | 145 ++++++++++++++-------
>  include/drm/bridge/dw_hdmi.h          |  13 +-
>  3 files changed, 199 insertions(+), 187 deletions(-)


Regards
ZubairLK

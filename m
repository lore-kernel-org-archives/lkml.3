Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaKFPzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:55:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49473 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaKFPzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:55:20 -0500
Date: Thu, 6 Nov 2014 07:54:10 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, Zubair.Kakakhel@imgtec.com,
        Arnd Bergmann <arnd@arndb.de>, Josh Boyer <jwboyer@redhat.com>,
        ykk@rock-chips.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Inki Dae <inki.dae@samsung.com>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Sean Paul <seanpaul@chromium.org>, djkurtz@google.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Dave Airlie <airlied@redhat.com>,
        Grant Likely <grant.likely@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>, jay.xu@rock-chips.com,
        Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH V3 4/4] dw-hdmi: convert dw-hdmi to drm_bridge mode
Message-ID: <20141106155410.GB19811@kroah.com>
References: <1415273118-57045-1-git-send-email-andy.yan@rock-chips.com>
 <1415273176-57096-1-git-send-email-andy.yan@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415273176-57096-1-git-send-email-andy.yan@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 07:26:16PM +0800, Andy Yan wrote:
> From: ykk <ykk@rock-chips.com>

We need a "real" name here, sorry.

> 
> dw-hdmi is under drm/bridge, so it should be the bridge mode.
> hange off the encoder to dw_hdmi-imx.c, keep the connector &
> birdge in dw_hdmi.c
> 
> Signed-off-by: ykk <ykk@rock-chips.com>

Same here.

thanks,

greg k-h

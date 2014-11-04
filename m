Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbaKDQE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:04:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbaKDQEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:04:55 -0500
Date: Tue, 4 Nov 2014 08:03:45 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Josh Boyer <jwboyer@redhat.com>,
        Sean Paul <seanpaul@chromium.org>, Inki Dae <inki.dae@samsung.com>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Lucas Stach <l.stach@pengutronix.de>, Zubair.Kakakhel@imgtec.com,
        djkurtz@google.com, ykk@rock-chips.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH 2/2] move imx-hdmi to bridge/dw-hdmi
Message-ID: <20141104160345.GB1503@kroah.com>
References: <1415108398-34376-1-git-send-email-andy.yan@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415108398-34376-1-git-send-email-andy.yan@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 09:39:58PM +0800, Andy Yan wrote:
> From: Andy yan <andy.yan@rock-chips.com>
> 
> the original imx hdmi driver is under staging/imx-drm,
> which depends on imx-drm, so move the imx hdmi drvier out
> to drm/bridge and rename imx-hdmi to dw-hdmi
> 
> Change-Id: I5f417372f256aa26cd00a3cd0160741680afd39d

Never include this line in a public patch, it means nothing to us,
sorry...

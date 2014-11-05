Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbaKEJd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:33:56 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38908 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaKEJdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:33:53 -0500
Date: Wed, 5 Nov 2014 12:30:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, Zubair.Kakakhel@imgtec.com,
        Arnd Bergmann <arnd@arndb.de>, Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Inki Dae <inki.dae@samsung.com>, linux-rockchip@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, Sean Paul <seanpaul@chromium.org>,
        djkurtz@google.com, Philipp Zabel <p.zabel@pengutronix.de>,
        Dave Airlie <airlied@redhat.com>,
        Grant Likely <grant.likely@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>, Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH 2/2] move imx-hdmi to bridge/dw-hdmi
Message-ID: <20141105093012.GN6879@mwanda>
References: <1415108398-34376-1-git-send-email-andy.yan@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415108398-34376-1-git-send-email-andy.yan@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 09:39:58PM +0800, Andy Yan wrote:
> From: Andy yan <andy.yan@rock-chips.com>

Leave this out.  It's for when you are forwarding a patch from someone
else.  Also it has a typo and your email From: header is correct.

> 
> the original imx hdmi driver is under staging/imx-drm,
> which depends on imx-drm, so move the imx hdmi drvier out
> to drm/bridge and rename imx-hdmi to dw-hdmi
> 

No Signed-off-by: line.

regards,
dan carpenter


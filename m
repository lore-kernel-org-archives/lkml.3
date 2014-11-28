Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaK1QO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 11:14:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37194 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaK1QO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 11:14:58 -0500
Message-ID: <1417191262.3721.6.camel@pengutronix.de>
Subject: Re: [PATCH v13 0/12] dw-hdmi: convert imx hdmi to bridge/dw_hdmi
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Date: Fri, 28 Nov 2014 17:14:22 +0100
In-Reply-To: <547846F7.3080708@rock-chips.com>
References: <1417008157-31861-1-git-send-email-andy.yan@rock-chips.com>
	 <1417018856.3177.6.camel@pengutronix.de> <547846F7.3080708@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 28.11.2014, 17:57 +0800 schrieb Andy Yan:
> Hi Philipp:
[...]
>    Very sorry about this trouble. Because I have no imx board, we do all 
> the test on
> RK3288 board.
>     I had sent a mail with a debug patch to you directly yesterday, hope 
> it will helpful.
> If you have received the mail, would you please give me a reply?

Yes, that was helpful, thank you.
I needed to apply Russell's "imx-drm: convert imx-drm to use the generic
DRM OF helper" patch for drm_of_find_possible_crtcs to work on imx-drm.

regards
Philipp


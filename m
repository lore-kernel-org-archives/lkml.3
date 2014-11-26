Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751881AbaKZCOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 21:14:55 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:60113 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaKZCOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 21:14:53 -0500
MIME-Version: 1.0
In-Reply-To: <1416221635-12797-1-git-send-email-andy.yan@rock-chips.com>
References: <1415793593-5075-1-git-send-email-andy.yan@rock-chips.com>
	<1416221635-12797-1-git-send-email-andy.yan@rock-chips.com>
Date: Wed, 26 Nov 2014 00:14:52 -0200
Message-ID: <CAOMZO5BH0TwOk3aFeabAqE+JssG9YL=CsTz2Tq3Q1L46fTbcCQ@mail.gmail.com>
Subject: Re: [PATCH v12 0/11] dw-hdmi: convert imx hdmi to bridge/dw_hdmi
From: Fabio Estevam <festevam@gmail.com>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: David Airlie <airlied@linux.ie>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>, ykk@rock-chips.com,
        devel@driverdev.osuosl.org, Arnd Bergmann <arnd@arndb.de>,
        linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Dave Airlie <airlied@redhat.com>, jay.xu@rock-chips.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Zubair.Kakakhel@imgtec.com, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Sean Paul <seanpaul@chromium.org>, mark.yao@rock-chips.com,
        Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, djkurtz@google.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>,
        Lucas Stach <l.stach@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Mon, Nov 17, 2014 at 8:53 AM, Andy Yan <andy.yan@rock-chips.com> wrote:

> Andy Yan (11):
>   staging: imx-drm: imx-hdmi: make checkpatch happy
>   staging: imx-drm: imx-hdmi: return defer if can't get ddc i2c adapter
>   staging: imx-drm: imx-hdmi: convert imx-hdmi to drm_bridge mode
>   staging: imx-drm: imx-hdmi: move imx-hdmi to bridge/dw_hdmi

imx-drm has moved out of staging.

Please see Phillip's patch:
http://cgit.freedesktop.org/~airlied/linux/commit/?h=drm-next&id=6556f7f82b9c401950d703072c0d8137b6f9f516

So you need to re-submit your series against drm-next.

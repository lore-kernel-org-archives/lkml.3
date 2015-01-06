Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbbAFP2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:28:31 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44946 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbbAFP23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:28:29 -0500
Message-ID: <1420558065.3719.10.camel@pengutronix.de>
Subject: Re: [PATCH v18 0/12] dw-hdmi: convert imx hdmi to bridge/dw_hdmi
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Andy Yan <andy.yan@rock-chips.com>, airlied@linux.ie,
        fabio.estevam@freescale.com, rmk+kernel@arm.linux.org.uk,
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
        Kumar Gala <galak@codeaurora.org>, vladimir_zapolskiy@mentor.com
Date: Tue, 06 Jan 2015 16:27:45 +0100
In-Reply-To: <1956639.ADgYrPHa6L@phil>
References: <1417760564-16858-1-git-send-email-andy.yan@rock-chips.com>
	 <1417787724.3227.10.camel@pengutronix.de> <5481DDF2.6010700@rock-chips.com>
	 <1956639.ADgYrPHa6L@phil>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

Am Dienstag, den 06.01.2015, 12:49 +0100 schrieb Heiko Stübner:
> Hi Philipp,
> 
> Am Samstag, 6. Dezember 2014, 00:31:46 schrieb Andy Yan:
> > > I am happy with the series so far. Pending Acks from the device tree
> > > maintainers for the new binding documents, I'd like to apply either the
> > > whole of it on top of
> > > 
> > >      git://git.pengutronix.de/git/pza/linux.git imx-drm/next
> > > 
> > > or take at least the i.MX specific patches (1-5) because of the
> > > dependency on the imx-drm OF helper conversion.
> 
> do you still want to take this series?
>
> As for the devicetree ACK, there is this (unwritten) rule that if the
> dt-maintainers do not respond after 3 weeks (and a ping mail to them)
> it should be considered acked. As this version of the series is sitting
> on the lists for a month now and nobody complained during the other
> 17 versions as well, I think we should be on the safe side :-)

Alright, let's assume silent approval.

> There is one slight catch. Patch 3 needs a little modification, as the
> THIS_MODULE ower of the imx_hdmi got meanwhile cleaned up.
> 
> So the patch would need to be modified as shown by the diff at the
> bottom. I'm not sure if you want Andy to repost the whole series again
> but I'll just post my fixed variant as reply to the origin v18 of patch 3
> for convenience.

No need to post this again, I can apply the patches and fix up the
remaining issues you and Russell pointed out in the process.

regards
Philipp


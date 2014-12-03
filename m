Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbaLCLww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:52:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50171 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbaLCLwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:52:50 -0500
Message-ID: <1417607520.5124.8.camel@pengutronix.de>
Subject: Re: [PATCH v15 06/12] dt-bindings: add document for dw_hdmi
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Andy Yan <andy.yan@rock-chips.com>
Cc: Mark Rutland <mark.rutland@arm.com>, heiko@sntech.de, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, ykk@rock-chips.com,
        devel@driverdev.osuosl.org, Pawel Moll <pawel.moll@arm.com>,
        linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Dave Airlie <airlied@redhat.com>, jay.xu@rock-chips.com,
        devicetree@vger.kernel.org, Zubair.Kakakhel@imgtec.com,
        Arnd Bergmann <arnd@arndb.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Sean Paul <seanpaul@chromium.org>, rmk+kernel@arm.linux.org.uk,
        mark.yao@rock-chips.com, fabio.estevam@freescale.com,
        Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, djkurtz@google.com,
        Kumar Gala <galak@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>,
        vladimir_zapolskiy@mentor.com, Lucas Stach <l.stach@pengutronix.de>
Date: Wed, 03 Dec 2014 12:52:00 +0100
In-Reply-To: <547EDBEE.70700@rock-chips.com>
References: <1417505778-18341-1-git-send-email-andy.yan@rock-chips.com>
	 <1417506124-18626-1-git-send-email-andy.yan@rock-chips.com>
	 <1417544629.3411.15.camel@pengutronix.de> <547EDBEE.70700@rock-chips.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 03.12.2014, 17:46 +0800 schrieb Andy Yan:
> On 2014年12月03日 02:23, Philipp Zabel wrote:
> > Hi Andy,
> >
> > Am Dienstag, den 02.12.2014, 15:42 +0800 schrieb Andy Yan:
> >> diff --git a/Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt b/Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt
> >> new file mode 100644
> >> index 0000000..107c1ca
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/drm/bridge/dw_hdmi.txt
> >> @@ -0,0 +1,40 @@
> >> +DesignWare HDMI bridge bindings
> >> +
> >> +Required properities:
> >> +- compatible: platform specific such as:
> >> +   * "fsl,imx6q-hdmi"
> >> +   * "fsl,imx6dl-hdmi"
> >> +   * "rockchip,rk3288-dw-hdmi"
> > I think we should add a common compatible value "snps,dw-hdmi-tx" here:
> >
> > 	compatible = "fsl,imx6q-hdmi", "snps,dw-hdmi-tx";
> >
> >> +- reg: Physical base address and length of the controller's registers.
> >> +- ddc-i2c-bus: phandle of an I2C controller used for DDC EDID probing
> > Better make ddc-i2c-bus optional, see the other thread about the ddc i2c
> > master.
>      I have the same idea too, but the patch about ddc i2c master has not
>   landed yet,  can we change the ddc-i2c-bus to optional  after the ddc 
> i2c master
>   patch land?

Check out Documentation/devicetree/bindings/drm/imx/hdmi.txt, it was
already marked as optional. We can't make it required now.

regards
Philipp


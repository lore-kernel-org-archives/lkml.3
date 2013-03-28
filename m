Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3C1JFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 05:05:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37604 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab3C1JFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 05:05:42 -0400
Message-ID: <1364461518.4018.4.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v9 RESEND 4/4] ARM: dts: add sram for imx53 and imx6q
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
Date: Thu, 28 Mar 2013 10:05:18 +0100
In-Reply-To: <20130328025422.GH5429@S2101-09.ap.freescale.net>
References: <1363776767-2635-1-git-send-email-p.zabel@pengutronix.de>
	 <1363776767-2635-5-git-send-email-p.zabel@pengutronix.de>
	 <20130328025422.GH5429@S2101-09.ap.freescale.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 28.03.2013, 10:54 +0800 schrieb Shawn Guo:
> On Wed, Mar 20, 2013 at 11:52:47AM +0100, Philipp Zabel wrote:
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
> > Acked-by: Grant Likely <grant.likely@secretlab.ca>
> > ---
> > Changes since v8:
> >  - Changed device tree compatible string to "mmio-sram"
> > ---
> >  arch/arm/boot/dts/imx53.dtsi |    5 +++++
> >  arch/arm/boot/dts/imx6q.dtsi |    6 ++++++
> >  2 files changed, 11 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/imx53.dtsi b/arch/arm/boot/dts/imx53.dtsi
> > index edc3f1e..69d0680 100644
> > --- a/arch/arm/boot/dts/imx53.dtsi
> > +++ b/arch/arm/boot/dts/imx53.dtsi
> > @@ -664,5 +664,10 @@
> >  				status = "disabled";
> >  			};
> >  		};
> > +
> > +		ocram: ocram@f8000000 {
> > +			compatible = "fsl,imx-ocram", "mmio-sram";
> 
> We should probably just drop "fsl,imx-ocram".
> 
> Shawn

I thought that in the future somebody might want to implement some i.MX
OCRAM specifics in a different driver, like the L2 cache / OCRAM mode
switching, the timing settings, or the TrustZone bits that are
configurable in the IOMUXC GPR registers.

regards
Philipp


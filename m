Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244Ab3IBIxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:53:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33994 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758056Ab3IBIxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:53:06 -0400
Date: Mon, 2 Sep 2013 10:52:38 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Xiubo Li-B47053 <B47053@freescale.com>
Cc: Guo Shawn-R65073 <r65073@freescale.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCHv2 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM.
Message-ID: <20130902085238.GR30088@pengutronix.de>
Mail-Followup-To: Xiubo Li-B47053 <B47053@freescale.com>,
	Guo Shawn-R65073 <r65073@freescale.com>,
	"thierry.reding@gmail.com" <thierry.reding@gmail.com>,
	"grant.likely@linaro.org" <grant.likely@linaro.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	"rob@landley.net" <rob@landley.net>,
	"ian.campbell@citrix.com" <ian.campbell@citrix.com>,
	"swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>,
	"pawel.moll@arm.com" <pawel.moll@arm.com>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
References: <1377856132-11290-1-git-send-email-Li.Xiubo@freescale.com>
 <1377856132-11290-5-git-send-email-Li.Xiubo@freescale.com>
 <20130830173008.GC30069@pengutronix.de>
 <1DD289F6464F0949A2FCA5AA6DC23F827F7831@039-SN2MPN1-011.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1DD289F6464F0949A2FCA5AA6DC23F827F7831@039-SN2MPN1-011.039d.mgd.msft.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:51:19 up 8 days, 18:22, 33 users,  load average: 0.06, 0.03, 0.21
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 02:38:53AM +0000, Xiubo Li-B47053 wrote:
> > Subject: Re: [PATCHv2 4/4] Documentation: Add device tree bindings for
> > Freescale FTM PWM.
> > 
> ...
> > > +
> > > +pwm0: pwm@40038000 {
> > > +		compatible = "fsl,vf610-ftm-pwm";
> > > +		reg = <0x40038000 0x1000>;
> > > +		#pwm-cells = <3>;
> > > +		clock-names = "ftm0", "ftm0_fix_sel", "ftm0_ext_sel";
> > > +		clocks = <&clks VF610_CLK_FTM0>,
> > > +			<&clks VF610_CLK_FTM0_FIX_SEL>,
> > > +			<&clks VF610_CLK_FTM0_EXT_SEL>;
> > > +		pinctrl-names = "ch0-active", "ch0-idle", "ch1-active", "ch1-
> > idle",
> > > +		....;
> > > +		pinctrl-0 = <&pinctrl_pwm0_ch0_active>;
> > > +		pinctrl-1 = <&pinctrl_pwm0_ch0_idle>;
> > > +		pinctrl-2 = <&pinctrl_pwm0_ch1_active>;
> > > +		pinctrl-3 = <&pinctrl_pwm0_ch1_idle>;
> > > +		...
> > > +		fsl,pwm-counter-clk = "ftm0_ext_sel";
> > > +		fsl,pwm-avaliable-chs = <0 3 5 6>;
> > 
> > I don't think this proerty is useful. Just enable all channels. I think
> > this was mentioned before.
> > 
> Yes.
> Actully this property is located in board level dts file.
> I have added and requested all the channels in SoC level dtsi file,
> and in board level dts file to tell the customer the limitation, I
> think is much safter and better.

Why should this be in the board file? A pwm that is not available should
simply not be referenced and thus be unused. No need to explicitly
disable it.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

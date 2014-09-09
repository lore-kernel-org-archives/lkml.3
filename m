Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbaIIHex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:34:53 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50016 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaIIHev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:34:51 -0400
Date: Tue, 9 Sep 2014 08:34:46 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 2/3] phy: phy-stih407-usb: Add dt documentation for USB
 picophy found on stih407 SoC family
Message-ID: <20140909073446.GB7620@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1409740079-16554-1-git-send-email-peter.griffin@linaro.org>
 <1409740079-16554-3-git-send-email-peter.griffin@linaro.org>
 <540DCB91.7060702@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540DCB91.7060702@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

Thanks for reviewing :-)

> > +On STiH410, we have to use the DWC3 port#2 with a picoPHY to manage USB2
> > +devices. The USB2 Controller will use the ports #0 and #1.
> > +
> > +This is to document the DT parameters to be passed from the blob in that case.
> > +
> > +Required properties:
> > +- compatible		: should be "st,stih407-usb2-phy"
> 
> If STiH410 also uses the same driver then you should add a new compatibility
> value for it.

I will remove the reference to stih410 in V2, as currently it is not supported
upstream, and I'm not sure what ST's plans are regarding upstreaming it. If/
when it is upstreamed, we can add this and a compabible property back in.

<snip>
> > +
> > +usb2_picophy0: usbpicophy@0 {
> usbpicophy@f8 since you have a reg property ;-)

will fix in V2

> 
> > +	compatible	= "st,stih407-usb2-phy";
> > +	reg		= <0xf8 0x04>,	/* syscfg 5062 */
> > +			  <0xf4 0x04>;	/* syscfg 5061 */
> > +	reg-names	= "param",
> > +			  "ctrl";
> > +			  #phy-cells = <0>;
> 
> alignment seems to have gone wrong here.

Will fix in v2

regards,

Peter.

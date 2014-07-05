Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651AbaGEGPG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 02:15:06 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35232 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbaGEGPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 02:15:03 -0400
Date: Sat, 5 Jul 2014 07:14:58 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Daniele Forsi <dforsi@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, devicetree@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, USB list <linux-usb@vger.kernel.org>,
        linux-omap@vger.kernel.org, lee.jones@linaro.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 2/3] ARM: dts: sti: Add st-dwc3 devicetree bindings
 documentation
Message-ID: <20140705061458.GB8146@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1404472432-24764-1-git-send-email-peter.griffin@linaro.org>
 <1404472432-24764-3-git-send-email-peter.griffin@linaro.org>
 <CAN_we7Mqm0ScULzCSNwmb46MAQNcfckSZ9+iH_3pCfv+VTyUMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN_we7Mqm0ScULzCSNwmb46MAQNcfckSZ9+iH_3pCfv+VTyUMg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniele,

Thanks for reviewing.

On Fri, 04 Jul 2014, Daniele Forsi wrote:
> 2014-07-04 13:13 GMT+02:00 Peter Griffin:
> 
> > +Required properties:
> > + - compatible  : must be "st,stih407-dwc3"
> > + - reg         : glue logic base address and USB syscfg ctrl register offest
> > + - reg-names   : Should be "reg-glue" and "syscfg-reg".
> > + - st,syscon    : should be phandle to system configuration node which
> > +                 encompases the glue registers.
> > + - resets       : phandle pointing to the system powerdown controller
> 
> minor knits:
> s/offest/offset/
> s/encompases/encompasses/
> "Should" is upper case while all other lines in this block start with
> a lower case letter;
> two lines end with a full stop, three lines without;
> colons the last lines do not align to the first three

All fixed in V2.

Regards,

Peter.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760503AbaGEF45 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 01:56:57 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:45542 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbaGEF4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 01:56:55 -0400
Date: Sat, 5 Jul 2014 06:56:50 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Daniele Forsi <dforsi@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, devicetree@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, USB list <linux-usb@vger.kernel.org>,
        linux-omap@vger.kernel.org, lee.jones@linaro.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 1/3] usb: dwc3: add ST dwc3 glue layer to manage dwc3 HC
Message-ID: <20140705055650.GA8146@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1404472432-24764-1-git-send-email-peter.griffin@linaro.org>
 <1404472432-24764-2-git-send-email-peter.griffin@linaro.org>
 <CAN_we7O2AMpace_oxBoxBO_jT82MnL9B-mzchozncMzp4_kZ=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN_we7O2AMpace_oxBoxBO_jT82MnL9B-mzchozncMzp4_kZ=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniele,

Thankyou for reviewing.

> > +config USB_DWC3_ST
> > +       tristate "STMicroelectronics Platforms"
> > +       depends on ARCH_STI && OF
> > +       default USB_DWC3_HOST
> > +       help
> > +         STMicroelectronics SoCs chip with one DesignWare Core USB3 IP
> > +         inside (i.e. STiH407).
> > +
> >           Say 'Y' or 'M' here if you have one such device
> >
> >  comment "Debugging features"
> 
> you are actually removing the line "Say 'Y' or 'M' here if you have
> one such device" from the previous item

Whoops, good spot. I've fixed in V2, and added the same sentence for this
new entry as well.

I've also replaced "STMicroelectronics SoCs chip with one DesignWare Core"
with "STMicroelectronics SoCs with one DesignWare Core".

regards,

Peter.


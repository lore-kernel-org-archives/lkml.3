Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab3GPMdB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:33:01 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:10794 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932119Ab3GPMdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:33:00 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+s/gFRFtPooc19I3cb7Jqt
Date: Tue, 16 Jul 2013 05:32:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: benoit.cousson@linaro.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Balbi, Felipe" <balbi@ti.com>
Subject: Re: [PATCH v2 4/4] ARM: OMAP2+: Provide alias to USB PHY clock
Message-ID: <20130716123256.GY7656@atomide.com>
References: <1371571487-14389-1-git-send-email-rogerq@ti.com>
 <1371571487-14389-5-git-send-email-rogerq@ti.com>
 <51E40199.9070906@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E40199.9070906@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [130715 07:11]:
> Hi Tony,
> 
> On 06/18/2013 07:04 PM, Roger Quadros wrote:
> > Till the OMAP clocks are correctly defined in device tree, use
> > this temporary hack to provide clock alias to the USB PHY clocks.
> > 
> > Without this, USB Host & Ethernet will not be functional with
> > device tree boots on Panda and uEVM.
> 
> Looks like this one got missed out.
> 
> USB host no longer works on Panda with DT boot.
> Could you please queue this for next 3.11-rc? Thanks.

OK thanks for checking, applying into omap-for-v3.11/fixes.

Looks like I also have some pending the .dts changes in
omap-for-v3.11/dt branch:

4cf2198b1e3cee47a1cccbb500b67782c36615d5 ARM: dts: omap3-beagle-xm: Add USB host supprot for Rev. Ax/Bx
9bc44515819a00c0ffaf751ad497ddf275089ede ARM: dts: omap3-beagle-xm: Add USB Host support
fd65d7df4598c1d2ad27d664c719611a1a070edc ARM: dts: omap3-beagle: Make USB host pin naming consistent
39ea891d9da6ae1824bc9f689db3f306f5ce0724 ARM: dts: omap4-panda: Add USB Host support

Those should get merged as fixes, right? Can you please
check and see if they're still OK or if we also need
something else?

Regards,

Tony

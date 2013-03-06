Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab3CFRxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 12:53:19 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52677 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753474Ab3CFRxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 12:53:18 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/9FLhNt2dbkQXISgcZQDm8
Date: Wed, 6 Mar 2013 09:53:13 -0800
From: Tony Lindgren <tony@atomide.com>
To: Anil Kumar <anilk4.v@gmail.com>
Cc: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, b-cousson@ti.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Weber <thomas@tomweber.eu>
Subject: Re: [PATCH V4] ARM: dts: add minimal DT support for DevKit8000.
Message-ID: <20130306175313.GQ11806@atomide.com>
References: <F3DBB1B3EF102E4994C89758CFCA32412CC4E9@DBDE01.ent.ti.com>
 <CABYxbz5GyxYaHANgdpwBNaaR6tnu=6LJuUNSvL7DEzU=4CPHcA@mail.gmail.com>
 <F3DBB1B3EF102E4994C89758CFCA32412CC74F@DBDE01.ent.ti.com>
 <CABYxbz62JrMB95p5i9iu2G=B4ETXLrYbLsyFEFR5F+WVD6YNnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABYxbz62JrMB95p5i9iu2G=B4ETXLrYbLsyFEFR5F+WVD6YNnQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anil Kumar <anilk4.v@gmail.com> [130305 18:40]:
> Hi Tony,
> 
> >> From: linux-arm-kernel [mailto:linux-arm-kernel-
> >> bounces@lists.infradead.org] On Behalf Of Anil Kumar
> >> Sent: Wednesday, February 27, 2013 8:03 AM
> >> To: devicetree-discuss@lists.ozlabs.org; linux-omap@vger.kernel.org;
> >> linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
> >> Cc: linux@arm.linux.org.uk; Cousson, Benoit; Tony Lindgren; Grant
> >> Likely; Anil Kumar; thomas@tomweber.eu
> >> Subject: Re: FW: [PATCH V4] ARM: dts: add minimal DT support for
> >> DevKit8000.
> >>
> >> Hi,
> >> >
> >> > DevKit8000 is a beagle board clone from Timll, sold by
> >> > armkits.com. The DevKit8000 has RS232 serial port, LCD, DVI-D,
> >> > S-Video, Ethernet, SD/MMC, keyboard, camera, SPI, I2C, USB and
> >> > JTAG interface.
> >> >
> >> > This patch adds the basic DT support for devkit8000. At this time,
> >> Information
> >> > of twl4030 (PMIC), MMC1, I2C1 and leds are added.
> >> >
> >> > Signed-off-by: Anil Kumar <anilk4.v@gmail.com>
> >> > Tested-by: Thomas Weber <thomas@tomweber.eu>
> >>
> >> Gentle Ping. As there are no review comments on this patch,
> >> Could you please pull this patch ?
> 
> Gentle Ping.
> 
> This patch also got Reviewed-by: Manish Badarkhe <badarkhe.manish@gmail.com>
> and as patch "ARM: dts: omap3-devkit8000: Enable audio support"  has already got
> "Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>" but it is on the
> top of this patch.
> So, Could you please pull this patch in one of your omap branch? or
> you want me to
> do rebase this patch on top of v3.9-rc1 ?

Let's wait for Benoit to queue it as he has a bunch of .dts changes already
applied. Too bad we missed v3.9 merge window for those, but hopefully
we can get them queued early for v3.10.

Regards,

Tony

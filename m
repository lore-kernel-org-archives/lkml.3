Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaGKG2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 02:28:20 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:47757 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbaGKG2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 02:28:18 -0400
Date: Fri, 11 Jul 2014 09:28:11 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Harini Katakam <harinik@xilinx.com>, Pawel Moll <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harinikatakamlinux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Harini Katakam <harini.katakam@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/2] gpio: Add driver for Zynq GPIO controller
Message-ID: <20140711062811.GC3003@tarshish>
References: <1403091577-10232-1-git-send-email-harinik@xilinx.com>
 <5cc8b89b-20ff-4fa9-92dd-bb2f6d3512d8@BY2FFO11FD030.protection.gbl>
 <CACRpkdb1M3-hrSKLKWz21LCJ1sMvsq5E-aqkpmVhy0NwOS5HhA@mail.gmail.com>
 <20140707152309.GH4939@tarshish>
 <CACRpkdY+3hy5iw=uRdmu665NWsoGacTMgjUq97219kEcfn7Dqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdY+3hy5iw=uRdmu665NWsoGacTMgjUq97219kEcfn7Dqw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Jul 08, 2014 at 11:27:57AM +0200, Linus Walleij wrote:
> On Mon, Jul 7, 2014 at 5:23 PM, Baruch Siach <baruch@tkos.co.il> wrote:
> > On Mon, Jul 07, 2014 at 04:51:56PM +0200, Linus Walleij wrote:
> 
> >> This needs someone to step in and provide a replacement, my preferred
> >> mechanism would be a /dev/gpiochip0/... hierarchy using char devices.
> >
> > I really like the ability to control GPIOs from shell, both interactively and
> > scripted. I find it useful for quick hardware level debugging,
> 
> I would be happy to carry it in the unstable-ABI debugfs for sure.
> It's the supported ABI that bothers me.
> 
> > and for boot
> > time scripting (mainly in initramfs).
> 
> What is the usecase here?

During boot I need to know, for example, when an FPGA is ready to be 
programmed, and when said FPGA has finished its initialization. I also read 
the sate of on-board DIP switches to determine the desired boot method. I find 
the current sysfs interface quite convenient for these and similar tasks.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -

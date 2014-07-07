Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaGGPXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:23:21 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:47561 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaGGPXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:23:16 -0400
Date: Mon, 7 Jul 2014 18:23:09 +0300
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
Message-ID: <20140707152309.GH4939@tarshish>
References: <1403091577-10232-1-git-send-email-harinik@xilinx.com>
 <5cc8b89b-20ff-4fa9-92dd-bb2f6d3512d8@BY2FFO11FD030.protection.gbl>
 <CACRpkdb1M3-hrSKLKWz21LCJ1sMvsq5E-aqkpmVhy0NwOS5HhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdb1M3-hrSKLKWz21LCJ1sMvsq5E-aqkpmVhy0NwOS5HhA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linux,

On Mon, Jul 07, 2014 at 04:51:56PM +0200, Linus Walleij wrote:
> On Wed, Jun 18, 2014 at 5:36 PM, Sören Brinkmann <soren.brinkmann@xilinx.com> wrote:
> > The first is, how is userspace supposed to find the correct offset for a
> > GPIO pin.
> 
> The sysfs interface to GPIO is *NOT* *GOOD* this is universally
> agreed upon.
> 
> This needs someone to step in and provide a replacement, my preferred
> mechanism would be a /dev/gpiochip0/... hierarchy using char devices.

I really like the ability to control GPIOs from shell, both interactively and 
scripted. I find it useful for quick hardware level debugging, and for boot 
time scripting (mainly in initramfs). Do you intend to preserve this 
capability in the future? Will I need a special utility (or Busybox applet) to 
do this with char device ioctl?

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
